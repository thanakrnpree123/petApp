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

## Pre-release checklist

### Must do before submitting to the stores
- [ ] **Deploy security rules** — `firebase deploy --only firestore:rules,storage:rules`. Account deletion fails at the profile step without the new `delete` rule.
- [ ] **Veterinary review** of all symptom-checker content: 9 trees in `lib/data/decision_trees/`, English canonical text plus the AI-translated TH/ZH strings.
- [ ] **RevenueCat** — real API keys in `revenuecat_service.dart`; the $2.99/mo product in App Store Connect and Play Console; an offering with the `plus` entitlement.
- [ ] **Re-enable App Check** (`TODO(app-check)` in `main.dart`): register debug tokens, configure providers, start with enforcement off, then turn it on.
- [ ] **Final app icon and splash** — replace the placeholders, then `dart run flutter_launcher_icons` and `dart run flutter_native_splash:create`.
- [ ] **Store privacy disclosures** — privacy policy URL; App Store privacy labels and Play Data safety form (email, pet health data, photos).
- [ ] **Google Play account-deletion web link** — Play requires a web page or form for deletion requests in addition to the in-app option.
- [ ] **Medical-app review notes** — App Store guideline 1.4.1: keep the disclaimer visible and be ready to explain where the triage content comes from.
- [ ] **Device QA pass** on iOS and Android 13+: reminder explainer, 9 AM delivery, camera picker, logout/login reminder rebuild, account deletion.

### Should do soon after launch
- [ ] Enforce the free symptom-check limit on the server (Cloud Function). The client check can be bypassed and deliberately fails open when offline.
- [ ] Sync Plus across platforms — a RevenueCat webhook that sets `users/{uid}.isPremium`. Today a mobile subscriber doesn't get Plus on web.
- [ ] Add the Firebase "Delete User Data" extension as a server-side backstop for account deletion, and delete the RevenueCat subscriber record.
- [ ] Localize the remaining English-only text: notification messages, PDF report, and some health-dashboard dialogs.
- [ ] Bundle fonts as assets so the first launch works offline (`google_fonts` currently downloads them at runtime).
