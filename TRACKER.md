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
| 7 | **#4** Timeline flashes empty state on filter tap | Streams recreated in `build` | 540 | 0.5 d | ⬜ | Also saves Firestore reads |
| 8 | **#6** Paywall dead end on web | Subscribe disabled, no explanation | 400 | 0.5 d | ⬜ | Mobile too until RevenueCat keys |
| 9 | **#1** Articles "All" chip hardcoded English | 5-minute fix | 1500 | 0.05 d | ⬜ | |

## Backlog (not in this batch)

#8 stale auth error on Register (250) · #9 weight sanity + chart dates (160) · #11 vaccine date validation (96) · #12 photo picker camera/permissions (70) · #13 shared-device logout leak (40) · #14 unsaved form warning (36)

## Release checklist carried over

- [ ] Deploy `firestore.rules` / `storage.rules`
- [ ] Vet review of all symptom-checker content (EN + TH/ZH)
- [ ] Real RevenueCat keys
- [ ] Re-enable App Check
- [ ] Final app icon / splash
