# Critical Retention Batch

Branch: `fix/critical-retention-batch` · Estimate: ~4–5 dev-days

Status: ⬜ todo · 🟨 in progress · ✅ done · ⏸ blocked

RICE reach is estimated users affected per month per 1,000 MAU (no analytics yet) — use it for relative order, not forecasting.

| Order | Item | Why it's in the batch | RICE | Effort | Status | Notes |
|---|---|---|---|---|---|---|
| 1 | **Account deletion** | App Store 5.1.1(v) blocker; PDPA/GDPR | blocker | 1–2 d | 🟨 | Code + tests done. Remaining: deploy `firestore.rules`, test on a real account |
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
| 10 | **#8** Failed-login error shows on the Register screen | 250 | 0.1 d | ⬜ | |
| 11 | **#9** Weight entry has no sanity bound; chart spaces points by index; US date labels | 160 | 0.5 d | ⬜ | |
| 12 | **#11** Vaccine next-due date can precede the date given | 96 | 0.25 d | ⬜ | |
| 13 | **#12** Photo picker: gallery only, no feedback on denied permission | 70 | 0.5 d | ⬜ | |
| 14 | **#13** Shared device: previous user's pets flash after logout; listeners keep running | 40 | 0.25 d | ⬜ | |
| 15 | **#14** Pet form discards unsaved edits on Back without asking | 36 | 0.25 d | ⬜ | |

## Release checklist carried over

- [ ] Deploy `firestore.rules` / `storage.rules`
- [ ] Vet review of all symptom-checker content (EN + TH/ZH)
- [ ] Real RevenueCat keys
- [ ] Re-enable App Check
- [ ] Final app icon / splash
