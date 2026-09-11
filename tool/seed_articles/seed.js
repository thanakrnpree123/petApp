#!/usr/bin/env node
// Seeds the `articles` collection from articles.json. See README.md.
//
//   node seed.js                          validate + show what would change
//   node seed.js --review > review.md     printable sheet for the vet review
//   node seed.js --apply --project <id>   write vet-reviewed articles
//
// Articles with "vet_reviewed": false are only written to the Firestore
// emulator (FIRESTORE_EMULATOR_HOST set) and only with
// --include-unreviewed: unreviewed medical advice never reaches real users.

'use strict';

const fs = require('fs');
const path = require('path');

const LANGUAGES = ['en', 'th', 'zh'];
// Must match L10nHelpers.articleCategory in the app.
const CATEGORIES = [
  'first_aid',
  'safety',
  'preventive_care',
  'nutrition',
  'symptoms',
];

function parseArgs(argv) {
  const args = { apply: false, review: false, includeUnreviewed: false };
  for (let i = 0; i < argv.length; i++) {
    const arg = argv[i];
    if (arg === '--apply') args.apply = true;
    else if (arg === '--review') args.review = true;
    else if (arg === '--include-unreviewed') args.includeUnreviewed = true;
    else if (arg === '--project') args.project = argv[++i];
    else if (arg === '--file') args.file = argv[++i];
    else throw new Error(`Unknown argument: ${arg}`);
  }
  return args;
}

/** Returns a list of problems; empty when the file is good to seed. */
function validate(articles) {
  const problems = [];
  const ids = new Set();
  articles.forEach((a, index) => {
    const where = a.id ? `"${a.id}"` : `#${index + 1}`;
    if (!/^[a-z0-9]+(-[a-z0-9]+)*$/.test(a.id || '')) {
      problems.push(`${where}: id must be kebab-case`);
    }
    if (ids.has(a.id)) problems.push(`${where}: duplicate id`);
    ids.add(a.id);
    if (!CATEGORIES.includes(a.category)) {
      problems.push(
        `${where}: unknown category "${a.category}" ` +
          `(expected one of ${CATEGORIES.join(', ')})`,
      );
    }
    if (Number.isNaN(Date.parse(a.published_at))) {
      problems.push(`${where}: published_at must be a date (YYYY-MM-DD)`);
    }
    for (const field of ['title', 'content']) {
      for (const lang of LANGUAGES) {
        const text = a[field] && a[field][lang];
        if (typeof text !== 'string' || !text.trim()) {
          problems.push(`${where}: missing ${field}.${lang}`);
        }
      }
    }
    if (typeof a.vet_reviewed !== 'boolean') {
      problems.push(`${where}: vet_reviewed must be true or false`);
    }
    if (a.vet_reviewed && !a.reviewed_by) {
      problems.push(`${where}: vet_reviewed articles need reviewed_by`);
    }
  });
  return problems;
}

function reviewSheet(articles) {
  const lines = ['# PawHealth starter articles: vet review', ''];
  lines.push(
    'Please check each article for medical accuracy in every language. ' +
      'Mark corrections inline; approved articles get "vet_reviewed": true ' +
      'and "reviewed_by" in articles.json.',
    '',
  );
  for (const a of articles) {
    lines.push(`## ${a.title.en}`, '');
    lines.push(
      `id: \`${a.id}\` · category: ${a.category} · ` +
        `reviewed: ${a.vet_reviewed ? `yes (${a.reviewed_by})` : 'no'}`,
      '',
    );
    for (const lang of LANGUAGES) {
      lines.push(`### ${lang.toUpperCase()}: ${a.title[lang]}`, '');
      lines.push(a.content[lang], '');
    }
  }
  return lines.join('\n');
}

function toFirestore(article, Timestamp) {
  return {
    title: article.title,
    content: article.content,
    category: article.category,
    image_url: article.image_url || null,
    published_at: Timestamp.fromDate(new Date(article.published_at)),
    vet_reviewed: article.vet_reviewed,
    reviewed_by: article.reviewed_by || null,
  };
}

async function main() {
  const args = parseArgs(process.argv.slice(2));
  const file = path.resolve(args.file || path.join(__dirname, 'articles.json'));
  const { articles } = JSON.parse(fs.readFileSync(file, 'utf8'));

  const problems = validate(articles);
  if (problems.length) {
    console.error(`${file} has problems:\n  ${problems.join('\n  ')}`);
    process.exit(1);
  }

  if (args.review) {
    process.stdout.write(reviewSheet(articles) + '\n');
    return;
  }

  const emulator = process.env.FIRESTORE_EMULATOR_HOST;
  if (args.includeUnreviewed && !emulator) {
    console.error(
      '--include-unreviewed only works against the Firestore emulator ' +
        '(set FIRESTORE_EMULATOR_HOST). Unreviewed articles must not reach ' +
        'real users.',
    );
    process.exit(1);
  }

  const toWrite = articles.filter(
    (a) => a.vet_reviewed || args.includeUnreviewed,
  );
  const held = articles.filter((a) => !toWrite.includes(a));

  console.log(`${articles.length} articles valid in ${path.basename(file)}.`);
  for (const a of toWrite) console.log(`  write  ${a.id}`);
  for (const a of held) console.log(`  hold   ${a.id} (awaiting vet review)`);

  if (!args.apply) {
    console.log('\nDry run: nothing written. Add --apply --project <id>.');
    return;
  }
  if (!args.project) {
    console.error('--apply needs --project <firebase-project-id>.');
    process.exit(1);
  }
  if (!toWrite.length) {
    console.log('\nNothing to write.');
    return;
  }

  // Loaded only when writing, so validating needs no npm install.
  const { initializeApp, applicationDefault } = require('firebase-admin/app');
  const {
    getFirestore,
    Timestamp,
  } = require('firebase-admin/firestore');

  initializeApp(
    emulator
      ? { projectId: args.project }
      : { projectId: args.project, credential: applicationDefault() },
  );
  const db = getFirestore();
  const batch = db.batch();
  for (const a of toWrite) {
    // set() replaces the document: articles.json is the source of truth.
    batch.set(db.collection('articles').doc(a.id), toFirestore(a, Timestamp));
  }
  await batch.commit();
  console.log(
    `\nWrote ${toWrite.length} article(s) to ` +
      `${emulator ? `emulator ${emulator}` : args.project}.`,
  );
}

if (require.main === module) {
  main().catch((error) => {
    console.error(error.message || error);
    process.exit(1);
  });
}

module.exports = { validate, reviewSheet, toFirestore, CATEGORIES, LANGUAGES };
