# Health article seed

`articles.json` holds the Articles tab's content: each article's title and
body in English, Thai and Simplified Chinese. `seed.js` validates it and
writes it to the Firestore `articles` collection.

## Vet review first

The starter articles are drafts, marked `"vet_reviewed": false`. **They
must not reach users until a vet has checked them in every language.** The
script enforces this: it skips unreviewed articles in production.

1. Print a review sheet and send it to the reviewing vet:
   ```sh
   node seed.js --review > review.md
   ```
2. Apply their corrections in `articles.json` (all three languages).
3. For each approved article set `"vet_reviewed": true` and
   `"reviewed_by": "<vet name, clinic>"`.

Points to confirm with the vet in particular:
- the vaccine schedule ages and booster intervals
- the statement that rabies vaccination is legally required in Thailand
- the advice on resting the stomach after a single vomiting episode

## Seeding

```sh
cd tool/seed_articles
node seed.js                          # validate + dry run (no install needed)
npm install                           # once, for writing
gcloud auth application-default login # once, credentials for the project
node seed.js --apply --project pawhealth-app-2026
```

Writes replace each article document, so `articles.json` stays the source of
truth. Edits made in the Firebase console are overwritten on the next seed.

To preview unreviewed drafts in the Firestore emulator:

```sh
FIRESTORE_EMULATOR_HOST=localhost:8080 \
  node seed.js --apply --project pawhealth-app-2026 --include-unreviewed
```

## Format

| Field | Notes |
| --- | --- |
| `id` | kebab-case; becomes the document id |
| `category` | `first_aid`, `safety`, `preventive_care`, `nutrition` or `symptoms`. Labels are translated in the app (`L10nHelpers.articleCategory`), so a new category needs ARB strings too. |
| `title`, `content` | `{ "en", "th", "zh" }`. In `content`, a blank line starts a new paragraph. Lines starting with `• ` render as bullets. |
| `published_at` | `YYYY-MM-DD`; the list shows newest first |
| `image_url` | optional, or `null` |
| `vet_reviewed`, `reviewed_by` | see above |
