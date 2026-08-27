# PawHealth

**Pet Care & Symptom Checker** — a Flutter app for dog and cat owners that goes beyond passive tracking: it triages symptoms, generates vet-ready PDF reports, and surfaces breed-specific health content.

Competing trackers log data and stop there. PawHealth tells you what to do at 2 AM.

## Key Features Built

| Feature | Notes |
|---|---|
| **Authentication** | Firebase Auth (email/password), Provider-based state |
| **Pet Profiles** | Multi-pet support, 150+ dog / 50+ cat breeds with breed-linked health risks, photo upload |
| **Symptom Checker** | Pure-Dart decision-tree engine (`lib/services/symptom_checker.dart`) — zero Flutter/Firebase imports, fully unit-tested independent of the UI |
| **Health Log & Vaccines** | Weight history (`fl_chart`), vaccination schedule, local push reminders 1 day before a vaccine is due |
| **PDF Vet Reports** | Generated natively with `pdf`/`printing` — pet profile, a hand-drawn weight-trend chart (raw canvas primitives, not a rasterized widget), vaccination table, latest symptom check, lined "Vet Notes" section |
| **Health Articles** | Category-filterable content library (First Aid / Nutrition / Breed Disorders) |
| **Freemium Paywall** | RevenueCat (`purchases_flutter`) — Free tier capped at 5 symptom checks/month; Plus ($2.99/mo) unlocks unlimited checks + PDF export |
| **Settings** | Account info, subscription status, log out |

## Tech Stack

- **Client:** Flutter, Provider for state management
- **Backend:** Firebase (Auth, Firestore, Storage)
- **Monetization:** RevenueCat
- **Notifications:** `flutter_local_notifications`
- **PDF:** `pdf` + `printing`
- **Charts:** `fl_chart` (in-app), native `pw.CustomPaint` (in PDF reports)

## Project Structure

```
lib/
├── models/            # Firestore-facing data classes
├── data/              # Static data (breed lists, decision trees) + pure-Dart engine types
├── services/          # Firestore/Storage/RevenueCat/notification I/O — no widgets
├── providers/          # ChangeNotifier state (auth, pets, subscription)
├── screens/            # One folder per feature area
└── widgets/            # Shared, feature-scoped widgets
```

## Setup

### 1. Install dependencies
```bash
flutter pub get
```

### 2. Firebase
This project already has `firebase_options.dart` generated via FlutterFire CLI. If setting up a new Firebase project:
```bash
flutterfire configure --project=<your-project-id> --platforms=android,ios
```

**⚠️ Deploy Firestore & Storage security rules before shipping.** No `firestore.rules` / `storage.rules` have been written or deployed yet — reads/writes will fail under default-deny production mode until rules scoping access to `request.auth.uid` are pushed via the Firebase Console or `firebase deploy --only firestore:rules,storage:rules`.

### 3. RevenueCat
`lib/services/revenuecat_service.dart` has placeholder API keys:
```dart
static const String _androidApiKey = 'YOUR_REVENUECAT_ANDROID_API_KEY';
static const String _iosApiKey = 'YOUR_REVENUECAT_IOS_API_KEY';
```
Before the paywall does anything real:
1. Create the $2.99/mo product in Google Play Console and App Store Connect.
2. Create a matching offering + entitlement (identifier: `plus`) in the RevenueCat dashboard.
3. Drop the real API keys into the file above.

### 4. Run
```bash
flutter run
```

### 5. Build for release
```bash
flutter build appbundle --release   # Android
flutter build ipa --release         # iOS
```
App icon and splash screen are already wired via `flutter_launcher_icons` / `flutter_native_splash` (see Design Assets below to regenerate with final branding, then re-run):
```bash
dart run flutter_launcher_icons
dart run flutter_native_splash:create
```

## Known Placeholders / Follow-ups

- **App icon & splash logo** are programmatically-generated placeholders (`assets/images/app_icon.png`, `splash_logo.png`) — see prompts below to replace with real branding.
- **Article `content` field is plain text**, not Markdown — no markdown-rendering package is included yet.
- **Article model doesn't yet carry `species`/`related_disorders`** — breed-specific article surfacing isn't wired up.
- **Localization covers EN/TH/ZH** via `.arb` files (`lib/l10n/`): UI shell, auth, pet form, paywall, overlay/progress messages, provider errors (as codes localized in the UI via `L10nHelpers`), and the symptom-checker Q&A + triage advice (canonical English stays in the tree data and Firestore; presentation is localized). Still English-only: health dashboard section labels/dialogs, vaccine notification text, and the PDF report (service layer has no BuildContext — an explicit locale would need to be passed in). **The TH/ZH medical advice strings are AI-translated and must be reviewed by a veterinary professional before release.** Fonts switch per locale: Fredoka (en), Mali (th), Noto Sans SC (zh).
- **Firestore/Storage security rules** not yet written — see Setup step 2.
- **Firebase App Check is disabled** — activation is commented out in `main.dart` (see the `TODO(app-check)` block) after attestation failures during development. Re-enable and verify (debug token registered, providers configured in Firebase Console, enforcement initially off) before production.
- **Quicksand font loads at runtime** via `google_fonts` (fetched once, then cached on-device). For a fully offline-first production build, bundle the Quicksand `.ttf` files as assets per the google_fonts docs and disable runtime fetching.

## Design Assets — AI Image Generation Prompts

Placeholder icon/splash art was generated locally (a flat teal paw print). Use these prompts with Midjourney or DALL-E 3 to generate final branding — they recreate the draft concept compositions (six-pet cluster + heart-sprout emblem) in an upgraded modern, minimalist, premium tech-startup style.

> **Brand note:** the draft concepts show six species (dog, cat, rabbit, parrot, hamster, gecko), but PawHealth's positioning is *dogs & cats only* — that's our differentiation from multi-species trackers. Each prompt includes an optional bracketed variant to cut the cast down to dog + cat for brand consistency.

### App Icon Prompt
```
Premium mobile app icon, modern minimalist flat vector style. A tight,
harmonious cluster of six pets forming a rounded group composition: a
smiling golden retriever head on the left with gently closed eyes, a
Siamese cat face at the top, a white rabbit with tall upright ears on the
right, a green parrot with a small orange beak in the center foreground, a
tiny hamster peeking from the middle, and a slim teal gecko curling in at
the lower right. Behind the animals, two or three soft overlapping
geometric circles in muted teal, dusty purple, and warm amber. A small
minimal emblem below the group: two abstract leaves sprouting around a
simple heart outline.

Style: sleek premium tech-startup branding, flat vector, simplified
geometric shapes, thin uniform monoline strokes or fully outline-free
shapes, restrained sophisticated palette (deep teal #00796B as anchor
color, soft sky-blue field, muted accent tones), generous negative space,
perfectly balanced composition, crisp edges, Dribbble/Behance top-shot
quality, comparable to modern fintech and health app identities.

Strictly avoid: childish cartoon look, thick dark outlines, drop shadows,
3D, gloss, gradients heavier than subtle duotone, texture, text. Solid
opaque background, square 1:1, generous safe-area padding.

[Optional brand-consistent variant: include only the golden retriever and
the Siamese cat, side by side — omit all other animals.]
```

### Splash Logo Prompt
```
Minimalist splash-screen logo lockup for a premium pet health app, modern
flat vector, tech-startup aesthetic. Centered vertical lockup: (1) the
same six-pet cluster — smiling golden retriever on the left, Siamese cat
face above, white rabbit with upright ears on the right, green parrot
front-center, small hamster peeking through, slim teal gecko at lower
right — drawn as simplified geometric flat shapes over two soft muted
circles (teal, dusty purple); (2) beneath it, a small emblem of two
abstract leaves cradling a heart outline; (3) the wordmark "PawHealth" in
a clean rounded geometric sans-serif, deep teal #00796B; (4) the tagline
"Your Pet's Complete Care" in a light gray, letter-spaced, smaller size.

Style: sleek, professional, premium UI branding, thin monoline or
outline-free flat shapes, restrained palette, lots of negative space,
pixel-crisp vector edges. Background: fully transparent (or plain white),
with NO decorative pattern.

Strictly avoid: cartoonish heavy outlines, drop shadows, 3D, gloss,
clutter, background leaf/paw patterns, more than three accent colors.

[Optional brand-consistent variant: dog and cat only.]
[Alternative style: single-weight continuous line art — the whole animal
cluster drawn as one elegant unbroken teal line, wordmark unchanged.]
```

### Practical notes
- **Text rendering:** Midjourney still mangles words — for the splash, generate the animal mark alone, then set "PawHealth" + tagline yourself in Figma/Canva (fonts in that style: Quicksand, Baloo 2, or Nunito). DALL-E 3 handles short wordmarks better, but verify spelling.
- **Icon needs an opaque background; splash mark needs transparency** — matches the `flutter_launcher_icons` (`remove_alpha_ios: true`) and `flutter_native_splash` (`color: "#FFFFFF"`) configs in `pubspec.yaml`.
- After exporting: overwrite `assets/images/app_icon.png` (1024×1024) and `assets/images/splash_logo.png` (512×512, transparent), then re-run:
  ```bash
  dart run flutter_launcher_icons
  dart run flutter_native_splash:create
  ```
