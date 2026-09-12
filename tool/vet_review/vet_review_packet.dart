import 'package:pawhealth/data/decision_trees/decision_tree.dart';
import 'package:pawhealth/data/decision_trees/symptom_catalog.dart';
import 'package:pawhealth/l10n/app_localizations.dart';
import 'package:pawhealth/models/pet.dart';
import 'package:pawhealth/utils/l10n_helpers.dart';

/// The languages in the packet, in column order.
const packetLanguages = ['en', 'th', 'zh'];

const _languageNames = {'en': 'English', 'th': 'ไทย', 'zh': '中文'};

/// A symptom tree in reading order: questions and outcomes numbered as a
/// reviewer meets them, walking the tree from its first question.
class TreeOutline {
  final SymptomDefinition symptom;
  final List<QuestionNode> questions;
  final List<ResultNode> outcomes;

  /// Node id → "Q3" / "O2".
  final Map<String, String> labels;

  TreeOutline._(this.symptom, this.questions, this.outcomes, this.labels);

  factory TreeOutline.of(SymptomDefinition symptom) {
    final questions = <QuestionNode>[];
    final outcomes = <ResultNode>[];
    final labels = <String, String>{};
    final queue = [symptom.startNodeId];
    while (queue.isNotEmpty) {
      final id = queue.removeAt(0);
      if (labels.containsKey(id)) continue;
      switch (symptom.tree[id]) {
        case QuestionNode node:
          questions.add(node);
          labels[id] = 'Q${questions.length}';
          queue.addAll(node.options.map((o) => o.nextNodeId));
        case ResultNode node:
          outcomes.add(node);
          labels[id] = 'O${outcomes.length}';
        case null:
          throw StateError('${symptom.id}: dangling node "$id"');
      }
    }
    return TreeOutline._(symptom, questions, outcomes, labels);
  }
}

/// Everything the packet is built from.
class VetReviewInput {
  /// One AppLocalizations per entry in [packetLanguages].
  final Map<String, AppLocalizations> l10n;

  /// The `articles` list from tool/seed_articles/articles.json.
  final List<Map<String, dynamic>> articles;

  /// Shown on the cover so a returned review can be matched to the code.
  final String version;
  final DateTime generatedAt;

  const VetReviewInput({
    required this.l10n,
    required this.articles,
    required this.version,
    required this.generatedAt,
  });
}

/// The rendered packet, plus what a reviewer would otherwise miss.
class VetReviewPacket {
  final String html;

  /// Strings shown in English because a translation is missing, as
  /// "tree/node (language)".
  final List<String> untranslated;

  final int questionCount;
  final int outcomeCount;

  const VetReviewPacket._(
    this.html,
    this.untranslated,
    this.questionCount,
    this.outcomeCount,
  );
}

VetReviewPacket buildVetReviewPacket(VetReviewInput input) =>
    _PacketWriter(input).write();

class _PacketWriter {
  final VetReviewInput input;
  final _out = StringBuffer();
  final _untranslated = <String>[];

  _PacketWriter(this.input);

  AppLocalizations get _en => input.l10n['en']!;

  VetReviewPacket write() {
    final outlines = [for (final s in symptomCatalog) TreeOutline.of(s)];
    final questions = outlines.fold(0, (n, t) => n + t.questions.length);
    final outcomes = outlines.fold(0, (n, t) => n + t.outcomes.length);

    _out.write('<!DOCTYPE html><html lang="en"><head><meta charset="utf-8">');
    _out.write('<title>PawHealth vet review ${_date()}</title>');
    _out.write('<style>$_css</style></head><body>');
    _cover(outlines, questions, outcomes);
    _glossary();
    for (final (i, outline) in outlines.indexed) {
      _tree(i + 1, outline);
    }
    for (final (i, article) in input.articles.indexed) {
      _article(i + 1, article);
    }
    _signOff();
    _out.write('</body></html>');

    return VetReviewPacket._(
      _out.toString(),
      List.unmodifiable(_untranslated),
      questions,
      outcomes,
    );
  }

  String _date() {
    final d = input.generatedAt;
    return '${d.year}-${_two(d.month)}-${_two(d.day)}';
  }

  static String _two(int n) => n.toString().padLeft(2, '0');

  /// One string per language; a translation identical to the English is
  /// flagged (the app falls back to English for missing ones).
  Map<String, String> _texts(
    String where,
    String Function(AppLocalizations l10n) text,
  ) {
    final english = text(_en);
    return {
      for (final lang in packetLanguages)
        lang: () {
          final value = text(input.l10n[lang]!);
          if (lang != 'en' && value == english) {
            _untranslated.add('$where ($lang)');
          }
          return value;
        }(),
    };
  }

  void _cells(Map<String, String> texts) {
    for (final lang in packetLanguages) {
      final value = texts[lang]!;
      final missing = lang != 'en' && value == texts['en'];
      _out.write('<td lang="$lang"${missing ? ' class="missing"' : ''}>');
      _out.write(missing ? '⚠ Not translated: ${_e(value)}' : _e(value));
      _out.write('</td>');
    }
  }

  String _levelChip(TriageLevel level) {
    final label = switch (level) {
      TriageLevel.emergency => 'EMERGENCY',
      TriageLevel.vet => 'SEE A VET',
      TriageLevel.monitor => 'MONITOR',
    };
    return '<span class="chip ${level.name}">$label</span>';
  }

  void _cover(List<TreeOutline> outlines, int questions, int outcomes) {
    final emergencies = outlines.fold(
      0,
      (n, t) =>
          n + t.outcomes.where((o) => o.level == TriageLevel.emergency).length,
    );
    _out.write('''
<section class="cover">
  <p class="eyebrow">PawHealth · Veterinary content review</p>
  <h1>Symptom checker and health articles</h1>
  <p class="meta">Generated ${_date()} · content version <code>${_e(input.version)}</code></p>

  <p>PawHealth is a pet-health app for dog and cat owners in Thailand, used in
  English, Thai and Chinese. Before launch, a veterinarian must check
  everything the app says about health. This packet is all of it:</p>
  <ul>
    <li><b>Part A: symptom checker</b>. ${outlines.length} question flows,
    $questions questions and $outcomes outcomes ($emergencies of them emergencies).
    An owner answers the questions, and the app then gives one outcome: an urgency
    level and advice.</li>
    <li><b>Part B: health articles</b>. ${input.articles.length} short
    articles for the app's Articles tab.</li>
  </ul>

  <h2>What we ask you to check</h2>
  <ol>
    <li><b>Urgency.</b> Is each outcome's level right (Emergency / See a vet / Monitor)?
    Is anything dangerous ever sent to "Monitor"?</li>
    <li><b>Thresholds.</b> Are the cut-offs right (e.g. 4 or more vomits in 24 hours = emergency)?</li>
    <li><b>Missing red flags.</b> Should any flow ask about something it doesn't?</li>
    <li><b>Advice.</b> Is it accurate, safe for an owner to follow at home, and clear?</li>
    <li><b>Translations.</b> The Thai and Chinese were not written by a medical
    translator. Please flag anything unclear or unusual, if you read either language.</li>
  </ol>

  <h2>Specific points to confirm</h2>
  <ul>
    <li><b>Dog vomiting:</b> a "No symptoms / General checkup" answer that led to
    "Your pet seems healthy!" was removed as false reassurance. Please confirm.</li>
    <li><b>Vaccines article:</b> start ages (6–8 weeks), booster intervals
    (puppies every 2–4 weeks, kittens every 3–4, until about 16 weeks), and adult boosters every 1–3 years.</li>
    <li><b>Vaccines article:</b> "In Thailand, rabies vaccination is required by law."</li>
    <li><b>Vomiting article:</b> after a single episode in a bright adult pet, "ask
    your vet whether to rest the stomach for a few hours, then offer small, bland meals".</li>
    <li><b>Scope:</b> the checker covers dogs and cats only. Owners of rabbits,
    birds and exotic pets see no symptom flows.</li>
  </ul>

  <h2>How to mark your review</h2>
  <p>Write corrections in the <b>Vet notes</b> column, or on the page next
  to the text. Each flow and article ends with an approval box. Please
  initial every page.</p>
</section>''');
  }

  void _glossary() {
    _out.write('<section class="page"><h2>How owners see a result</h2>');
    _out.write(
      '<p>Every outcome shows one of three urgency levels, its advice, and '
      'this disclaimer. These texts appear on every result:</p>',
    );
    _out.write('<table><thead><tr><th class="id">Shown as</th>');
    for (final lang in packetLanguages) {
      _out.write('<th>${_languageNames[lang]}</th>');
    }
    _out.write('<th class="notes">Vet notes</th></tr></thead><tbody>');
    for (final level in TriageLevel.values.reversed) {
      _out.write('<tr><td class="id">${_levelChip(level)}</td>');
      _cells(
        _texts(
          'triage/${level.name}',
          (l) => L10nHelpers.triageLabel(l, level),
        ),
      );
      _out.write('<td class="notes"></td></tr>');
    }
    _out.write('<tr><td class="id">Disclaimer</td>');
    _cells(_texts('disclaimer', (l) => l.medicalDisclaimer));
    _out.write('<td class="notes"></td></tr></tbody></table></section>');
  }

  void _tree(int number, TreeOutline outline) {
    final symptom = outline.symptom;
    final species = [
      for (final s in symptom.species)
        L10nHelpers.species(_en, PetSpecies.values.byName(s)),
    ].join(' & ');
    final names = _texts(
      '${symptom.id}/name',
      (l) => L10nHelpers.symptomName(l, symptom.id),
    );

    _out.write('<section class="page">');
    _out.write(
      '<p class="eyebrow">Part A · Symptom checker · Flow A$number of '
      '${symptomCatalog.length}</p>',
    );
    _out.write(
      '<h2>A$number. ${_e(names['en']!)} <small>($species)</small></h2>',
    );
    _out.write(
      '<p class="names">${_e(names['th']!)} · ${_e(names['zh']!)} · '
      '<code>${_e(symptom.id)}</code></p>',
    );
    _out.write(
      '<p class="hint">The owner starts at Q1. Each answer leads to another '
      'question or to an outcome (listed after the questions).</p>',
    );

    for (final question in outline.questions) {
      final label = outline.labels[question.id]!;
      _out.write('<table class="question"><thead><tr>');
      _out.write('<th class="id">$label</th>');
      _cells(
        _texts(
          '${symptom.id}/${question.id}',
          (l) => L10nHelpers.question(l, question),
        ),
      );
      _out.write(
        '<th class="goto">Leads to</th><th class="notes">Vet notes</th>'
        '</tr></thead><tbody>',
      );
      for (final (i, option) in question.options.indexed) {
        final next = symptom.tree[option.nextNodeId]!;
        final target = outline.labels[option.nextNodeId]!;
        final goesTo = switch (next) {
          ResultNode(:final level) => '→ $target ${_levelChip(level)}',
          QuestionNode() => '→ $target',
        };
        _out.write('<tr><td class="id">${String.fromCharCode(97 + i)})</td>');
        final texts = _texts(
          '${symptom.id}/${question.id}/option ${i + 1}',
          (l) => L10nHelpers.option(l, option),
        );
        _cells(texts);
        _out.write('<td class="goto">$goesTo</td><td class="notes"></td></tr>');
      }
      _out.write('</tbody></table>');
    }

    _out.write('<h3>Outcomes</h3><table class="outcomes"><thead><tr>');
    _out.write('<th class="id">Outcome</th>');
    for (final lang in packetLanguages) {
      _out.write('<th>${_languageNames[lang]}</th>');
    }
    _out.write('<th class="notes">Vet notes</th></tr></thead><tbody>');
    for (final outcome in outline.outcomes) {
      _out.write(
        '<tr><td class="id">${outline.labels[outcome.id]}<br>'
        '${_levelChip(outcome.level)}</td>',
      );
      _cells(
        _texts(
          '${symptom.id}/${outcome.id}',
          (l) => L10nHelpers.advice(l, outcome),
        ),
      );
      _out.write('<td class="notes"></td></tr>');
    }
    _out.write('</tbody></table>');
    _approval('Flow A$number');
    _out.write('</section>');
  }

  void _article(int number, Map<String, dynamic> article) {
    final title = (article['title'] as Map).cast<String, String>();
    final content = (article['content'] as Map).cast<String, String>();
    _out.write('<section class="page">');
    _out.write(
      '<p class="eyebrow">Part B · Health articles · Article B$number of '
      '${input.articles.length} · ${_e(article['category'] as String)}</p>',
    );
    _out.write('<h2>B$number. ${_e(title['en']!)}</h2>');
    _out.write('<div class="columns">');
    for (final lang in packetLanguages) {
      _out.write(
        '<div lang="$lang"><h3>${_languageNames[lang]}: ${_e(title[lang]!)}</h3>',
      );
      for (final paragraph in content[lang]!.split('\n\n')) {
        final lines = paragraph.split('\n');
        final bullets = lines.where((l) => l.startsWith('• ')).toList();
        final lead = lines.where((l) => !l.startsWith('• ')).join(' ');
        if (lead.isNotEmpty) _out.write('<p>${_e(lead)}</p>');
        if (bullets.isNotEmpty) {
          _out.write('<ul>');
          for (final b in bullets) {
            _out.write('<li>${_e(b.substring(2))}</li>');
          }
          _out.write('</ul>');
        }
      }
      _out.write('</div>');
    }
    _out.write('</div>');
    _approval('Article B$number');
    _out.write('</section>');
  }

  void _approval(String what) {
    _out.write('''
<div class="approval">
  <b>$what:</b>
  <span>☐ Approved as is</span>
  <span>☐ Approved with the changes marked</span>
  <span>☐ Needs rework</span>
  <span class="initials">Initials: ________</span>
</div>''');
  }

  void _signOff() {
    _out.write('''
<section class="page signoff">
  <h2>Reviewer sign-off</h2>
  <p>I have reviewed the symptom-checker flows and health articles in this
  packet (content version <code>${_e(input.version)}</code>). My corrections
  are marked. With those corrections, the content is suitable to give pet
  owners as general guidance. It does not replace an examination by a
  veterinarian.</p>
  <table class="sign">
    <tr><td>Name</td><td></td></tr>
    <tr><td>Veterinary licence no.</td><td></td></tr>
    <tr><td>Clinic / organisation</td><td></td></tr>
    <tr><td>Languages reviewed</td><td>☐ English ☐ ไทย ☐ 中文</td></tr>
    <tr><td>Signature</td><td></td></tr>
    <tr><td>Date</td><td></td></tr>
  </table>
</section>''');
  }

  static String _e(String s) => s
      .replaceAll('&', '&amp;')
      .replaceAll('<', '&lt;')
      .replaceAll('>', '&gt;')
      .replaceAll('"', '&quot;');
}

const _css = r'''
@page { size: A4 landscape; margin: 12mm; }
:root { --ink:#1f2623; --muted:#5c6661; --line:#d9d4cc; --brand:#3f7a6b; }
* { box-sizing: border-box; }
body { margin: 0 auto; max-width: 1400px; padding: 16px;
  font: 11pt/1.45 -apple-system, "Segoe UI", "Noto Sans", "Noto Sans Thai",
  "Sukhumvit Set", "Leelawadee UI", "PingFang SC", "Microsoft YaHei",
  "Noto Sans SC", sans-serif; color: var(--ink); }
h1 { font-size: 24pt; margin: 4px 0 8px; }
h2 { font-size: 16pt; margin: 18px 0 6px; }
h2 small { font-weight: normal; color: var(--muted); font-size: 11pt; }
h3 { font-size: 12pt; margin: 14px 0 6px; }
code { font-size: 9pt; color: var(--muted); }
.eyebrow { text-transform: uppercase; letter-spacing: .08em; font-size: 8.5pt;
  color: var(--brand); margin: 0; font-weight: 600; }
.meta, .names, .hint { color: var(--muted); margin: 2px 0 8px; }
.page { break-before: page; padding-top: 4px; }
table { width: 100%; border-collapse: collapse; margin: 8px 0 12px;
  table-layout: fixed; break-inside: avoid; }
th, td { border: 1px solid var(--line); padding: 5px 7px; vertical-align: top;
  text-align: left; }
thead th { background: #f4f1ec; font-weight: 600; }
table.question thead th, table.question thead td { background: #eaf3f0;
  font-weight: 600; }
th.id, td.id { width: 7%; white-space: nowrap; }
th.notes, td.notes { width: 19%; }
td.missing { background: #fff4d6; }
.goto { width: 13%; font-size: 9.5pt; white-space: nowrap; }
.chip { display: inline-block; border-radius: 4px; padding: 1px 5px;
  font-size: 8pt; font-weight: 700; letter-spacing: .03em; color: #fff; }
.chip.emergency { background: #b3261e; }
.chip.vet { background: #b86e00; }
.chip.monitor { background: #3f7a6b; }
.columns { display: grid; grid-template-columns: repeat(3, 1fr); gap: 16px; }
.columns p, .columns li { font-size: 10pt; margin: 0 0 6px; }
.columns ul { padding-left: 18px; margin: 0 0 8px; }
.approval { display: flex; flex-wrap: wrap; gap: 18px; align-items: center;
  border: 1.5px solid var(--ink); padding: 8px 12px; margin-top: 10px;
  break-inside: avoid; }
.approval .initials { margin-left: auto; }
table.sign td { height: 34px; }
table.sign td:first-child { width: 28%; font-weight: 600; }
.cover ul, .cover ol { margin-top: 4px; }
.cover li { margin-bottom: 4px; }
''';
