# Web Redesign & Firestore Premium Gating — Design Notes

Status: **proposed, not yet implemented.** No `.dart` files have been changed as
of this writing — this document captures the design discussion and code
outline so it isn't lost, ahead of actually building it.

## 1. Why

Running PawHealth on Flutter Web exposed two problems:

1. The mobile layout is used as-is on desktop browsers — full-bleed buttons,
   single-column timeline, no use of the extra width. Looks stretched/empty.
2. RevenueCat / App Store IAP doesn't work on the web, so `PawHealth Plus`
   currently can't be unlocked there at all.

## 2. Responsive web UI

A prototype was reviewed as a Claude Artifact (desktop Login + Pet Health
Dashboard, with a viewport toggle to preview the fold back to mobile). Not
checked into the repo — it's a throwaway HTML mockup, not app code.

### Breakpoints

```dart
enum ScreenSize { mobile, tablet, desktop }

ScreenSize screenSizeOf(BuildContext context) {
  final w = MediaQuery.sizeOf(context).width;
  if (w >= 900) return ScreenSize.desktop;
  if (w >= 700) return ScreenSize.tablet;
  return ScreenSize.mobile;
}
```

Proposed home: `lib/widgets/responsive/breakpoints.dart` (new file).

- `< 700px` — today's phone layout, untouched.
- `700–900px` — tablet: rail/nav collapses to icon-only, brand panel hidden.
- `> 900px` — desktop: full rail + split brand panel.

### `login_screen.dart`

Keep the existing `Form` content as-is; wrap it in a `ConstrainedBox(maxWidth:
360)` and, on desktop, place it beside a new `_BrandPanel` widget in a `Row`:

```dart
Widget build(BuildContext context) {
  final size = screenSizeOf(context);
  final formColumn = ConstrainedBox(
    constraints: const BoxConstraints(maxWidth: 360),
    child: /* existing Form(...) content, unchanged */,
  );

  return Scaffold(
    body: size == ScreenSize.desktop
        ? Row(children: [
            Expanded(flex: 5, child: _BrandPanel()),
            Expanded(flex: 4, child: Center(child: formColumn)),
          ])
        : Center(child: SingleChildScrollView(child: formColumn)),
  );
}
```

`register_screen.dart` gets the same `formColumn` treatment (brand panel
optional).

### `pet_health_dashboard.dart`

Bigger lift — currently phone-only end to end:

- New `_DesktopRail` widget (pet switcher + nav + Plus upsell card), shown
  only when `screenSizeOf(context) == ScreenSize.desktop`. Mobile keeps
  today's `AppBar`.
- Body wrapped in `ConstrainedBox(maxWidth: 1120)`, centered. On desktop, swap
  the current single `Column` for a `Row`:
  `Expanded(flex: 2, child: _UnifiedTimeline(...))` +
  `SizedBox(width: 300, child: _SideStack(...))` (weight chart, vaccinations,
  Plus card). Below 900px, keep today's stacked `Column` — same child
  widgets, just re-parented.
- No changes to `HealthTimelineProvider` or the record/vaccine dialogs —
  layout-only refactor.

Suggested implementation order: login screen first (small, self-contained),
then Firestore gating (section 3, smaller and more contained than the
dashboard), then the dashboard rail/grid refactor last.

## 3. Firestore-based Plus gating (replaces RevenueCat on web)

**Field:** `users/{uid}.isPremium: bool` (default `false`; write with
`SetOptions(merge: true)` so it doesn't clobber other fields on the doc).

### `subscription_provider.dart`

Branch on `kIsWeb` instead of `RevenueCatService.hasPlaceholderKeys`:

```dart
class SubscriptionProvider extends ChangeNotifier {
  bool isPlusMember = false;
  bool isLoading = false;
  String? errorCode;

  StreamSubscription<DocumentSnapshot>? _sub;
  final RevenueCatService _revenueCat = RevenueCatService();

  Future<void> init(String userId) async {
    if (kIsWeb) {
      isLoading = true;
      notifyListeners();
      _sub = FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .snapshots()
          .listen((doc) {
        isPlusMember = doc.data()?['isPremium'] == true;
        isLoading = false;
        notifyListeners();
      }, onError: (_) {
        errorCode = 'subscription-load-failed';
        isLoading = false;
        notifyListeners();
      });
      return;
    }
    // Existing RevenueCat path, unchanged, for Android/iOS.
    if (RevenueCatService.hasPlaceholderKeys) return;
    // ...
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }
}
```

Using a `snapshots()` stream (not a one-shot `get()`) means flipping the
Firestore field takes effect live, without a re-login — needed for the
admin-grant flow below.

### Firestore rule (lock `isPremium` to trusted writers only)

```
match /users/{userId} {
  allow read: if request.auth.uid == userId;
  allow update: if request.auth.uid == userId
    && !('isPremium' in request.resource.data.diff(resource.data).affectedKeys());
}
```

### Admin grant — how to flip it manually

**Preferred: Firebase Console** (zero new attack surface, nothing shipped in
the app bundle):

1. Firebase Console → Firestore Database → `users` collection → find the
   user's doc (cross-reference via Authentication tab: search by email →
   copy UID).
2. Open the doc, add field `isPremium` (boolean) → `true`. Save.
3. User sees Plus unlock live within a few seconds — no app restart, thanks
   to the stream in `subscription_provider.dart` above.

**If done often enough to be annoying:** a local one-off Admin SDK script
(never shipped in the app):

```js
// scripts/grant-plus.js — run locally: node scripts/grant-plus.js someone@example.com
const admin = require('firebase-admin');
admin.initializeApp({ credential: admin.credential.applicationDefault() });

const email = process.argv[2];
const user = await admin.auth().getUserByEmail(email);
await admin.firestore().doc(`users/${user.uid}`).set({ isPremium: true }, { merge: true });
console.log(`Granted Plus to ${email} (${user.uid})`);
```

**Explicitly not recommended:** an in-app hidden admin screen — it ships a
production attack surface for a task that's done rarely.

## 4. Open questions before implementation

- Confirm breakpoint values (900px / 700px) against real usage, if any
  analytics exist yet.
- Confirm `isPremium` as the field name (vs. reusing/renaming the existing
  `subscription_tier` field on `users/{uid}`).
- Decide whether the responsive layout work is web-only (`kIsWeb` branch) or
  universal (same breakpoint logic also improves tablet on Android/iOS).
