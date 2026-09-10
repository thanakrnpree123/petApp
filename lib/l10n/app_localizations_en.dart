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
  String get loginBrandTagline =>
      'Every vaccine, weigh-in, and vet visit — in one timeline.';

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
  String get deletePet => 'Delete Pet';

  @override
  String deletePetTitle(String petName) {
    return 'Delete $petName?';
  }

  @override
  String deletePetConfirmMessage(String petName) {
    return 'This permanently deletes $petName\'s profile and all of their health records, vaccinations, and care logs. This cannot be undone.';
  }

  @override
  String petDeleted(String petName) {
    return '$petName was deleted.';
  }

  @override
  String deletePetFailed(String petName) {
    return 'Couldn\'t delete $petName. Please try again.';
  }

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

  @override
  String get shareWithVet => 'Share with Vet';

  @override
  String checkSavedToHistory(String petName) {
    return 'Saved to $petName\'s health history';
  }

  @override
  String get checkSaveFailed =>
      'Couldn\'t save this check. Tap Share to try again.';

  @override
  String symptomPickerTitle(String petName) {
    return 'What\'s wrong with $petName?';
  }

  @override
  String get symptomPickerHint =>
      'Choose the main symptom. We\'ll ask a few quick questions.';

  @override
  String get emergencyNotice =>
      'If your pet has collapsed, isn\'t breathing, or is having a seizure, go to an emergency vet now — don\'t wait.';

  @override
  String get symptomDiarrhea => 'Diarrhea';

  @override
  String get symptomNotEating => 'Not eating or low energy';

  @override
  String get symptomUrinary => 'Peeing problems';

  @override
  String get symptomToxin => 'Ate something harmful';

  @override
  String get symptomBreathing => 'Breathing problems';

  @override
  String get symptomLimping => 'Limping or injury';

  @override
  String get qDdSystemic =>
      'Is your dog also vomiting repeatedly, very weak, or collapsing?';

  @override
  String get qDdBlood =>
      'Is there a lot of blood in the stool (red and jelly-like), or is it black and tarry?';

  @override
  String get qDdToxin =>
      'Could your dog have eaten something toxic (such as medication, chocolate, xylitol, or grapes) or a foreign object?';

  @override
  String get qDdVulnerable =>
      'Is your dog a puppy (under 6 months), a senior (over 8 years), unvaccinated, or living with a chronic health condition?';

  @override
  String get qDiarrheaDuration => 'How long has the diarrhea lasted?';

  @override
  String get qCollapse =>
      'Has your pet collapsed, or are their gums pale, white, grey, or blue?';

  @override
  String get qDnFluids => 'Is your dog also refusing water, or vomiting?';

  @override
  String get qDnDuration => 'How long has your dog been off their food?';

  @override
  String get qCatVomitFrequency =>
      'How many times has your cat vomited in the last 24 hours?';

  @override
  String get qCatForeign =>
      'Could your cat have swallowed string, thread, ribbon, a hair tie, or part of a lily plant?';

  @override
  String get qCatLethargy =>
      'Has your cat stopped eating, or are they hiding or much less active than usual?';

  @override
  String get qUrinaryStraining =>
      'Is your cat straining in the litter box but passing little or no urine?';

  @override
  String get qCnDuration => 'How long has your cat not been eating?';

  @override
  String get qCnSigns =>
      'Is your cat also vomiting, hiding, or much less active than usual?';

  @override
  String get qCuBlood =>
      'Is there blood in the urine, or is your cat crying out in the litter box or licking their genitals a lot?';

  @override
  String get qCuFrequency =>
      'Is your cat peeing more often than usual, or outside the litter box?';

  @override
  String get qCuThirst =>
      'Is your cat also drinking much more water than usual?';

  @override
  String get qTxSigns =>
      'Is your pet having seizures, trembling, collapsing, or struggling to breathe?';

  @override
  String get qTxWhat => 'What might your pet have eaten or been exposed to?';

  @override
  String get qTxObject =>
      'Is your pet vomiting repeatedly, unable to keep food down, or does their belly seem painful?';

  @override
  String get qTxEvidence =>
      'Did you find chewed packaging, spilled pills, a chewed plant, or an open container nearby?';

  @override
  String get qBrHeat =>
      'Has your pet been in a hot car, out in the sun, or exercising in hot weather — and are they panting heavily or drooling?';

  @override
  String get qBrEffort =>
      'Is your pet struggling to breathe while resting — breathing fast, with visible effort, or (for cats) with their mouth open?';

  @override
  String get qBrCough =>
      'Is your pet coughing, sneezing, or does it have a runny nose?';

  @override
  String get qBrUnwell =>
      'Is your pet also eating less or low on energy, or has this lasted more than 3 days?';

  @override
  String get qLmTrauma =>
      'Was your pet hit by a car or did it have a bad fall, or is there an obvious broken bone, deep wound, or heavy bleeding?';

  @override
  String get qLmParalysis =>
      'Is your pet suddenly unable to use their back legs, dragging them, or crying out in pain?';

  @override
  String get qLmWeight => 'Can your pet put any weight on the leg?';

  @override
  String get qLmDuration =>
      'Has the limp lasted more than 2 days, or is the leg swollen or hot to the touch?';

  @override
  String get optLess24h => 'Less than 24 hours';

  @override
  String get optMore24h => 'More than 24 hours';

  @override
  String get optHumanMedication => 'Human medication';

  @override
  String get optToxicFoods =>
      'Chocolate, xylitol, grapes, raisins, onions, or garlic';

  @override
  String get optToxicPlant => 'Lilies or another toxic plant';

  @override
  String get optChemicals => 'Rat poison, antifreeze, or household chemicals';

  @override
  String get optObject => 'A toy, sock, bone, or other object';

  @override
  String get optNotSure => 'Not sure';

  @override
  String get optLimpingYes => 'Yes, but they\'re limping';

  @override
  String get optLimpingNo => 'No, they hold the leg up';

  @override
  String get advDdSystemic =>
      'Diarrhea with repeated vomiting, weakness, or collapse can quickly cause dangerous dehydration or signal a serious illness. Go to an emergency vet now.';

  @override
  String get advDdBlood =>
      'Large amounts of blood, or black, tarry stool, can mean serious bleeding in the gut. Seek emergency veterinary care now.';

  @override
  String get advDdVulnerable =>
      'Puppies, seniors, unvaccinated dogs, and dogs with health conditions dehydrate quickly — and puppies are at risk of parvovirus. Have your dog seen by a vet today.';

  @override
  String get advDdDuration =>
      'Diarrhea lasting more than a day should be checked by a vet within 24 hours. Keep fresh water available, and bring a fresh stool sample if you can.';

  @override
  String get advDdMonitor =>
      'Mild diarrhea in a dog that is otherwise bright and eating can usually be watched at home. Keep fresh water available, feed small bland meals, and see a vet if it lasts more than 24 hours or new symptoms appear.';

  @override
  String get advEmergencyCollapse =>
      'Collapse or pale, white, grey, or blue gums can signal shock, blood loss, or a breathing problem. Go to an emergency vet immediately.';

  @override
  String get advDnVetToday =>
      'Not eating along with refusing water or vomiting can quickly lead to dehydration. Have your dog seen by a vet today.';

  @override
  String get advDnDuration =>
      'A dog that hasn\'t eaten for more than a day should be seen by a vet within 24 hours, even without other symptoms.';

  @override
  String get advDnMonitor =>
      'Skipping a meal in an otherwise bright, active dog is often caused by heat, stress, or a change in routine. Offer fresh water and their usual food, and see a vet if they still haven\'t eaten after 24 hours or new symptoms appear.';

  @override
  String get advCvForeign =>
      'Swallowed string can badly damage a cat\'s intestines, and every part of a lily is highly toxic to cats. Go to an emergency vet now — never pull on string you can see.';

  @override
  String get advCvLethargy =>
      'Vomiting with loss of appetite, hiding, or low energy needs a vet visit today — cats that stop eating can develop serious liver problems.';

  @override
  String get advCvRepeat =>
      'Repeated vomiting should be checked by a vet within 24 hours. Keep fresh water available, and don\'t withhold food for more than a few hours — cats shouldn\'t go long without eating.';

  @override
  String get advCvMonitor =>
      'A single vomit — often a hairball — in a cat that is still eating and acting normally can usually be watched at home. See a vet if it happens again or other symptoms appear.';

  @override
  String get advEmergencyUrinary =>
      'Straining to pee with little or nothing coming out can mean a urinary blockage — a life-threatening emergency, especially in male cats. Go to an emergency vet now.';

  @override
  String get advCnFasting =>
      'Cats that go without food for more than a day are at risk of fatty liver disease (hepatic lipidosis), which can be life-threatening. Have your cat seen by a vet today.';

  @override
  String get advCnSigns =>
      'Not eating along with vomiting, hiding, or low energy should be checked by a vet today.';

  @override
  String get advCnMonitor =>
      'A cat that has skipped a meal but is otherwise acting normally can be watched closely at home. Offer fresh food and water, and contact a vet if they haven\'t eaten within 24 hours.';

  @override
  String get advCuPain =>
      'Blood in the urine, pain, or frequent licking can point to cystitis or a urinary infection. Have your cat seen by a vet today — and if they start straining with no urine, treat it as an emergency.';

  @override
  String get advCuThirst =>
      'Drinking and peeing more than usual can be a sign of kidney disease, diabetes, or thyroid problems. Book a vet visit within the next few days.';

  @override
  String get advCuBehavior =>
      'Peeing more often or outside the box can be caused by a urinary problem or by stress. Book a vet visit within a few days, and keep the litter box clean and easy to reach.';

  @override
  String get advCuMonitor =>
      'No urgent urinary warning signs right now. Keep watching the litter box — straining with little or no urine is always an emergency.';

  @override
  String get advTxSigns =>
      'These signs need emergency care right now. Go to the nearest emergency vet, and bring the packaging or a sample of what was eaten if it\'s safe to do so.';

  @override
  String get advTxKnown =>
      'Many of these are poisonous even in small amounts, and symptoms can take hours to appear. Contact an emergency vet or animal poison hotline now — don\'t wait for symptoms, and don\'t make your pet vomit unless a vet tells you to.';

  @override
  String get advTxObstruction =>
      'These can be signs of a blockage in the gut. Go to an emergency vet now.';

  @override
  String get advTxObject =>
      'A swallowed object can cause a blockage hours or even days later. Call your vet today for advice, and watch for vomiting, not eating, or a painful belly.';

  @override
  String get advTxUnsure =>
      'If you suspect poisoning but aren\'t sure, call your vet or an animal poison hotline now — it\'s always safer to check. Watch for vomiting, drooling, trembling, or unusual behavior.';

  @override
  String get advBrHeat =>
      'This may be heatstroke, which can be fatal. Move your pet somewhere cool, wet their coat with cool (not ice-cold) water, and go to an emergency vet immediately.';

  @override
  String get advBrBreathing =>
      'Struggling to breathe at rest is an emergency. Keep your pet calm and cool, and go to an emergency vet now. Cats should never breathe with their mouth open.';

  @override
  String get advBrVet =>
      'Coughing or sneezing with low energy or a poor appetite, or that has lasted more than a few days, should be checked by a vet within 1–2 days.';

  @override
  String get advBrMonitorCough =>
      'A mild cough or sneeze in a pet that is eating and active can usually be watched at home. Keep them rested, away from smoke and dust, and see a vet if it gets worse or lasts more than 3 days.';

  @override
  String get advBrMonitor =>
      'No urgent breathing warning signs right now. Resting breathing should be quiet and easy — if your pet starts breathing fast or with effort while resting, treat it as an emergency.';

  @override
  String get advLmTrauma =>
      'Serious injuries need emergency care even if your pet seems okay — internal injuries aren\'t always visible. Keep your pet as still as possible and go to an emergency vet now.';

  @override
  String get advLmParalysis =>
      'Sudden weakness or paralysis in the back legs can be caused by a spinal injury or, in cats, a blood clot. This is an emergency — go to a vet now.';

  @override
  String get advLmNonWeight =>
      'Not putting any weight on a leg needs a vet check within 24 hours — it could be a fracture, torn ligament, or painful infection. Keep your pet rested until then.';

  @override
  String get advLmPersistent =>
      'A limp lasting more than a couple of days, or a swollen or hot leg, should be checked by a vet within 1–2 days.';

  @override
  String get advLmMonitor =>
      'A mild limp is often a minor strain. Rest your pet for 24–48 hours, check their paw for thorns or cuts, and see a vet if it doesn\'t improve. Never give human painkillers — many are toxic to pets.';

  @override
  String get deleteAccount => 'Delete Account';

  @override
  String get deleteAccountTitle => 'Delete your account?';

  @override
  String get deleteAccountMessage =>
      'This permanently deletes your account and everything in it — all pets, health records, vaccinations, symptom checks, and photos. This can\'t be undone.';

  @override
  String get deleteAccountSubscriptionNote =>
      'Deleting your account doesn\'t cancel a subscription bought through the App Store or Google Play. Cancel it in your store settings to stop being charged.';

  @override
  String get confirmPasswordToDelete => 'Enter your password to confirm';

  @override
  String get deleteAccountConfirm => 'Delete Permanently';

  @override
  String get accountDeleted => 'Your account has been deleted.';

  @override
  String get errIncorrectPassword => 'Incorrect password.';

  @override
  String get deleteAccountFailed =>
      'Couldn\'t finish deleting your account. Check your connection and try again — your account is still active, so you can finish deleting it.';
}
