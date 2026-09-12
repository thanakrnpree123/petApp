# Store forms: answer sheet

Answers for the App Store Connect and Google Play Console forms, based on
what the app actually does. Keep these in step with the published
[Privacy Policy](https://thanakrnpree123.github.io/petApp/legal/privacy.html)
and `ios/Runner/PrivacyInfo.xcprivacy`. If the app starts collecting
something new (analytics, crash reports), update all three.

The store forms change from time to time. Where a question below doesn't
match the form you see, answer from the facts in section 1.

**⚠ Confirm against the vendors' guides:** answers marked ⚠ depend on
what Firebase and RevenueCat collect themselves. Check Firebase's "Google
Play data disclosure" page and RevenueCat's App Privacy / Data safety guides
before submitting.

## 1. Facts

| | |
| --- | --- |
| Collected | Account email; Firebase user ID (also the RevenueCat app user ID); pet photos; pet profiles, health records, vaccinations and symptom checks; subscription status and purchase history |
| On the device only | Language, prompt flags, scheduled reminders |
| Not collected | Location, contacts, browsing, search history, the user's own health data, ads or analytics identifiers, crash logs |
| Tracking or ads | None. No ad SDKs, no analytics, no ATT prompt |
| Processors | Google Firebase (Auth, Firestore, Storage, App Check), RevenueCat, Apple/Google billing |
| Encryption | HTTPS in transit; Firebase encrypts data at rest |
| Deletion | In the app (Settings → Delete account) and by email; see the deletion page |
| Audience | Adults: 20+, or younger with a parent's or guardian's consent (Terms of Use) |

| URL | |
| --- | --- |
| Privacy Policy | https://thanakrnpree123.github.io/petApp/legal/privacy.html |
| Terms of Use (EULA) | https://thanakrnpree123.github.io/petApp/legal/terms.html |
| Account deletion | https://thanakrnpree123.github.io/petApp/legal/delete-account.html |
| Support | https://thanakrnpree123.github.io/petApp/legal/support.html |

## 2. App Store Connect → App Privacy (privacy labels)

**Do you or your third-party partners collect data from this app?** Yes.

For every type below: **Linked to the user: Yes**. **Used for tracking:
No**. **Purpose: App Functionality** (only).

| Category | Data type | What it is |
| --- | --- | --- |
| Contact Info | Email Address | Sign-in |
| Identifiers | User ID | Firebase account ID and RevenueCat app user ID |
| User Content | Photos or Videos | Pet photos |
| User Content | Other User Content | Pet profiles, health records, vaccinations, symptom checks |
| Purchases | Purchase History | PawHealth Plus (RevenueCat) ⚠ |

- **Health & Fitness: not collected.** Everything health-related is about
  pets. Apple's Health category means the user's own health. If a reviewer
  asks, explain that the records describe animals.
- **Diagnostics: not collected** by the app itself ⚠ (check whether
  RevenueCat or Firebase declare any for their SDKs).
- **Tracking:** No, so no App Tracking Transparency prompt.

Other App Store Connect fields:
- **Privacy Policy URL**, **Support URL**: see section 1.
- **License Agreement**: custom EULA = the Terms of Use URL, or keep
  Apple's standard EULA. The Terms include Apple's required minimum terms.
- **Export compliance:** answered in the app (`ITSAppUsesNonExemptEncryption`
  = NO in Info.plist): only standard HTTPS, no custom encryption.

## 3. App Store Connect → Age rating

Answer the questionnaire truthfully. The expected answers:

| Question | Answer |
| --- | --- |
| Violence, horror, sexual content, nudity, profanity, drugs, alcohol, tobacco, gambling, contests | None |
| Medical or treatment information | **Yes, frequent**: the symptom checker and articles give pet-health guidance |
| Health or wellness topics (if asked) | Yes (pet health) |
| User-generated content visible to others | No: records are private to the account |
| Unrestricted web access | No: links only open our own pages in the browser |
| Messaging or chat | No |
| In-app purchases | Yes (PawHealth Plus) |

The medical answer is likely to push the rating above 4+. That's fine for an
adult audience. Don't under-answer to get a lower rating: Apple rejects
apps whose rating doesn't match their content.

## 4. Google Play → App content

| Section | Answer |
| --- | --- |
| Privacy policy | Privacy Policy URL |
| Ads | **No**, the app contains no ads |
| App access | **All or some functionality is restricted**: give the reviewer demo login (section 6) |
| Content rating (IARC) | Category: *All other app types*. No violence, sex, profanity, drugs or gambling; no content shared between users; no location sharing; **digital purchases: yes**. Expect Everyone / PEGI 3 |
| Target audience | **18 and over** only. Not designed for children, no child-directed content |
| News app | No |
| Government app | No |
| Financial features | None (the subscription goes through Google Play billing) |
| Health apps declaration | ⚠ PawHealth's health features are for **animals**. Read the current categories: if none apply to non-human health, declare no health features and explain in the notes; if the form has a symptom or medical-information category without a "human only" limit, select that |

## 5. Google Play → Data safety

- **Does your app collect or share any of the required user data types?**
  Yes.
- **Is all of the user data collected by your app encrypted in transit?**
  Yes.
- **Do you provide a way for users to request that their data is
  deleted?** Yes: in the app, plus the account deletion URL.
- **Shared with third parties:** **No** for everything. Firebase and
  RevenueCat process data on our behalf as service providers, which Play
  doesn't count as sharing.

| Data type (Play category) | Collected | Required or optional | Purposes |
| --- | --- | --- | --- |
| Personal info → Email address | Yes | Required | Account management, App functionality |
| Personal info → User IDs | Yes | Required | Account management, App functionality |
| Photos and videos → Photos | Yes | Optional | App functionality |
| App activity → Other user-generated content (pet records) | Yes | Required | App functionality |
| Financial info → Purchase history | Yes ⚠ | Optional (Plus subscribers only) | App functionality |
| Device or other IDs | ⚠ Check Firebase's guide: App Check and Firebase installation IDs may count | | Fraud prevention, security |

Not collected: location, contacts, messages, audio, files and docs, calendar,
web browsing, health and fitness (the user's own), app info and performance
(no crash logs).

**Processed ephemerally?** No: data is stored until the account is deleted.

## 6. App review access (both stores)

Both stores need to sign in to review the app:

- [ ] Create a **reviewer account** (not the admin account), e.g.
      `review@…`, with a strong password.
- [ ] Add a sample pet with a photo, a vaccination, a few weight entries
      and one symptom check, so reviewers see real screens.
- [ ] Enter the credentials in App Store Connect → App Review Information,
      and Play Console → App access.
- [ ] **Apple review notes** (guideline 1.4.1, medical content). Suggested
      text, to finalize once the vet review is done:

      PawHealth helps pet owners keep health records for their dogs and
      cats. The symptom checker asks a few questions and gives a general
      urgency level ("monitor at home", "see a vet soon", "emergency"). It
      does not diagnose, and every result shows a disclaimer telling owners
      to contact a veterinarian. The content was reviewed by a licensed
      veterinarian, [NAME, CLINIC], in [MONTH YEAR]. The app is about
      animals only and collects no health data about users.

      Demo account: [EMAIL] / [PASSWORD]. PawHealth Plus can be tested with
      a sandbox account from the Plus screen (crown icon).
