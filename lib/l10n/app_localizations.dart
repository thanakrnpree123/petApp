import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_th.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('th'),
    Locale('zh'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'PawHealth'**
  String get appTitle;

  /// No description provided for @myPets.
  ///
  /// In en, this message translates to:
  /// **'My Pets'**
  String get myPets;

  /// No description provided for @healthArticles.
  ///
  /// In en, this message translates to:
  /// **'Health Articles'**
  String get healthArticles;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @articlesTab.
  ///
  /// In en, this message translates to:
  /// **'Articles'**
  String get articlesTab;

  /// No description provided for @noPetsYet.
  ///
  /// In en, this message translates to:
  /// **'No pets yet. Tap + to add one.'**
  String get noPetsYet;

  /// No description provided for @editProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get editProfile;

  /// No description provided for @checkSymptoms.
  ///
  /// In en, this message translates to:
  /// **'Check Symptoms'**
  String get checkSymptoms;

  /// No description provided for @upgradeToPlusTooltip.
  ///
  /// In en, this message translates to:
  /// **'Upgrade to Plus'**
  String get upgradeToPlusTooltip;

  /// No description provided for @pawHealthPlus.
  ///
  /// In en, this message translates to:
  /// **'PawHealth Plus'**
  String get pawHealthPlus;

  /// No description provided for @upgradeToPlus.
  ///
  /// In en, this message translates to:
  /// **'Upgrade to Plus'**
  String get upgradeToPlus;

  /// No description provided for @monthlyPrice.
  ///
  /// In en, this message translates to:
  /// **'{price}/month'**
  String monthlyPrice(String price);

  /// No description provided for @unlimitedSymptomChecks.
  ///
  /// In en, this message translates to:
  /// **'Unlimited symptom checks'**
  String get unlimitedSymptomChecks;

  /// No description provided for @unlimitedPdfReports.
  ///
  /// In en, this message translates to:
  /// **'Unlimited PDF vet reports'**
  String get unlimitedPdfReports;

  /// No description provided for @adFreeExperience.
  ///
  /// In en, this message translates to:
  /// **'Ad-free experience'**
  String get adFreeExperience;

  /// No description provided for @freeTierIncludes.
  ///
  /// In en, this message translates to:
  /// **'Free tier includes'**
  String get freeTierIncludes;

  /// No description provided for @freeChecksPerMonth.
  ///
  /// In en, this message translates to:
  /// **'5 symptom checks / month'**
  String get freeChecksPerMonth;

  /// No description provided for @containsAds.
  ///
  /// In en, this message translates to:
  /// **'Contains ads'**
  String get containsAds;

  /// No description provided for @subscribe.
  ///
  /// In en, this message translates to:
  /// **'Subscribe'**
  String get subscribe;

  /// No description provided for @restorePurchases.
  ///
  /// In en, this message translates to:
  /// **'Restore Purchases'**
  String get restorePurchases;

  /// No description provided for @upgrade.
  ///
  /// In en, this message translates to:
  /// **'Upgrade'**
  String get upgrade;

  /// No description provided for @notNow.
  ///
  /// In en, this message translates to:
  /// **'Not now'**
  String get notNow;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @account.
  ///
  /// In en, this message translates to:
  /// **'ACCOUNT'**
  String get account;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @subscription.
  ///
  /// In en, this message translates to:
  /// **'Subscription'**
  String get subscription;

  /// No description provided for @freeTier.
  ///
  /// In en, this message translates to:
  /// **'Free'**
  String get freeTier;

  /// No description provided for @logOut.
  ///
  /// In en, this message translates to:
  /// **'Log Out'**
  String get logOut;

  /// No description provided for @pdfPlusFeatureMessage.
  ///
  /// In en, this message translates to:
  /// **'PDF vet reports are a PawHealth Plus feature. Upgrade to export and share unlimited reports.'**
  String get pdfPlusFeatureMessage;

  /// No description provided for @symptomLimitMessage.
  ///
  /// In en, this message translates to:
  /// **'You\'ve used your 5 free symptom checks this month. Upgrade for unlimited checks.'**
  String get symptomLimitMessage;

  /// No description provided for @fetchingArticles.
  ///
  /// In en, this message translates to:
  /// **'Fetching articles…'**
  String get fetchingArticles;

  /// No description provided for @noArticlesAvailable.
  ///
  /// In en, this message translates to:
  /// **'No articles available right now.'**
  String get noArticlesAvailable;

  /// No description provided for @logIn.
  ///
  /// In en, this message translates to:
  /// **'Log In'**
  String get logIn;

  /// No description provided for @register.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get register;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @confirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPassword;

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get createAccount;

  /// No description provided for @noAccountRegister.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account? Register'**
  String get noAccountRegister;

  /// No description provided for @loggingIn.
  ///
  /// In en, this message translates to:
  /// **'Logging in…'**
  String get loggingIn;

  /// No description provided for @loginBrandTagline.
  ///
  /// In en, this message translates to:
  /// **'Every vaccine, weigh-in, and vet visit — in one timeline.'**
  String get loginBrandTagline;

  /// No description provided for @creatingAccount.
  ///
  /// In en, this message translates to:
  /// **'Creating your account…'**
  String get creatingAccount;

  /// No description provided for @emailRequired.
  ///
  /// In en, this message translates to:
  /// **'Email is required'**
  String get emailRequired;

  /// No description provided for @emailInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid email address'**
  String get emailInvalid;

  /// No description provided for @passwordRequired.
  ///
  /// In en, this message translates to:
  /// **'Password is required'**
  String get passwordRequired;

  /// No description provided for @passwordTooShort.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters'**
  String get passwordTooShort;

  /// No description provided for @passwordsDoNotMatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwordsDoNotMatch;

  /// No description provided for @errInvalidEmail.
  ///
  /// In en, this message translates to:
  /// **'That email address looks invalid.'**
  String get errInvalidEmail;

  /// No description provided for @errIncorrectCredentials.
  ///
  /// In en, this message translates to:
  /// **'Incorrect email or password.'**
  String get errIncorrectCredentials;

  /// No description provided for @errEmailInUse.
  ///
  /// In en, this message translates to:
  /// **'An account already exists for that email.'**
  String get errEmailInUse;

  /// No description provided for @errWeakPassword.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters.'**
  String get errWeakPassword;

  /// No description provided for @errPermissionDenied.
  ///
  /// In en, this message translates to:
  /// **'Could not save your profile (permission denied). Check Firestore security rules.'**
  String get errPermissionDenied;

  /// No description provided for @errGeneric.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again.'**
  String get errGeneric;

  /// No description provided for @addPet.
  ///
  /// In en, this message translates to:
  /// **'Add Pet'**
  String get addPet;

  /// No description provided for @editPet.
  ///
  /// In en, this message translates to:
  /// **'Edit Pet'**
  String get editPet;

  /// No description provided for @deletePet.
  ///
  /// In en, this message translates to:
  /// **'Delete Pet'**
  String get deletePet;

  /// No description provided for @deletePetTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete {petName}?'**
  String deletePetTitle(String petName);

  /// No description provided for @deletePetConfirmMessage.
  ///
  /// In en, this message translates to:
  /// **'This permanently deletes {petName}\'s profile and all of their health records, vaccinations, and care logs. This cannot be undone.'**
  String deletePetConfirmMessage(String petName);

  /// No description provided for @petDeleted.
  ///
  /// In en, this message translates to:
  /// **'{petName} was deleted.'**
  String petDeleted(String petName);

  /// No description provided for @deletePetFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t delete {petName}. Please try again.'**
  String deletePetFailed(String petName);

  /// No description provided for @petName.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get petName;

  /// No description provided for @nameRequired.
  ///
  /// In en, this message translates to:
  /// **'Name is required'**
  String get nameRequired;

  /// No description provided for @breed.
  ///
  /// In en, this message translates to:
  /// **'Breed'**
  String get breed;

  /// No description provided for @speciesDog.
  ///
  /// In en, this message translates to:
  /// **'Dog'**
  String get speciesDog;

  /// No description provided for @speciesCat.
  ///
  /// In en, this message translates to:
  /// **'Cat'**
  String get speciesCat;

  /// No description provided for @selectBirthdate.
  ///
  /// In en, this message translates to:
  /// **'Select birthdate'**
  String get selectBirthdate;

  /// No description provided for @weightKg.
  ///
  /// In en, this message translates to:
  /// **'Weight (kg)'**
  String get weightKg;

  /// No description provided for @enterValidWeight.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid weight'**
  String get enterValidWeight;

  /// No description provided for @selectBreedError.
  ///
  /// In en, this message translates to:
  /// **'Please select a breed'**
  String get selectBreedError;

  /// No description provided for @selectBirthdateError.
  ///
  /// In en, this message translates to:
  /// **'Please select a birthdate'**
  String get selectBirthdateError;

  /// No description provided for @saveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get saveChanges;

  /// No description provided for @savingPet.
  ///
  /// In en, this message translates to:
  /// **'Saving…'**
  String get savingPet;

  /// No description provided for @uploadingPhoto.
  ///
  /// In en, this message translates to:
  /// **'Uploading photo…'**
  String get uploadingPhoto;

  /// No description provided for @errSaveTimeout.
  ///
  /// In en, this message translates to:
  /// **'The network is too slow right now. Your photo may still finish uploading — try saving again in a moment.'**
  String get errSaveTimeout;

  /// No description provided for @errRulesPermission.
  ///
  /// In en, this message translates to:
  /// **'Permission denied. Check that Firestore/Storage security rules are deployed.'**
  String get errRulesPermission;

  /// No description provided for @errCouldNotSavePet.
  ///
  /// In en, this message translates to:
  /// **'Could not save pet. Please try again.'**
  String get errCouldNotSavePet;

  /// No description provided for @errSubscriptionLoad.
  ///
  /// In en, this message translates to:
  /// **'Could not load subscription status.'**
  String get errSubscriptionLoad;

  /// No description provided for @errPurchaseFailed.
  ///
  /// In en, this message translates to:
  /// **'Purchase failed. Please try again.'**
  String get errPurchaseFailed;

  /// No description provided for @errRestoreFailed.
  ///
  /// In en, this message translates to:
  /// **'Restore failed. Please try again.'**
  String get errRestoreFailed;

  /// No description provided for @processingPurchase.
  ///
  /// In en, this message translates to:
  /// **'Processing purchase…'**
  String get processingPurchase;

  /// No description provided for @restoringPurchases.
  ///
  /// In en, this message translates to:
  /// **'Restoring purchases…'**
  String get restoringPurchases;

  /// No description provided for @symptomCheckerTitle.
  ///
  /// In en, this message translates to:
  /// **'Symptom Checker · {petName}'**
  String symptomCheckerTitle(String petName);

  /// No description provided for @noChecksForSpecies.
  ///
  /// In en, this message translates to:
  /// **'No symptom checks are available for this species yet.'**
  String get noChecksForSpecies;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @triageMonitor.
  ///
  /// In en, this message translates to:
  /// **'Monitor at Home'**
  String get triageMonitor;

  /// No description provided for @triageVet.
  ///
  /// In en, this message translates to:
  /// **'See a Vet Soon'**
  String get triageVet;

  /// No description provided for @triageEmergency.
  ///
  /// In en, this message translates to:
  /// **'Emergency — Act Now'**
  String get triageEmergency;

  /// No description provided for @medicalDisclaimer.
  ///
  /// In en, this message translates to:
  /// **'This tool provides general guidance only and is not a substitute for professional veterinary diagnosis. When in doubt, contact your vet.'**
  String get medicalDisclaimer;

  /// No description provided for @symptomVomiting.
  ///
  /// In en, this message translates to:
  /// **'Vomiting'**
  String get symptomVomiting;

  /// No description provided for @shareSummaryTitle.
  ///
  /// In en, this message translates to:
  /// **'PawHealth Symptom Check — {petName}'**
  String shareSummaryTitle(String petName);

  /// No description provided for @shareSymptom.
  ///
  /// In en, this message translates to:
  /// **'Symptom: {symptom}'**
  String shareSymptom(String symptom);

  /// No description provided for @shareTriageLevel.
  ///
  /// In en, this message translates to:
  /// **'Triage level: {level}'**
  String shareTriageLevel(String level);

  /// No description provided for @shareAdvice.
  ///
  /// In en, this message translates to:
  /// **'Advice: {advice}'**
  String shareAdvice(String advice);

  /// No description provided for @shareAnswersHeader.
  ///
  /// In en, this message translates to:
  /// **'Answers:'**
  String get shareAnswersHeader;

  /// No description provided for @qVomitFrequency.
  ///
  /// In en, this message translates to:
  /// **'How many times has your dog vomited in the last 24 hours?'**
  String get qVomitFrequency;

  /// No description provided for @qBloodInVomit.
  ///
  /// In en, this message translates to:
  /// **'Is there any blood in the vomit (red streaks or coffee-ground appearance)?'**
  String get qBloodInVomit;

  /// No description provided for @qLethargyMild.
  ///
  /// In en, this message translates to:
  /// **'Is your dog acting lethargic, weak, or unlike themselves?'**
  String get qLethargyMild;

  /// No description provided for @qToxinIngestion.
  ///
  /// In en, this message translates to:
  /// **'Could your dog have eaten something toxic, a foreign object, human medication, or spoiled food?'**
  String get qToxinIngestion;

  /// No description provided for @qBloatedAbdomen.
  ///
  /// In en, this message translates to:
  /// **'Does your dog have a swollen or bloated abdomen, or are they retching without producing vomit?'**
  String get qBloatedAbdomen;

  /// No description provided for @qAgeVulnerable.
  ///
  /// In en, this message translates to:
  /// **'Is your dog a puppy (under 6 months), a senior (over 8 years), or do they have a chronic health condition?'**
  String get qAgeVulnerable;

  /// No description provided for @qLethargyModerate.
  ///
  /// In en, this message translates to:
  /// **'Is your dog acting lethargic, weak, or refusing water?'**
  String get qLethargyModerate;

  /// No description provided for @opt1Time.
  ///
  /// In en, this message translates to:
  /// **'1 time'**
  String get opt1Time;

  /// No description provided for @opt2to3Times.
  ///
  /// In en, this message translates to:
  /// **'2-3 times'**
  String get opt2to3Times;

  /// No description provided for @opt4Plus.
  ///
  /// In en, this message translates to:
  /// **'4 or more times'**
  String get opt4Plus;

  /// No description provided for @optYes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get optYes;

  /// No description provided for @optNo.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get optNo;

  /// No description provided for @advEmergencyFrequent.
  ///
  /// In en, this message translates to:
  /// **'Vomiting 4+ times in 24 hours risks serious dehydration. Contact an emergency vet immediately.'**
  String get advEmergencyFrequent;

  /// No description provided for @advEmergencyBlood.
  ///
  /// In en, this message translates to:
  /// **'Blood in vomit can indicate internal bleeding or a serious GI issue. Seek emergency veterinary care now.'**
  String get advEmergencyBlood;

  /// No description provided for @advEmergencyToxin.
  ///
  /// In en, this message translates to:
  /// **'Possible toxin or foreign object ingestion is an emergency. Contact an emergency vet or pet poison hotline immediately.'**
  String get advEmergencyToxin;

  /// No description provided for @advEmergencyBloat.
  ///
  /// In en, this message translates to:
  /// **'A bloated abdomen with retching can signal GDV (bloat), a life-threatening emergency. Go to an emergency vet immediately.'**
  String get advEmergencyBloat;

  /// No description provided for @advVetLethargy.
  ///
  /// In en, this message translates to:
  /// **'Lethargy alongside vomiting warrants a same-day vet visit. Withhold food, offer small sips of water.'**
  String get advVetLethargy;

  /// No description provided for @advVetVulnerable.
  ///
  /// In en, this message translates to:
  /// **'Puppies, seniors, and dogs with chronic conditions dehydrate quickly. Book a vet visit within 24 hours.'**
  String get advVetVulnerable;

  /// No description provided for @advVetModerate.
  ///
  /// In en, this message translates to:
  /// **'Repeated vomiting without other red flags still warrants a vet check within 24 hours. Withhold food for 12 hours, offer small amounts of water.'**
  String get advVetModerate;

  /// No description provided for @advMonitorMild.
  ///
  /// In en, this message translates to:
  /// **'A single vomiting episode with no other symptoms can often be monitored at home. Withhold food for a few hours, ensure fresh water, and watch for recurrence.'**
  String get advMonitorMild;

  /// No description provided for @gender.
  ///
  /// In en, this message translates to:
  /// **'Gender'**
  String get gender;

  /// No description provided for @genderMale.
  ///
  /// In en, this message translates to:
  /// **'Male'**
  String get genderMale;

  /// No description provided for @genderFemale.
  ///
  /// In en, this message translates to:
  /// **'Female'**
  String get genderFemale;

  /// No description provided for @spayedNeutered.
  ///
  /// In en, this message translates to:
  /// **'Spayed / Neutered'**
  String get spayedNeutered;

  /// No description provided for @careParasiteControl.
  ///
  /// In en, this message translates to:
  /// **'Parasite Control'**
  String get careParasiteControl;

  /// No description provided for @careHeatCycle.
  ///
  /// In en, this message translates to:
  /// **'Heat Cycle'**
  String get careHeatCycle;

  /// No description provided for @careMedicalSurgery.
  ///
  /// In en, this message translates to:
  /// **'Medical & Surgery'**
  String get careMedicalSurgery;

  /// No description provided for @careGrooming.
  ///
  /// In en, this message translates to:
  /// **'Grooming & Bathing'**
  String get careGrooming;

  /// No description provided for @addEntry.
  ///
  /// In en, this message translates to:
  /// **'Add Entry'**
  String get addEntry;

  /// No description provided for @careNote.
  ///
  /// In en, this message translates to:
  /// **'Note'**
  String get careNote;

  /// No description provided for @noteRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter a note'**
  String get noteRequired;

  /// No description provided for @noEntriesYet.
  ///
  /// In en, this message translates to:
  /// **'No entries yet.'**
  String get noEntriesYet;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @chooseLanguage.
  ///
  /// In en, this message translates to:
  /// **'Choose Language'**
  String get chooseLanguage;

  /// No description provided for @careTitle.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get careTitle;

  /// No description provided for @careDetails.
  ///
  /// In en, this message translates to:
  /// **'Details'**
  String get careDetails;

  /// No description provided for @titleRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter a title'**
  String get titleRequired;

  /// No description provided for @categoryLabel.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get categoryLabel;

  /// No description provided for @healthDashboardTitle.
  ///
  /// In en, this message translates to:
  /// **'{petName} · Health'**
  String healthDashboardTitle(String petName);

  /// No description provided for @generateReport.
  ///
  /// In en, this message translates to:
  /// **'Generate Report'**
  String get generateReport;

  /// No description provided for @addHealthRecord.
  ///
  /// In en, this message translates to:
  /// **'Add New Health Record'**
  String get addHealthRecord;

  /// No description provided for @filterAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get filterAll;

  /// No description provided for @filterVaccination.
  ///
  /// In en, this message translates to:
  /// **'Vaccination'**
  String get filterVaccination;

  /// No description provided for @filterMedical.
  ///
  /// In en, this message translates to:
  /// **'Medical'**
  String get filterMedical;

  /// No description provided for @filterGrooming.
  ///
  /// In en, this message translates to:
  /// **'Grooming'**
  String get filterGrooming;

  /// No description provided for @filterOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get filterOther;

  /// No description provided for @timelineEmpty.
  ///
  /// In en, this message translates to:
  /// **'No health records yet.'**
  String get timelineEmpty;

  /// No description provided for @weight.
  ///
  /// In en, this message translates to:
  /// **'Weight'**
  String get weight;

  /// No description provided for @logWeight.
  ///
  /// In en, this message translates to:
  /// **'Log Weight'**
  String get logWeight;

  /// No description provided for @weightChartNeedTwo.
  ///
  /// In en, this message translates to:
  /// **'Log at least two weigh-ins to see a trend.'**
  String get weightChartNeedTwo;

  /// No description provided for @addVaccine.
  ///
  /// In en, this message translates to:
  /// **'Add Vaccine'**
  String get addVaccine;

  /// No description provided for @vaccineName.
  ///
  /// In en, this message translates to:
  /// **'Vaccine name'**
  String get vaccineName;

  /// No description provided for @administeredOn.
  ///
  /// In en, this message translates to:
  /// **'Administered: {date}'**
  String administeredOn(String date);

  /// No description provided for @nextDueOn.
  ///
  /// In en, this message translates to:
  /// **'Next due: {date}'**
  String nextDueOn(String date);

  /// No description provided for @selectNextDueDate.
  ///
  /// In en, this message translates to:
  /// **'Select next due date'**
  String get selectNextDueDate;

  /// No description provided for @selectNextDueDateError.
  ///
  /// In en, this message translates to:
  /// **'Select a next due date'**
  String get selectNextDueDateError;

  /// No description provided for @vaccinationDates.
  ///
  /// In en, this message translates to:
  /// **'Given {given} · Next due {next}'**
  String vaccinationDates(String given, String next);

  /// No description provided for @editHealthRecord.
  ///
  /// In en, this message translates to:
  /// **'Edit Health Record'**
  String get editHealthRecord;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @deleteRecordTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Record'**
  String get deleteRecordTitle;

  /// No description provided for @deleteConfirmMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this record? This cannot be undone.'**
  String get deleteConfirmMessage;

  /// No description provided for @healthRecordButton.
  ///
  /// In en, this message translates to:
  /// **'Health Record'**
  String get healthRecordButton;

  /// No description provided for @editVaccination.
  ///
  /// In en, this message translates to:
  /// **'Edit Vaccination'**
  String get editVaccination;

  /// No description provided for @speciesRabbit.
  ///
  /// In en, this message translates to:
  /// **'Rabbit'**
  String get speciesRabbit;

  /// No description provided for @speciesBird.
  ///
  /// In en, this message translates to:
  /// **'Bird'**
  String get speciesBird;

  /// No description provided for @speciesExotic.
  ///
  /// In en, this message translates to:
  /// **'Exotic / Other'**
  String get speciesExotic;

  /// No description provided for @speciesLabel.
  ///
  /// In en, this message translates to:
  /// **'Species'**
  String get speciesLabel;

  /// No description provided for @breedOther.
  ///
  /// In en, this message translates to:
  /// **'Other (Please specify)'**
  String get breedOther;

  /// No description provided for @enterBreed.
  ///
  /// In en, this message translates to:
  /// **'Please enter the breed'**
  String get enterBreed;

  /// No description provided for @microchipId.
  ///
  /// In en, this message translates to:
  /// **'Microchip ID'**
  String get microchipId;

  /// No description provided for @allergies.
  ///
  /// In en, this message translates to:
  /// **'Known Allergies (Food/Medication)'**
  String get allergies;

  /// No description provided for @ageYearsMonths.
  ///
  /// In en, this message translates to:
  /// **'{years} yr {months} mo'**
  String ageYearsMonths(int years, int months);

  /// No description provided for @ageMonths.
  ///
  /// In en, this message translates to:
  /// **'{months} mo'**
  String ageMonths(int months);

  /// No description provided for @optNoSymptoms.
  ///
  /// In en, this message translates to:
  /// **'No symptoms / General checkup'**
  String get optNoSymptoms;

  /// No description provided for @advHealthy.
  ///
  /// In en, this message translates to:
  /// **'Your pet seems healthy! Keep up the good work — continue regular checkups and preventive care.'**
  String get advHealthy;

  /// No description provided for @shareWithVet.
  ///
  /// In en, this message translates to:
  /// **'Share with Vet'**
  String get shareWithVet;

  /// No description provided for @checkSavedToHistory.
  ///
  /// In en, this message translates to:
  /// **'Saved to {petName}\'s health history'**
  String checkSavedToHistory(String petName);

  /// No description provided for @checkSaveFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t save this check. Tap Share to try again.'**
  String get checkSaveFailed;

  /// No description provided for @symptomPickerTitle.
  ///
  /// In en, this message translates to:
  /// **'What\'s wrong with {petName}?'**
  String symptomPickerTitle(String petName);

  /// No description provided for @symptomPickerHint.
  ///
  /// In en, this message translates to:
  /// **'Choose the main symptom. We\'ll ask a few quick questions.'**
  String get symptomPickerHint;

  /// No description provided for @emergencyNotice.
  ///
  /// In en, this message translates to:
  /// **'If your pet has collapsed, isn\'t breathing, or is having a seizure, go to an emergency vet now — don\'t wait.'**
  String get emergencyNotice;

  /// No description provided for @symptomDiarrhea.
  ///
  /// In en, this message translates to:
  /// **'Diarrhea'**
  String get symptomDiarrhea;

  /// No description provided for @symptomNotEating.
  ///
  /// In en, this message translates to:
  /// **'Not eating or low energy'**
  String get symptomNotEating;

  /// No description provided for @symptomUrinary.
  ///
  /// In en, this message translates to:
  /// **'Peeing problems'**
  String get symptomUrinary;

  /// No description provided for @symptomToxin.
  ///
  /// In en, this message translates to:
  /// **'Ate something harmful'**
  String get symptomToxin;

  /// No description provided for @symptomBreathing.
  ///
  /// In en, this message translates to:
  /// **'Breathing problems'**
  String get symptomBreathing;

  /// No description provided for @symptomLimping.
  ///
  /// In en, this message translates to:
  /// **'Limping or injury'**
  String get symptomLimping;

  /// No description provided for @qDdSystemic.
  ///
  /// In en, this message translates to:
  /// **'Is your dog also vomiting repeatedly, very weak, or collapsing?'**
  String get qDdSystemic;

  /// No description provided for @qDdBlood.
  ///
  /// In en, this message translates to:
  /// **'Is there a lot of blood in the stool (red and jelly-like), or is it black and tarry?'**
  String get qDdBlood;

  /// No description provided for @qDdToxin.
  ///
  /// In en, this message translates to:
  /// **'Could your dog have eaten something toxic (such as medication, chocolate, xylitol, or grapes) or a foreign object?'**
  String get qDdToxin;

  /// No description provided for @qDdVulnerable.
  ///
  /// In en, this message translates to:
  /// **'Is your dog a puppy (under 6 months), a senior (over 8 years), unvaccinated, or living with a chronic health condition?'**
  String get qDdVulnerable;

  /// No description provided for @qDiarrheaDuration.
  ///
  /// In en, this message translates to:
  /// **'How long has the diarrhea lasted?'**
  String get qDiarrheaDuration;

  /// No description provided for @qCollapse.
  ///
  /// In en, this message translates to:
  /// **'Has your pet collapsed, or are their gums pale, white, grey, or blue?'**
  String get qCollapse;

  /// No description provided for @qDnFluids.
  ///
  /// In en, this message translates to:
  /// **'Is your dog also refusing water, or vomiting?'**
  String get qDnFluids;

  /// No description provided for @qDnDuration.
  ///
  /// In en, this message translates to:
  /// **'How long has your dog been off their food?'**
  String get qDnDuration;

  /// No description provided for @qCatVomitFrequency.
  ///
  /// In en, this message translates to:
  /// **'How many times has your cat vomited in the last 24 hours?'**
  String get qCatVomitFrequency;

  /// No description provided for @qCatForeign.
  ///
  /// In en, this message translates to:
  /// **'Could your cat have swallowed string, thread, ribbon, a hair tie, or part of a lily plant?'**
  String get qCatForeign;

  /// No description provided for @qCatLethargy.
  ///
  /// In en, this message translates to:
  /// **'Has your cat stopped eating, or are they hiding or much less active than usual?'**
  String get qCatLethargy;

  /// No description provided for @qUrinaryStraining.
  ///
  /// In en, this message translates to:
  /// **'Is your cat straining in the litter box but passing little or no urine?'**
  String get qUrinaryStraining;

  /// No description provided for @qCnDuration.
  ///
  /// In en, this message translates to:
  /// **'How long has your cat not been eating?'**
  String get qCnDuration;

  /// No description provided for @qCnSigns.
  ///
  /// In en, this message translates to:
  /// **'Is your cat also vomiting, hiding, or much less active than usual?'**
  String get qCnSigns;

  /// No description provided for @qCuBlood.
  ///
  /// In en, this message translates to:
  /// **'Is there blood in the urine, or is your cat crying out in the litter box or licking their genitals a lot?'**
  String get qCuBlood;

  /// No description provided for @qCuFrequency.
  ///
  /// In en, this message translates to:
  /// **'Is your cat peeing more often than usual, or outside the litter box?'**
  String get qCuFrequency;

  /// No description provided for @qCuThirst.
  ///
  /// In en, this message translates to:
  /// **'Is your cat also drinking much more water than usual?'**
  String get qCuThirst;

  /// No description provided for @qTxSigns.
  ///
  /// In en, this message translates to:
  /// **'Is your pet having seizures, trembling, collapsing, or struggling to breathe?'**
  String get qTxSigns;

  /// No description provided for @qTxWhat.
  ///
  /// In en, this message translates to:
  /// **'What might your pet have eaten or been exposed to?'**
  String get qTxWhat;

  /// No description provided for @qTxObject.
  ///
  /// In en, this message translates to:
  /// **'Is your pet vomiting repeatedly, unable to keep food down, or does their belly seem painful?'**
  String get qTxObject;

  /// No description provided for @qTxEvidence.
  ///
  /// In en, this message translates to:
  /// **'Did you find chewed packaging, spilled pills, a chewed plant, or an open container nearby?'**
  String get qTxEvidence;

  /// No description provided for @qBrHeat.
  ///
  /// In en, this message translates to:
  /// **'Has your pet been in a hot car, out in the sun, or exercising in hot weather — and are they panting heavily or drooling?'**
  String get qBrHeat;

  /// No description provided for @qBrEffort.
  ///
  /// In en, this message translates to:
  /// **'Is your pet struggling to breathe while resting — breathing fast, with visible effort, or (for cats) with their mouth open?'**
  String get qBrEffort;

  /// No description provided for @qBrCough.
  ///
  /// In en, this message translates to:
  /// **'Is your pet coughing, sneezing, or does it have a runny nose?'**
  String get qBrCough;

  /// No description provided for @qBrUnwell.
  ///
  /// In en, this message translates to:
  /// **'Is your pet also eating less or low on energy, or has this lasted more than 3 days?'**
  String get qBrUnwell;

  /// No description provided for @qLmTrauma.
  ///
  /// In en, this message translates to:
  /// **'Was your pet hit by a car or did it have a bad fall, or is there an obvious broken bone, deep wound, or heavy bleeding?'**
  String get qLmTrauma;

  /// No description provided for @qLmParalysis.
  ///
  /// In en, this message translates to:
  /// **'Is your pet suddenly unable to use their back legs, dragging them, or crying out in pain?'**
  String get qLmParalysis;

  /// No description provided for @qLmWeight.
  ///
  /// In en, this message translates to:
  /// **'Can your pet put any weight on the leg?'**
  String get qLmWeight;

  /// No description provided for @qLmDuration.
  ///
  /// In en, this message translates to:
  /// **'Has the limp lasted more than 2 days, or is the leg swollen or hot to the touch?'**
  String get qLmDuration;

  /// No description provided for @optLess24h.
  ///
  /// In en, this message translates to:
  /// **'Less than 24 hours'**
  String get optLess24h;

  /// No description provided for @optMore24h.
  ///
  /// In en, this message translates to:
  /// **'More than 24 hours'**
  String get optMore24h;

  /// No description provided for @optHumanMedication.
  ///
  /// In en, this message translates to:
  /// **'Human medication'**
  String get optHumanMedication;

  /// No description provided for @optToxicFoods.
  ///
  /// In en, this message translates to:
  /// **'Chocolate, xylitol, grapes, raisins, onions, or garlic'**
  String get optToxicFoods;

  /// No description provided for @optToxicPlant.
  ///
  /// In en, this message translates to:
  /// **'Lilies or another toxic plant'**
  String get optToxicPlant;

  /// No description provided for @optChemicals.
  ///
  /// In en, this message translates to:
  /// **'Rat poison, antifreeze, or household chemicals'**
  String get optChemicals;

  /// No description provided for @optObject.
  ///
  /// In en, this message translates to:
  /// **'A toy, sock, bone, or other object'**
  String get optObject;

  /// No description provided for @optNotSure.
  ///
  /// In en, this message translates to:
  /// **'Not sure'**
  String get optNotSure;

  /// No description provided for @optLimpingYes.
  ///
  /// In en, this message translates to:
  /// **'Yes, but they\'re limping'**
  String get optLimpingYes;

  /// No description provided for @optLimpingNo.
  ///
  /// In en, this message translates to:
  /// **'No, they hold the leg up'**
  String get optLimpingNo;

  /// No description provided for @advDdSystemic.
  ///
  /// In en, this message translates to:
  /// **'Diarrhea with repeated vomiting, weakness, or collapse can quickly cause dangerous dehydration or signal a serious illness. Go to an emergency vet now.'**
  String get advDdSystemic;

  /// No description provided for @advDdBlood.
  ///
  /// In en, this message translates to:
  /// **'Large amounts of blood, or black, tarry stool, can mean serious bleeding in the gut. Seek emergency veterinary care now.'**
  String get advDdBlood;

  /// No description provided for @advDdVulnerable.
  ///
  /// In en, this message translates to:
  /// **'Puppies, seniors, unvaccinated dogs, and dogs with health conditions dehydrate quickly — and puppies are at risk of parvovirus. Have your dog seen by a vet today.'**
  String get advDdVulnerable;

  /// No description provided for @advDdDuration.
  ///
  /// In en, this message translates to:
  /// **'Diarrhea lasting more than a day should be checked by a vet within 24 hours. Keep fresh water available, and bring a fresh stool sample if you can.'**
  String get advDdDuration;

  /// No description provided for @advDdMonitor.
  ///
  /// In en, this message translates to:
  /// **'Mild diarrhea in a dog that is otherwise bright and eating can usually be watched at home. Keep fresh water available, feed small bland meals, and see a vet if it lasts more than 24 hours or new symptoms appear.'**
  String get advDdMonitor;

  /// No description provided for @advEmergencyCollapse.
  ///
  /// In en, this message translates to:
  /// **'Collapse or pale, white, grey, or blue gums can signal shock, blood loss, or a breathing problem. Go to an emergency vet immediately.'**
  String get advEmergencyCollapse;

  /// No description provided for @advDnVetToday.
  ///
  /// In en, this message translates to:
  /// **'Not eating along with refusing water or vomiting can quickly lead to dehydration. Have your dog seen by a vet today.'**
  String get advDnVetToday;

  /// No description provided for @advDnDuration.
  ///
  /// In en, this message translates to:
  /// **'A dog that hasn\'t eaten for more than a day should be seen by a vet within 24 hours, even without other symptoms.'**
  String get advDnDuration;

  /// No description provided for @advDnMonitor.
  ///
  /// In en, this message translates to:
  /// **'Skipping a meal in an otherwise bright, active dog is often caused by heat, stress, or a change in routine. Offer fresh water and their usual food, and see a vet if they still haven\'t eaten after 24 hours or new symptoms appear.'**
  String get advDnMonitor;

  /// No description provided for @advCvForeign.
  ///
  /// In en, this message translates to:
  /// **'Swallowed string can badly damage a cat\'s intestines, and every part of a lily is highly toxic to cats. Go to an emergency vet now — never pull on string you can see.'**
  String get advCvForeign;

  /// No description provided for @advCvLethargy.
  ///
  /// In en, this message translates to:
  /// **'Vomiting with loss of appetite, hiding, or low energy needs a vet visit today — cats that stop eating can develop serious liver problems.'**
  String get advCvLethargy;

  /// No description provided for @advCvRepeat.
  ///
  /// In en, this message translates to:
  /// **'Repeated vomiting should be checked by a vet within 24 hours. Keep fresh water available, and don\'t withhold food for more than a few hours — cats shouldn\'t go long without eating.'**
  String get advCvRepeat;

  /// No description provided for @advCvMonitor.
  ///
  /// In en, this message translates to:
  /// **'A single vomit — often a hairball — in a cat that is still eating and acting normally can usually be watched at home. See a vet if it happens again or other symptoms appear.'**
  String get advCvMonitor;

  /// No description provided for @advEmergencyUrinary.
  ///
  /// In en, this message translates to:
  /// **'Straining to pee with little or nothing coming out can mean a urinary blockage — a life-threatening emergency, especially in male cats. Go to an emergency vet now.'**
  String get advEmergencyUrinary;

  /// No description provided for @advCnFasting.
  ///
  /// In en, this message translates to:
  /// **'Cats that go without food for more than a day are at risk of fatty liver disease (hepatic lipidosis), which can be life-threatening. Have your cat seen by a vet today.'**
  String get advCnFasting;

  /// No description provided for @advCnSigns.
  ///
  /// In en, this message translates to:
  /// **'Not eating along with vomiting, hiding, or low energy should be checked by a vet today.'**
  String get advCnSigns;

  /// No description provided for @advCnMonitor.
  ///
  /// In en, this message translates to:
  /// **'A cat that has skipped a meal but is otherwise acting normally can be watched closely at home. Offer fresh food and water, and contact a vet if they haven\'t eaten within 24 hours.'**
  String get advCnMonitor;

  /// No description provided for @advCuPain.
  ///
  /// In en, this message translates to:
  /// **'Blood in the urine, pain, or frequent licking can point to cystitis or a urinary infection. Have your cat seen by a vet today — and if they start straining with no urine, treat it as an emergency.'**
  String get advCuPain;

  /// No description provided for @advCuThirst.
  ///
  /// In en, this message translates to:
  /// **'Drinking and peeing more than usual can be a sign of kidney disease, diabetes, or thyroid problems. Book a vet visit within the next few days.'**
  String get advCuThirst;

  /// No description provided for @advCuBehavior.
  ///
  /// In en, this message translates to:
  /// **'Peeing more often or outside the box can be caused by a urinary problem or by stress. Book a vet visit within a few days, and keep the litter box clean and easy to reach.'**
  String get advCuBehavior;

  /// No description provided for @advCuMonitor.
  ///
  /// In en, this message translates to:
  /// **'No urgent urinary warning signs right now. Keep watching the litter box — straining with little or no urine is always an emergency.'**
  String get advCuMonitor;

  /// No description provided for @advTxSigns.
  ///
  /// In en, this message translates to:
  /// **'These signs need emergency care right now. Go to the nearest emergency vet, and bring the packaging or a sample of what was eaten if it\'s safe to do so.'**
  String get advTxSigns;

  /// No description provided for @advTxKnown.
  ///
  /// In en, this message translates to:
  /// **'Many of these are poisonous even in small amounts, and symptoms can take hours to appear. Contact an emergency vet or animal poison hotline now — don\'t wait for symptoms, and don\'t make your pet vomit unless a vet tells you to.'**
  String get advTxKnown;

  /// No description provided for @advTxObstruction.
  ///
  /// In en, this message translates to:
  /// **'These can be signs of a blockage in the gut. Go to an emergency vet now.'**
  String get advTxObstruction;

  /// No description provided for @advTxObject.
  ///
  /// In en, this message translates to:
  /// **'A swallowed object can cause a blockage hours or even days later. Call your vet today for advice, and watch for vomiting, not eating, or a painful belly.'**
  String get advTxObject;

  /// No description provided for @advTxUnsure.
  ///
  /// In en, this message translates to:
  /// **'If you suspect poisoning but aren\'t sure, call your vet or an animal poison hotline now — it\'s always safer to check. Watch for vomiting, drooling, trembling, or unusual behavior.'**
  String get advTxUnsure;

  /// No description provided for @advBrHeat.
  ///
  /// In en, this message translates to:
  /// **'This may be heatstroke, which can be fatal. Move your pet somewhere cool, wet their coat with cool (not ice-cold) water, and go to an emergency vet immediately.'**
  String get advBrHeat;

  /// No description provided for @advBrBreathing.
  ///
  /// In en, this message translates to:
  /// **'Struggling to breathe at rest is an emergency. Keep your pet calm and cool, and go to an emergency vet now. Cats should never breathe with their mouth open.'**
  String get advBrBreathing;

  /// No description provided for @advBrVet.
  ///
  /// In en, this message translates to:
  /// **'Coughing or sneezing with low energy or a poor appetite, or that has lasted more than a few days, should be checked by a vet within 1–2 days.'**
  String get advBrVet;

  /// No description provided for @advBrMonitorCough.
  ///
  /// In en, this message translates to:
  /// **'A mild cough or sneeze in a pet that is eating and active can usually be watched at home. Keep them rested, away from smoke and dust, and see a vet if it gets worse or lasts more than 3 days.'**
  String get advBrMonitorCough;

  /// No description provided for @advBrMonitor.
  ///
  /// In en, this message translates to:
  /// **'No urgent breathing warning signs right now. Resting breathing should be quiet and easy — if your pet starts breathing fast or with effort while resting, treat it as an emergency.'**
  String get advBrMonitor;

  /// No description provided for @advLmTrauma.
  ///
  /// In en, this message translates to:
  /// **'Serious injuries need emergency care even if your pet seems okay — internal injuries aren\'t always visible. Keep your pet as still as possible and go to an emergency vet now.'**
  String get advLmTrauma;

  /// No description provided for @advLmParalysis.
  ///
  /// In en, this message translates to:
  /// **'Sudden weakness or paralysis in the back legs can be caused by a spinal injury or, in cats, a blood clot. This is an emergency — go to a vet now.'**
  String get advLmParalysis;

  /// No description provided for @advLmNonWeight.
  ///
  /// In en, this message translates to:
  /// **'Not putting any weight on a leg needs a vet check within 24 hours — it could be a fracture, torn ligament, or painful infection. Keep your pet rested until then.'**
  String get advLmNonWeight;

  /// No description provided for @advLmPersistent.
  ///
  /// In en, this message translates to:
  /// **'A limp lasting more than a couple of days, or a swollen or hot leg, should be checked by a vet within 1–2 days.'**
  String get advLmPersistent;

  /// No description provided for @advLmMonitor.
  ///
  /// In en, this message translates to:
  /// **'A mild limp is often a minor strain. Rest your pet for 24–48 hours, check their paw for thorns or cuts, and see a vet if it doesn\'t improve. Never give human painkillers — many are toxic to pets.'**
  String get advLmMonitor;

  /// No description provided for @deleteAccount.
  ///
  /// In en, this message translates to:
  /// **'Delete Account'**
  String get deleteAccount;

  /// No description provided for @deleteAccountTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete your account?'**
  String get deleteAccountTitle;

  /// No description provided for @deleteAccountMessage.
  ///
  /// In en, this message translates to:
  /// **'This permanently deletes your account and everything in it — all pets, health records, vaccinations, symptom checks, and photos. This can\'t be undone.'**
  String get deleteAccountMessage;

  /// No description provided for @deleteAccountSubscriptionNote.
  ///
  /// In en, this message translates to:
  /// **'Deleting your account doesn\'t cancel a subscription bought through the App Store or Google Play. Cancel it in your store settings to stop being charged.'**
  String get deleteAccountSubscriptionNote;

  /// No description provided for @confirmPasswordToDelete.
  ///
  /// In en, this message translates to:
  /// **'Enter your password to confirm'**
  String get confirmPasswordToDelete;

  /// No description provided for @deleteAccountConfirm.
  ///
  /// In en, this message translates to:
  /// **'Delete Permanently'**
  String get deleteAccountConfirm;

  /// No description provided for @accountDeleted.
  ///
  /// In en, this message translates to:
  /// **'Your account has been deleted.'**
  String get accountDeleted;

  /// No description provided for @errIncorrectPassword.
  ///
  /// In en, this message translates to:
  /// **'Incorrect password.'**
  String get errIncorrectPassword;

  /// No description provided for @deleteAccountFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t finish deleting your account. Check your connection and try again — your account is still active, so you can finish deleting it.'**
  String get deleteAccountFailed;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot password?'**
  String get forgotPassword;

  /// No description provided for @resetPasswordTitle.
  ///
  /// In en, this message translates to:
  /// **'Reset your password'**
  String get resetPasswordTitle;

  /// No description provided for @resetPasswordMessage.
  ///
  /// In en, this message translates to:
  /// **'Enter your account email and we\'ll send you a link to set a new password.'**
  String get resetPasswordMessage;

  /// No description provided for @sendResetLink.
  ///
  /// In en, this message translates to:
  /// **'Send Reset Link'**
  String get sendResetLink;

  /// No description provided for @resetLinkSent.
  ///
  /// In en, this message translates to:
  /// **'If an account exists for {email}, a reset link is on its way. Check your inbox and spam folder.'**
  String resetLinkSent(String email);

  /// No description provided for @reminderPromptTitle.
  ///
  /// In en, this message translates to:
  /// **'Get vaccine reminders?'**
  String get reminderPromptTitle;

  /// No description provided for @reminderPromptMessage.
  ///
  /// In en, this message translates to:
  /// **'We\'ll remind you the day before {petName}\'s vaccine is due. You can change this anytime in your phone\'s settings.'**
  String reminderPromptMessage(String petName);

  /// No description provided for @turnOnReminders.
  ///
  /// In en, this message translates to:
  /// **'Turn On'**
  String get turnOnReminders;

  /// No description provided for @paywallMobileOnly.
  ///
  /// In en, this message translates to:
  /// **'PawHealth Plus is available in the PawHealth app for iPhone and Android. Subscriptions can\'t be purchased on the web yet.'**
  String get paywallMobileOnly;

  /// No description provided for @paywallUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Subscriptions aren\'t available right now. Please try again later.'**
  String get paywallUnavailable;

  /// No description provided for @tryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try Again'**
  String get tryAgain;

  /// No description provided for @weightOutOfRange.
  ///
  /// In en, this message translates to:
  /// **'Enter a weight between 0.1 and 150 kg.'**
  String get weightOutOfRange;

  /// No description provided for @nextDueBeforeGivenError.
  ///
  /// In en, this message translates to:
  /// **'The next due date must be after the date the vaccine was given.'**
  String get nextDueBeforeGivenError;

  /// No description provided for @takePhoto.
  ///
  /// In en, this message translates to:
  /// **'Take Photo'**
  String get takePhoto;

  /// No description provided for @chooseFromLibrary.
  ///
  /// In en, this message translates to:
  /// **'Choose from Library'**
  String get chooseFromLibrary;

  /// No description provided for @addPetPhoto.
  ///
  /// In en, this message translates to:
  /// **'Add a photo of your pet'**
  String get addPetPhoto;

  /// No description provided for @changePetPhoto.
  ///
  /// In en, this message translates to:
  /// **'Change your pet\'s photo'**
  String get changePetPhoto;

  /// No description provided for @photoAccessDenied.
  ///
  /// In en, this message translates to:
  /// **'PawHealth can\'t open your camera or photos. You can allow access in your phone\'s Settings.'**
  String get photoAccessDenied;

  /// No description provided for @photoPickFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t load that photo. Please try another one.'**
  String get photoPickFailed;

  /// No description provided for @discardChangesTitle.
  ///
  /// In en, this message translates to:
  /// **'Discard changes?'**
  String get discardChangesTitle;

  /// No description provided for @discardChangesMessage.
  ///
  /// In en, this message translates to:
  /// **'You have unsaved changes to this pet. If you leave now, they\'ll be lost.'**
  String get discardChangesMessage;

  /// No description provided for @keepEditing.
  ///
  /// In en, this message translates to:
  /// **'Keep Editing'**
  String get keepEditing;

  /// No description provided for @discard.
  ///
  /// In en, this message translates to:
  /// **'Discard'**
  String get discard;

  /// No description provided for @retake.
  ///
  /// In en, this message translates to:
  /// **'Retake'**
  String get retake;

  /// No description provided for @usePhoto.
  ///
  /// In en, this message translates to:
  /// **'Use Photo'**
  String get usePhoto;

  /// No description provided for @switchCamera.
  ///
  /// In en, this message translates to:
  /// **'Switch camera'**
  String get switchCamera;

  /// No description provided for @cameraPermissionDenied.
  ///
  /// In en, this message translates to:
  /// **'PawHealth can\'t use your camera. Allow camera access for this site in your browser\'s address bar or settings, then try again.'**
  String get cameraPermissionDenied;

  /// No description provided for @cameraNotFound.
  ///
  /// In en, this message translates to:
  /// **'No camera was found. Connect a webcam, or choose a photo from your files instead.'**
  String get cameraNotFound;

  /// No description provided for @cameraInUse.
  ///
  /// In en, this message translates to:
  /// **'Your camera is being used by another app, like a video call. Close it and try again.'**
  String get cameraInUse;

  /// No description provided for @cameraStartFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t start the camera. Please try again.'**
  String get cameraStartFailed;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'th', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'th':
      return AppLocalizationsTh();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
