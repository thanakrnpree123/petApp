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

  /// No description provided for @saveShareWithVet.
  ///
  /// In en, this message translates to:
  /// **'Save & Share with Vet'**
  String get saveShareWithVet;

  /// No description provided for @savedShareAgain.
  ///
  /// In en, this message translates to:
  /// **'Saved — Share Again'**
  String get savedShareAgain;

  /// No description provided for @savingCheck.
  ///
  /// In en, this message translates to:
  /// **'Saving check…'**
  String get savingCheck;

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
