# Firebase App Check setup

App Check proves requests to Firestore, Storage and Auth come from the real
PawHealth app. The code is done (`lib/services/app_check_setup.dart`,
activated in `main.dart`):

| Build | Android | iOS | Web |
| --- | --- | --- | --- |
| Debug | Debug provider | Debug provider | Debug provider |
| Release | Play Integrity | App Attest, DeviceCheck fallback | reCAPTCHA Enterprise, if a site key is set |

App Check never blocks startup, and **enforcement stays off** until the
metrics below look right. Until then, a device that fails attestation still
works.

## 1. Register the apps (Firebase console → App Check → Apps)

- [ ] **Android: Play Integrity**
  - [ ] Play Console → App integrity: link the app to the Firebase project's
        Google Cloud project, which enables the Play Integrity API.
  - [ ] Firebase → Project settings → Android app: add the **SHA-256** of the
        *app signing* key (Play Console → App integrity → App signing), plus
        the upload key's.
  - [ ] App Check → Android app → Play Integrity → Save.
- [ ] **iOS: App Attest with a DeviceCheck fallback**
  - [ ] Xcode → Runner → Signing & Capabilities → add **App Attest**. This
        creates the entitlements file; set its environment to `production`
        for release.
  - [ ] Apple Developer → Keys: create a **DeviceCheck** key (.p8). In App
        Check → iOS app, register App Attest and DeviceCheck with the key,
        its Key ID and your Team ID.
- [ ] **Web: reCAPTCHA Enterprise (optional for now)**
  - [ ] Google Cloud → Security → reCAPTCHA Enterprise: create a *website*
        key for `thanakrnpree123.github.io` and `localhost`.
  - [ ] App Check → Web app → reCAPTCHA Enterprise: add the key.
  - [ ] Put it in `.env` as `APP_CHECK_WEB_SITE_KEY`. For the deployed site,
        pass it in `.github/workflows/deploy-web.yml`:
        `flutter build web ... --dart-define=APP_CHECK_WEB_SITE_KEY=<key>`
        (the key is public). Until then the live web app skips App Check.

## 2. Debug tokens (for development)

Debug builds use the debug provider. Either:

- **Register the token the app prints:** run a debug build and copy the
  token from the log. Android logcat shows "Enter this debug secret into the
  allow list"; the Xcode console shows "Firebase App Check debug token"; on
  the web it's in the browser console. Then add it under App Check → Apps →
  ⋮ → **Manage debug tokens**. Tokens change on reinstall.
- **Or use one fixed token:** generate it in *Manage debug tokens* and set
  `APP_CHECK_DEBUG_TOKEN` in your local `.env`.

A debug token lets anyone who has it pass App Check, so keep it out of git
(`.env` is ignored) and never in CI secrets for release builds. Release
builds ignore it anyway.

## 3. Enforce, when the metrics say so

App Check → APIs shows verified and unverified requests for **Cloud
Firestore**, **Cloud Storage** and **Authentication**.

- [ ] Ship a release with App Check to the stores.
- [ ] Wait until almost all traffic is verified. Unverified requests come
      from older app versions without App Check, from the web without a site
      key, or from misconfiguration.
- [ ] Enforce Firestore and Storage first, then Authentication.

Once enforced, older app versions without App Check stop working, so only
enforce after most users have updated. If something breaks, turning
enforcement off takes effect within minutes.
