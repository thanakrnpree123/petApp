// Writes the vet review packet (HTML) to tool/vet_review/out/.
//
//     flutter test tool/vet_review/generate_test.dart
//
// A test file only because the app's localizations need Flutter; it lives
// outside test/ so the normal suite doesn't regenerate the packet.
import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:pawhealth/l10n/app_localizations_en.dart';
import 'package:pawhealth/l10n/app_localizations_th.dart';
import 'package:pawhealth/l10n/app_localizations_zh.dart';

import 'vet_review_packet.dart';

void main() {
  test('write the vet review packet', () async {
    final git = await Process.run('git', ['describe', '--always', '--dirty']);
    final articles =
        (jsonDecode(File('tool/seed_articles/articles.json').readAsStringSync())
                as Map<String, dynamic>)['articles']
            as List<dynamic>;
    final now = DateTime.now();

    final packet = buildVetReviewPacket(
      VetReviewInput(
        l10n: {
          'en': AppLocalizationsEn(),
          'th': AppLocalizationsTh(),
          'zh': AppLocalizationsZh(),
        },
        articles: articles.cast<Map<String, dynamic>>(),
        version: (git.stdout as String).trim(),
        generatedAt: now,
      ),
    );

    final date = now.toIso8601String().substring(0, 10);
    final file = File('tool/vet_review/out/pawhealth-vet-review-$date.html')
      ..createSync(recursive: true)
      ..writeAsStringSync(packet.html);

    // ignore: avoid_print
    print(
      'Wrote ${file.path}\n'
      '  ${packet.questionCount} questions, ${packet.outcomeCount} outcomes, '
      '${articles.length} articles\n'
      '  untranslated strings: ${packet.untranslated.length}'
      '${packet.untranslated.map((u) => '\n    $u').join()}',
    );
  });
}
