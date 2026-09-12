# RevenueCat, App Store and Google Play setup

The app side is ready: `RevenueCatService` reads its keys from `.env`, never
crashes when the stores aren't set up, and shows a mock offering in debug
builds. This checklist is the manual setup still needed on Apple, Google and
RevenueCat, in order.

Names used below. They must match exactly across all three, and the code
already uses them:

| What | Value |
| --- | --- |
| iOS bundle ID / Android package | `com.pawhealth.pawhealth` |
| Subscription product ID (both stores) | `pawhealth_plus_monthly` |
| RevenueCat entitlement | `plus` (`RevenueCatService.entitlementId`) |
| RevenueCat offering / package | `default` (Current) / `$rc_monthly` |
| RevenueCat app user ID | the Firebase Auth UID (set by the app) |

## 1. Apple (App Store Connect)

- [ ] Join the **Apple Developer Program**.
- [ ] **Agreements, Tax, and Banking:** accept the **Paid Apps** agreement and
      complete tax and bank details. Until this is active, the App Store
      returns no products and offerings stay empty.
- [ ] **Certificates, IDs & Profiles:** make sure the App ID
      `com.pawhealth.pawhealth` exists with the In-App Purchase capability.
- [ ] **Xcode → Runner target → Signing & Capabilities:** add
      **In-App Purchase** (the project has no entitlements file yet).
- [ ] **App Store Connect → My Apps:** create the app record for the bundle
      ID.
- [ ] **Subscriptions:** create a subscription group ("PawHealth Plus") and
      an auto-renewable subscription:
  - [ ] product ID `pawhealth_plus_monthly`, duration 1 month
  - [ ] prices (at least THB and USD)
  - [ ] display name and description in English, Thai and Chinese
  - [ ] a review screenshot of the paywall
- [ ] **Users and Access → Integrations → In-App Purchase:** generate an
      **In-App Purchase key** (.p8). Note its Key ID and the Issuer ID.
      RevenueCat needs these; the .p8 downloads only once.
- [ ] **App Information → App Store Server Notifications:** paste the V2 URL
      that RevenueCat shows (step 3) for Production and Sandbox.
- [ ] **Users and Access → Sandbox:** create a sandbox tester account.
- [ ] Submit the first subscription **together with an app version** for
      review. Apple won't review a first subscription on its own.

## 2. Google (Play Console)

- [ ] Create a **Play Console developer account** and the app
      (`com.pawhealth.pawhealth`).
- [ ] Set up a **payments profile** (merchant account).
- [ ] Upload a signed release **AAB to the Internal testing track**. Play
      only allows creating subscriptions after a build with the billing
      permission is uploaded (`purchases_flutter` adds it).
- [ ] **Monetize → Products → Subscriptions:** create
      `pawhealth_plus_monthly`:
  - [ ] a monthly auto-renewing base plan
  - [ ] prices
  - [ ] **Activate** it
- [ ] **Google Cloud → IAM → Service accounts:** create a service account for
      RevenueCat and download its JSON key.
- [ ] **Play Console → Users and permissions:** invite that service account
      with *View financial data* and *Manage orders and subscriptions*. Google
      can take up to about 36 hours to accept the credentials.
- [ ] **Monetize → Monetization setup → Real-time developer notifications:**
      paste the Pub/Sub topic that RevenueCat shows (step 3).
- [ ] **Setup → License testing:** add tester Gmail accounts. Testers must
      join the internal test and install from Play.

## 3. RevenueCat dashboard

- [ ] Create the project **PawHealth**.
- [ ] Add an **App Store app**: bundle ID, plus the In-App Purchase key
      (.p8, Key ID, Issuer ID). Copy the Server Notifications URL back to
      step 1.
- [ ] Add a **Play Store app**: package name, plus the service account JSON.
      Copy the Pub/Sub topic back to step 2.
- [ ] **Products:** add `pawhealth_plus_monthly` for both stores.
- [ ] **Entitlements:** create `plus` and attach both products.
- [ ] **Offerings:** create `default`, mark it **Current**, and add a
      `$rc_monthly` (Monthly) package holding both products.
- [ ] **API keys:** copy the two **public** app-specific SDK keys (`appl_…`,
      `goog_…`). Never use the secret key (`sk_…`) in the app; the service
      refuses it.
- [ ] Optional, for cross-platform Plus: add the Firebase integration or a
      webhook that sets `users/{uid}.isPremium`. The web app reads that field,
      so a mobile subscriber also gets Plus on the web.

## 4. Wire it into the app

- [ ] Put the keys in your local `.env` (copied from `.env.example`):
      ```
      REVENUECAT_APPLE_API_KEY=appl_...
      REVENUECAT_GOOGLE_API_KEY=goog_...
      REVENUECAT_MOCK=false
      ```
- [ ] Run with `flutter run --dart-define-from-file=.env`. Without the flag
      the keys are empty and purchases stay off; the app still runs.
- [ ] Before a release build, check the paywall shows:
  - [ ] the store price and period
  - [ ] a **Restore Purchases** button (already there)
  - [x] the auto-renewal terms for each store, and links to the **Terms of
        Use** and **Privacy Policy** (also in Settings)
- [ ] **Finish and publish the legal pages.** Drafts are in `web/legal/`
      (`terms.html`, `privacy.html`, `delete-account.html`). Fill in the
      highlighted placeholders, have a lawyer review them, remove the
      "Draft" banners, then deploy (merge to `main`). The app already links
      to these URLs.
- [ ] Enter the same two URLs in the store listings: App Store Connect (the
      Privacy Policy URL, plus the EULA in the app description or the
      custom EULA field) and Play Console (App content → Privacy policy, and
      Data safety → the account deletion URL, `legal/delete-account.html`).
- [ ] **iOS test:** use a real device signed in with the sandbox tester.
      Simulators need a StoreKit configuration file instead.
- [ ] **Android test:** use a device with a license-tester account, with the
      app installed from the internal track.
- [ ] **CI for store builds:** write `.env` from CI secrets before building,
      for example in GitHub Actions:
      ```yaml
      - run: |
          echo "REVENUECAT_APPLE_API_KEY=${{ secrets.REVENUECAT_APPLE_API_KEY }}" >> .env
          echo "REVENUECAT_GOOGLE_API_KEY=${{ secrets.REVENUECAT_GOOGLE_API_KEY }}" >> .env
      - run: flutter build appbundle --dart-define-from-file=.env
      ```
      The web deploy needs no keys: the web app gets Plus from Firestore.

## How the app behaves meanwhile

| Situation | Result |
| --- | --- |
| No keys in `.env` | Paywall: "Subscriptions aren't available right now." No crash. |
| Debug build, `REVENUECAT_MOCK=true` | Paywall offers "$2.99 (mock)". Subscribing grants Plus for the session only. |
| Keys set, but stores or dashboard not ready | Mock in debug; the "not available" message in release. |
| Offline or timeout | "Couldn't load", with a Try again button. |
| User cancels a purchase | Nothing happens; no error is shown. |
| Signed in as `thanakarn.123@gmail.com` | Plus immediately. RevenueCat and the Firestore check are skipped. |
