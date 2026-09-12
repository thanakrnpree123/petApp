# Critical Retention Batch

Branch: `fix/critical-retention-batch` — **merged into `develop`** (2026-09-11) · All 15 items done and verified

Status: ⬜ todo · 🟨 in progress · ✅ done · ⏸ blocked

RICE reach is estimated users affected per month per 1,000 MAU (no analytics yet) — use it for relative order, not forecasting.

| Order | Item | Why it's in the batch | RICE | Effort | Status | Notes |
|---|---|---|---|---|---|---|
| 1 | **Account deletion** | App Store 5.1.1(v) blocker; PDPA/GDPR | blocker | 1–2 d | ✅ | Verified. Production needs the `firestore.rules` deploy (pre-release #1) |
| 2 | **#3** Symptom checker fails offline for free users; double-tap opens two screens | Breaks the 2 AM promise | 720 | 0.5 d | ✅ | Limit lookup fails open (4 s timeout); double-tap guard |
| 3 | **#10** Deleting a pet keeps its vaccine reminders and photo | Override: grief moment → 1-star review | 120 | 0.5 d | ✅ | Reminders cancelled + photo folder deleted; stable reminder ids |
| 4 | **#7** No "Forgot password" | Override: locked-out user is lost for good | 360 | 0.5 d | ✅ | Reset dialog from login; email sent in app language; no account enumeration |
| 5 | **#2** Notification permission asked at first launch | One-shot iOS prompt kills reminders | 840 | 0.5 d | ✅ | No prompt at launch; explainer on first vaccine add, OS prompt only on Turn On |
| 6 | **#5** Vaccine reminders fire at midnight | Due date 00:00 minus 1 day | 400 | 0.25 d | ✅ | 9:00 AM the day before; due-morning fallback when added late |
| 7 | **#4** Timeline flashes empty state on filter tap | Streams recreated in `build` | 540 | 0.5 d | ✅ | Streams subscribed once in state; loading spinner instead of empty-state flash |
| 8 | **#6** Paywall dead end on web | Subscribe disabled, no explanation | 400 | 0.5 d | ✅ | Paywall explains each state (web / unavailable / load failed + retry / loading); no hardcoded price |
| 9 | **#1** Articles "All" chip hardcoded English | 5-minute fix | 1500 | 0.05 d | ✅ | Uses l10n.filterAll |

**Found along the way:** Articles tab re-queried Firestore and flashed its loader on every category tap (same stream-in-`build` bug as #4) — fixed in its own commit.

## Backlog batch

| Order | Item | RICE | Effort | Status | Notes |
|---|---|---|---|---|---|
| 10 | **#8** Failed-login error shows on the Register screen | 250 | 0.1 d | ✅ | AuthProvider.clearError() on the way to and back from Register |
| 11 | **#9** Weight entry has no sanity bound; chart spaces points by index; US date labels | 160 | 0.5 d | ✅ | 0.1–150 kg bound, decimal comma accepted; chart x = real dates; locale date labels |
| 12 | **#11** Vaccine next-due date can precede the date given | 96 | 0.25 d | ✅ | Pickers bounded (given ≤ today, due > given); pair re-checked on change and save |
| 13 | **#12** Photo picker: gallery only, no feedback on denied permission | 70 | 0.5 d | ✅ | Camera or library sheet; denied-access message; iOS NSCameraUsageDescription added; a11y label |
| 14 | **#13** Shared device: previous user's pets flash after logout; listeners keep running | 40 | 0.25 d | ✅ | Logout ends the session (listeners, Plus state, reminders); sign-in re-syncs reminders from Firestore |
| 15 | **#14** Pet form discards unsaved edits on Back without asking | 36 | 0.25 d | ✅ | PopScope + "Discard changes?" only when values differ from when the form opened |

## QA polish batch (`fix/qa-polish-and-articles`)

| # | Item | Status | Resolution |
|---|---|---|---|
| 16 | **#13** Limping symptom showed a generic icon | ✅ | Healing icon |
| 17 | **#11** Breed list opened over its own label on short screens | ✅ | Scrolls the field up to make room, then opens the list below it |
| 18 | **#10** Pet card cut off the age on desktop ("1 ปี 0 เ…") | ✅ | Breed and age on separate lines; grid row height scales with text size |
| 19 | **#9** Desktop page titles didn't line up with centered content | ✅ | Shared `ContentWidth`/`CenteredContent`; articles and pet form capped at 640px |
| 20 | **#15** Logo unreadable in the nav rail and app bar | ✅ interim | `BrandMark` paw badge + wordmark; swap in a small-size logo asset later |
| 21 | **#14** Vomiting check offered "No symptoms", which led to "seems healthy" | ✅ | Option and result removed; older saved checks stay translated. Include in the vet review |
| 22 | **#12** Thai dates showed the Gregorian year | ✅ | Buddhist Era year (พ.ศ.) in Thai; date picker and PDF stay Gregorian |
| 23 | **#4** Articles tab empty | ✅ content ready | Articles localized (EN/TH/ZH); 6 starter articles + `tool/seed_articles`. Seed after the vet review |

## Pre-release checklist

### Must do before submitting to the stores
- [x] **Deploy security rules** — deployed to `pawhealth-app-2026` on 2026-09-11 (Firestore rules incl. the account-deletion `delete` rule; Storage rules).
- [ ] **Veterinary review** of the symptom checker (9 flows) and the 6 starter articles, in one packet: `flutter test tool/vet_review/generate_test.dart` writes `tool/vet_review/out/pawhealth-vet-review-<date>.html` (print to PDF). After approval: apply corrections, set `vet_reviewed`/`reviewed_by` in `tool/seed_articles/articles.json`, and seed with `node tool/seed_articles/seed.js --apply --project pawhealth-app-2026`. Until then, the Articles tab shows "No articles available".
- [ ] **RevenueCat** — follow `docs/revenuecat-setup.md`: stores, dashboard, public SDK keys in `.env`, and publish the Terms/Privacy pages at the URLs in `lib/config/legal_links.dart`. The app side (crash-proof service, debug mock, admin override, paywall renewal terms and legal links) is done.
- [ ] **Re-enable App Check** (`TODO(app-check)` in `main.dart`): register debug tokens, configure providers, start with enforcement off, then turn it on.
- [ ] **Final app icon and splash** — replace the placeholders, add a small-size logo to `BrandMark`, then `dart run flutter_launcher_icons` and `dart run flutter_native_splash:create`.
- [x] **Legal pages** — content filled in and confirmed by the owner (2026-09-12). ⚠️ The copies in `web/legal/` are still the drafts (highlighted placeholders, Draft banners): commit the final versions there before the next deploy to `main`, which publishes them.
- [ ] **Store privacy disclosures** — App Store privacy labels and Play Data safety form. The data inventory in `web/legal/privacy.html` covers them: email, user ID, pet data and photos, purchases; no tracking, ads or analytics.
- [ ] **Google Play account-deletion web link** — the page is drafted at `legal/delete-account.html` (see Legal pages); enter its URL in Play Console → Data safety once published.
- [ ] **Medical-app review notes** — App Store guideline 1.4.1: keep the disclaimer visible and be ready to explain where the triage content comes from.
- [ ] **Device QA pass** on iOS and Android 13+: reminder explainer, 9 AM delivery, camera picker, logout/login reminder rebuild, account deletion.

### Should do soon after launch
- [ ] Enforce the free symptom-check limit on the server (Cloud Function). The client check can be bypassed and deliberately fails open when offline.
- [ ] Sync Plus across platforms — a RevenueCat webhook that sets `users/{uid}.isPremium`. Today a mobile subscriber doesn't get Plus on web.
- [ ] Add the Firebase "Delete User Data" extension as a server-side backstop for account deletion, and delete the RevenueCat subscriber record.
- [ ] Localize the remaining English-only text: notification messages, PDF report, and some health-dashboard dialogs.
- [x] Bundle fonts as assets so the first launch works offline — Nunito and IBM Plex Sans Thai Looped ship in `assets/google_fonts/` with runtime fetching off; Chinese uses the system font; the paw loader animation is bundled too (no more lottie.host).
