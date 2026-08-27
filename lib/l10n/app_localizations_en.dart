// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'PawHealth';

  @override
  String get myPets => 'My Pets';

  @override
  String get healthArticles => 'Health Articles';

  @override
  String get settings => 'Settings';

  @override
  String get articlesTab => 'Articles';

  @override
  String get noPetsYet => 'No pets yet. Tap + to add one.';

  @override
  String get editProfile => 'Edit Profile';

  @override
  String get checkSymptoms => 'Check Symptoms';

  @override
  String get upgradeToPlusTooltip => 'Upgrade to Plus';

  @override
  String get pawHealthPlus => 'PawHealth Plus';

  @override
  String get upgradeToPlus => 'Upgrade to Plus';

  @override
  String monthlyPrice(String price) {
    return '$price/month';
  }

  @override
  String get unlimitedSymptomChecks => 'Unlimited symptom checks';

  @override
  String get unlimitedPdfReports => 'Unlimited PDF vet reports';

  @override
  String get adFreeExperience => 'Ad-free experience';

  @override
  String get freeTierIncludes => 'Free tier includes';

  @override
  String get freeChecksPerMonth => '5 symptom checks / month';

  @override
  String get containsAds => 'Contains ads';

  @override
  String get subscribe => 'Subscribe';

  @override
  String get restorePurchases => 'Restore Purchases';

  @override
  String get upgrade => 'Upgrade';

  @override
  String get notNow => 'Not now';

  @override
  String get close => 'Close';

  @override
  String get account => 'ACCOUNT';

  @override
  String get email => 'Email';

  @override
  String get subscription => 'Subscription';

  @override
  String get freeTier => 'Free';

  @override
  String get logOut => 'Log Out';

  @override
  String get pdfPlusFeatureMessage =>
      'PDF vet reports are a PawHealth Plus feature. Upgrade to export and share unlimited reports.';

  @override
  String get symptomLimitMessage =>
      'You\'ve used your 5 free symptom checks this month. Upgrade for unlimited checks.';

  @override
  String get fetchingArticles => 'Fetching articles…';

  @override
  String get noArticlesAvailable => 'No articles available right now.';

  @override
  String get logIn => 'Log In';

  @override
  String get register => 'Register';

  @override
  String get password => 'Password';

  @override
  String get confirmPassword => 'Confirm Password';

  @override
  String get createAccount => 'Create Account';

  @override
  String get noAccountRegister => 'Don\'t have an account? Register';

  @override
  String get loggingIn => 'Logging in…';

  @override
  String get creatingAccount => 'Creating your account…';

  @override
  String get emailRequired => 'Email is required';

  @override
  String get emailInvalid => 'Enter a valid email address';

  @override
  String get passwordRequired => 'Password is required';

  @override
  String get passwordTooShort => 'Password must be at least 6 characters';

  @override
  String get passwordsDoNotMatch => 'Passwords do not match';

  @override
  String get errInvalidEmail => 'That email address looks invalid.';

  @override
  String get errIncorrectCredentials => 'Incorrect email or password.';

  @override
  String get errEmailInUse => 'An account already exists for that email.';

  @override
  String get errWeakPassword => 'Password must be at least 6 characters.';

  @override
  String get errPermissionDenied =>
      'Could not save your profile (permission denied). Check Firestore security rules.';

  @override
  String get errGeneric => 'Something went wrong. Please try again.';

  @override
  String get addPet => 'Add Pet';

  @override
  String get editPet => 'Edit Pet';

  @override
  String get petName => 'Name';

  @override
  String get nameRequired => 'Name is required';

  @override
  String get breed => 'Breed';

  @override
  String get speciesDog => 'Dog';

  @override
  String get speciesCat => 'Cat';

  @override
  String get selectBirthdate => 'Select birthdate';

  @override
  String get weightKg => 'Weight (kg)';

  @override
  String get enterValidWeight => 'Enter a valid weight';

  @override
  String get selectBreedError => 'Please select a breed';

  @override
  String get selectBirthdateError => 'Please select a birthdate';

  @override
  String get saveChanges => 'Save Changes';

  @override
  String get savingPet => 'Saving…';

  @override
  String get uploadingPhoto => 'Uploading photo…';

  @override
  String get errSaveTimeout =>
      'The network is too slow right now. Your photo may still finish uploading — try saving again in a moment.';

  @override
  String get errRulesPermission =>
      'Permission denied. Check that Firestore/Storage security rules are deployed.';

  @override
  String get errCouldNotSavePet => 'Could not save pet. Please try again.';

  @override
  String get errSubscriptionLoad => 'Could not load subscription status.';

  @override
  String get errPurchaseFailed => 'Purchase failed. Please try again.';

  @override
  String get errRestoreFailed => 'Restore failed. Please try again.';

  @override
  String get processingPurchase => 'Processing purchase…';

  @override
  String get restoringPurchases => 'Restoring purchases…';

  @override
  String symptomCheckerTitle(String petName) {
    return 'Symptom Checker · $petName';
  }

  @override
  String get noChecksForSpecies =>
      'No symptom checks are available for this species yet.';

  @override
  String get back => 'Back';

  @override
  String get saveShareWithVet => 'Save & Share with Vet';

  @override
  String get savedShareAgain => 'Saved — Share Again';

  @override
  String get savingCheck => 'Saving check…';

  @override
  String get triageMonitor => 'Monitor at Home';

  @override
  String get triageVet => 'See a Vet Soon';

  @override
  String get triageEmergency => 'Emergency — Act Now';

  @override
  String get medicalDisclaimer =>
      'This tool provides general guidance only and is not a substitute for professional veterinary diagnosis. When in doubt, contact your vet.';

  @override
  String get symptomVomiting => 'Vomiting';

  @override
  String shareSummaryTitle(String petName) {
    return 'PawHealth Symptom Check — $petName';
  }

  @override
  String shareSymptom(String symptom) {
    return 'Symptom: $symptom';
  }

  @override
  String shareTriageLevel(String level) {
    return 'Triage level: $level';
  }

  @override
  String shareAdvice(String advice) {
    return 'Advice: $advice';
  }

  @override
  String get shareAnswersHeader => 'Answers:';

  @override
  String get qVomitFrequency =>
      'How many times has your dog vomited in the last 24 hours?';

  @override
  String get qBloodInVomit =>
      'Is there any blood in the vomit (red streaks or coffee-ground appearance)?';

  @override
  String get qLethargyMild =>
      'Is your dog acting lethargic, weak, or unlike themselves?';

  @override
  String get qToxinIngestion =>
      'Could your dog have eaten something toxic, a foreign object, human medication, or spoiled food?';

  @override
  String get qBloatedAbdomen =>
      'Does your dog have a swollen or bloated abdomen, or are they retching without producing vomit?';

  @override
  String get qAgeVulnerable =>
      'Is your dog a puppy (under 6 months), a senior (over 8 years), or do they have a chronic health condition?';

  @override
  String get qLethargyModerate =>
      'Is your dog acting lethargic, weak, or refusing water?';

  @override
  String get opt1Time => '1 time';

  @override
  String get opt2to3Times => '2-3 times';

  @override
  String get opt4Plus => '4 or more times';

  @override
  String get optYes => 'Yes';

  @override
  String get optNo => 'No';

  @override
  String get advEmergencyFrequent =>
      'Vomiting 4+ times in 24 hours risks serious dehydration. Contact an emergency vet immediately.';

  @override
  String get advEmergencyBlood =>
      'Blood in vomit can indicate internal bleeding or a serious GI issue. Seek emergency veterinary care now.';

  @override
  String get advEmergencyToxin =>
      'Possible toxin or foreign object ingestion is an emergency. Contact an emergency vet or pet poison hotline immediately.';

  @override
  String get advEmergencyBloat =>
      'A bloated abdomen with retching can signal GDV (bloat), a life-threatening emergency. Go to an emergency vet immediately.';

  @override
  String get advVetLethargy =>
      'Lethargy alongside vomiting warrants a same-day vet visit. Withhold food, offer small sips of water.';

  @override
  String get advVetVulnerable =>
      'Puppies, seniors, and dogs with chronic conditions dehydrate quickly. Book a vet visit within 24 hours.';

  @override
  String get advVetModerate =>
      'Repeated vomiting without other red flags still warrants a vet check within 24 hours. Withhold food for 12 hours, offer small amounts of water.';

  @override
  String get advMonitorMild =>
      'A single vomiting episode with no other symptoms can often be monitored at home. Withhold food for a few hours, ensure fresh water, and watch for recurrence.';

  @override
  String get gender => 'Gender';

  @override
  String get genderMale => 'Male';

  @override
  String get genderFemale => 'Female';

  @override
  String get spayedNeutered => 'Spayed / Neutered';

  @override
  String get careParasiteControl => 'Parasite Control';

  @override
  String get careHeatCycle => 'Heat Cycle';

  @override
  String get careMedicalSurgery => 'Medical & Surgery';

  @override
  String get careGrooming => 'Grooming & Bathing';

  @override
  String get addEntry => 'Add Entry';

  @override
  String get careNote => 'Note';

  @override
  String get noteRequired => 'Please enter a note';

  @override
  String get noEntriesYet => 'No entries yet.';

  @override
  String get cancel => 'Cancel';

  @override
  String get save => 'Save';

  @override
  String get language => 'Language';

  @override
  String get chooseLanguage => 'Choose Language';

  @override
  String get careTitle => 'Title';

  @override
  String get careDetails => 'Details';

  @override
  String get titleRequired => 'Please enter a title';

  @override
  String get categoryLabel => 'Category';

  @override
  String healthDashboardTitle(String petName) {
    return '$petName · Health';
  }

  @override
  String get generateReport => 'Generate Report';

  @override
  String get addHealthRecord => 'Add New Health Record';

  @override
  String get filterAll => 'All';

  @override
  String get filterVaccination => 'Vaccination';

  @override
  String get filterMedical => 'Medical';

  @override
  String get filterGrooming => 'Grooming';

  @override
  String get filterOther => 'Other';

  @override
  String get timelineEmpty => 'No health records yet.';

  @override
  String get weight => 'Weight';

  @override
  String get logWeight => 'Log Weight';

  @override
  String get weightChartNeedTwo => 'Log at least two weigh-ins to see a trend.';

  @override
  String get addVaccine => 'Add Vaccine';

  @override
  String get vaccineName => 'Vaccine name';

  @override
  String administeredOn(String date) {
    return 'Administered: $date';
  }

  @override
  String nextDueOn(String date) {
    return 'Next due: $date';
  }

  @override
  String get selectNextDueDate => 'Select next due date';

  @override
  String get selectNextDueDateError => 'Select a next due date';

  @override
  String vaccinationDates(String given, String next) {
    return 'Given $given · Next due $next';
  }

  @override
  String get editHealthRecord => 'Edit Health Record';

  @override
  String get delete => 'Delete';

  @override
  String get deleteRecordTitle => 'Delete Record';

  @override
  String get deleteConfirmMessage =>
      'Are you sure you want to delete this record? This cannot be undone.';

  @override
  String get healthRecordButton => 'Health Record';

  @override
  String get editVaccination => 'Edit Vaccination';

  @override
  String get speciesRabbit => 'Rabbit';

  @override
  String get speciesBird => 'Bird';

  @override
  String get speciesExotic => 'Exotic / Other';

  @override
  String get speciesLabel => 'Species';

  @override
  String get breedOther => 'Other (Please specify)';

  @override
  String get enterBreed => 'Please enter the breed';

  @override
  String get microchipId => 'Microchip ID';

  @override
  String get allergies => 'Known Allergies (Food/Medication)';

  @override
  String ageYearsMonths(int years, int months) {
    return '$years yr $months mo';
  }

  @override
  String ageMonths(int months) {
    return '$months mo';
  }

  @override
  String get optNoSymptoms => 'No symptoms / General checkup';

  @override
  String get advHealthy =>
      'Your pet seems healthy! Keep up the good work — continue regular checkups and preventive care.';
}
