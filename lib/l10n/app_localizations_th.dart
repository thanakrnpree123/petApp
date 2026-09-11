// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Thai (`th`).
class AppLocalizationsTh extends AppLocalizations {
  AppLocalizationsTh([String locale = 'th']) : super(locale);

  @override
  String get appTitle => 'PawHealth';

  @override
  String get myPets => 'สัตว์เลี้ยงของฉัน';

  @override
  String get healthArticles => 'บทความสุขภาพ';

  @override
  String get settings => 'การตั้งค่า';

  @override
  String get articlesTab => 'บทความ';

  @override
  String get noPetsYet => 'ยังไม่มีสัตว์เลี้ยง แตะ + เพื่อเพิ่ม';

  @override
  String get editProfile => 'แก้ไขโปรไฟล์';

  @override
  String get checkSymptoms => 'ตรวจอาการ';

  @override
  String get upgradeToPlusTooltip => 'อัปเกรดเป็น Plus';

  @override
  String get pawHealthPlus => 'PawHealth Plus';

  @override
  String get upgradeToPlus => 'อัปเกรดเป็น Plus';

  @override
  String monthlyPrice(String price) {
    return '$price/เดือน';
  }

  @override
  String get unlimitedSymptomChecks => 'ตรวจอาการได้ไม่จำกัด';

  @override
  String get unlimitedPdfReports => 'รายงาน PDF สำหรับสัตวแพทย์ไม่จำกัด';

  @override
  String get adFreeExperience => 'ไม่มีโฆษณา';

  @override
  String get freeTierIncludes => 'แพ็กเกจฟรีประกอบด้วย';

  @override
  String get freeChecksPerMonth => 'ตรวจอาการ 5 ครั้ง/เดือน';

  @override
  String get containsAds => 'มีโฆษณา';

  @override
  String get subscribe => 'สมัครสมาชิก';

  @override
  String get restorePurchases => 'กู้คืนการซื้อ';

  @override
  String get upgrade => 'อัปเกรด';

  @override
  String get notNow => 'ไว้ทีหลัง';

  @override
  String get close => 'ปิด';

  @override
  String get account => 'บัญชี';

  @override
  String get email => 'อีเมล';

  @override
  String get subscription => 'แพ็กเกจสมาชิก';

  @override
  String get freeTier => 'ฟรี';

  @override
  String get logOut => 'ออกจากระบบ';

  @override
  String get pdfPlusFeatureMessage =>
      'รายงาน PDF สำหรับสัตวแพทย์เป็นฟีเจอร์ของ PawHealth Plus อัปเกรดเพื่อส่งออกและแชร์รายงานได้ไม่จำกัด';

  @override
  String get symptomLimitMessage =>
      'คุณใช้สิทธิ์ตรวจอาการฟรี 5 ครั้งของเดือนนี้ครบแล้ว อัปเกรดเพื่อตรวจอาการได้ไม่จำกัด';

  @override
  String get fetchingArticles => 'กำลังโหลดบทความ…';

  @override
  String get noArticlesAvailable => 'ยังไม่มีบทความในขณะนี้';

  @override
  String get logIn => 'เข้าสู่ระบบ';

  @override
  String get register => 'ลงทะเบียน';

  @override
  String get password => 'รหัสผ่าน';

  @override
  String get confirmPassword => 'ยืนยันรหัสผ่าน';

  @override
  String get createAccount => 'สร้างบัญชี';

  @override
  String get noAccountRegister => 'ยังไม่มีบัญชี? ลงทะเบียนเลย';

  @override
  String get loggingIn => 'กำลังเข้าสู่ระบบ…';

  @override
  String get loginBrandTagline =>
      'วัคซีน น้ำหนัก และการพบสัตวแพทย์ทุกครั้ง อยู่ในไทม์ไลน์เดียว';

  @override
  String get creatingAccount => 'กำลังสร้างบัญชี…';

  @override
  String get emailRequired => 'กรุณากรอกอีเมล';

  @override
  String get emailInvalid => 'กรุณากรอกอีเมลให้ถูกต้อง';

  @override
  String get passwordRequired => 'กรุณากรอกรหัสผ่าน';

  @override
  String get passwordTooShort => 'รหัสผ่านต้องมีอย่างน้อย 6 ตัวอักษร';

  @override
  String get passwordsDoNotMatch => 'รหัสผ่านไม่ตรงกัน';

  @override
  String get errInvalidEmail => 'รูปแบบอีเมลไม่ถูกต้อง';

  @override
  String get errIncorrectCredentials => 'อีเมลหรือรหัสผ่านไม่ถูกต้อง';

  @override
  String get errEmailInUse => 'อีเมลนี้มีบัญชีอยู่แล้ว';

  @override
  String get errWeakPassword => 'รหัสผ่านต้องมีอย่างน้อย 6 ตัวอักษร';

  @override
  String get errPermissionDenied =>
      'ไม่สามารถบันทึกโปรไฟล์ได้ (ไม่มีสิทธิ์เข้าถึง) กรุณาตรวจสอบ Firestore security rules';

  @override
  String get errGeneric => 'เกิดข้อผิดพลาด กรุณาลองอีกครั้ง';

  @override
  String get addPet => 'เพิ่มสัตว์เลี้ยง';

  @override
  String get editPet => 'แก้ไขข้อมูลสัตว์เลี้ยง';

  @override
  String get deletePet => 'ลบสัตว์เลี้ยง';

  @override
  String deletePetTitle(String petName) {
    return 'ลบ $petName ใช่ไหม?';
  }

  @override
  String deletePetConfirmMessage(String petName) {
    return 'การดำเนินการนี้จะลบข้อมูลโปรไฟล์ของ $petName รวมถึงประวัติสุขภาพ วัคซีน และบันทึกการดูแลทั้งหมดอย่างถาวร ไม่สามารถย้อนกลับได้';
  }

  @override
  String petDeleted(String petName) {
    return 'ลบ $petName แล้ว';
  }

  @override
  String deletePetFailed(String petName) {
    return 'ไม่สามารถลบ $petName ได้ กรุณาลองใหม่อีกครั้ง';
  }

  @override
  String get petName => 'ชื่อ';

  @override
  String get nameRequired => 'กรุณากรอกชื่อ';

  @override
  String get breed => 'สายพันธุ์';

  @override
  String get speciesDog => 'สุนัข';

  @override
  String get speciesCat => 'แมว';

  @override
  String get selectBirthdate => 'เลือกวันเกิด';

  @override
  String get weightKg => 'น้ำหนัก (กก.)';

  @override
  String get enterValidWeight => 'กรุณากรอกน้ำหนักให้ถูกต้อง';

  @override
  String get selectBreedError => 'กรุณาเลือกสายพันธุ์';

  @override
  String get selectBirthdateError => 'กรุณาเลือกวันเกิด';

  @override
  String get saveChanges => 'บันทึกการแก้ไข';

  @override
  String get savingPet => 'กำลังบันทึก…';

  @override
  String get uploadingPhoto => 'กำลังอัปโหลดรูปภาพ…';

  @override
  String get errSaveTimeout =>
      'เครือข่ายช้ามากในขณะนี้ รูปภาพอาจกำลังอัปโหลดอยู่ ลองบันทึกอีกครั้งในอีกสักครู่';

  @override
  String get errRulesPermission =>
      'ไม่มีสิทธิ์เข้าถึง กรุณาตรวจสอบว่าได้ deploy security rules ของ Firestore/Storage แล้ว';

  @override
  String get errCouldNotSavePet =>
      'ไม่สามารถบันทึกข้อมูลสัตว์เลี้ยงได้ กรุณาลองอีกครั้ง';

  @override
  String get errSubscriptionLoad => 'ไม่สามารถโหลดสถานะสมาชิกได้';

  @override
  String get errPurchaseFailed => 'การซื้อไม่สำเร็จ กรุณาลองอีกครั้ง';

  @override
  String get errRestoreFailed => 'การกู้คืนไม่สำเร็จ กรุณาลองอีกครั้ง';

  @override
  String get processingPurchase => 'กำลังดำเนินการซื้อ…';

  @override
  String get restoringPurchases => 'กำลังกู้คืนการซื้อ…';

  @override
  String symptomCheckerTitle(String petName) {
    return 'ตรวจอาการ · $petName';
  }

  @override
  String get noChecksForSpecies => 'ยังไม่มีแบบตรวจอาการสำหรับสัตว์ชนิดนี้';

  @override
  String get back => 'ย้อนกลับ';

  @override
  String get triageMonitor => 'เฝ้าดูอาการที่บ้าน';

  @override
  String get triageVet => 'ควรพาไปพบสัตวแพทย์เร็ว ๆ นี้';

  @override
  String get triageEmergency => 'ฉุกเฉิน — รีบดำเนินการทันที';

  @override
  String get medicalDisclaimer =>
      'เครื่องมือนี้ให้คำแนะนำเบื้องต้นเท่านั้น ไม่สามารถใช้แทนการวินิจฉัยของสัตวแพทย์ได้ หากไม่แน่ใจกรุณาปรึกษาสัตวแพทย์';

  @override
  String get symptomVomiting => 'อาเจียน';

  @override
  String shareSummaryTitle(String petName) {
    return 'ผลตรวจอาการ PawHealth — $petName';
  }

  @override
  String shareSymptom(String symptom) {
    return 'อาการ: $symptom';
  }

  @override
  String shareTriageLevel(String level) {
    return 'ระดับความเร่งด่วน: $level';
  }

  @override
  String shareAdvice(String advice) {
    return 'คำแนะนำ: $advice';
  }

  @override
  String get shareAnswersHeader => 'คำตอบ:';

  @override
  String get qVomitFrequency =>
      'ใน 24 ชั่วโมงที่ผ่านมา สุนัขของคุณอาเจียนกี่ครั้ง?';

  @override
  String get qBloodInVomit =>
      'มีเลือดปนในอาเจียนหรือไม่ (เป็นเส้นเลือดสีแดงหรือลักษณะคล้ายกากกาแฟ)?';

  @override
  String get qLethargyMild =>
      'สุนัขของคุณมีอาการซึม อ่อนแรง หรือไม่ร่าเริงเหมือนปกติหรือไม่?';

  @override
  String get qToxinIngestion =>
      'สุนัขของคุณอาจกินสารพิษ สิ่งแปลกปลอม ยาของคน หรืออาหารบูดเสียหรือไม่?';

  @override
  String get qBloatedAbdomen =>
      'สุนัขของคุณมีท้องบวมป่อง หรือพยายามอาเจียนแต่ไม่มีอะไรออกมาหรือไม่?';

  @override
  String get qAgeVulnerable =>
      'สุนัขของคุณเป็นลูกสุนัข (อายุต่ำกว่า 6 เดือน) สุนัขสูงวัย (มากกว่า 8 ปี) หรือมีโรคประจำตัวหรือไม่?';

  @override
  String get qLethargyModerate =>
      'สุนัขของคุณมีอาการซึม อ่อนแรง หรือไม่ยอมกินน้ำหรือไม่?';

  @override
  String get opt1Time => '1 ครั้ง';

  @override
  String get opt2to3Times => '2-3 ครั้ง';

  @override
  String get opt4Plus => '4 ครั้งขึ้นไป';

  @override
  String get optYes => 'ใช่';

  @override
  String get optNo => 'ไม่ใช่';

  @override
  String get advEmergencyFrequent =>
      'การอาเจียน 4 ครั้งขึ้นไปใน 24 ชั่วโมงเสี่ยงต่อภาวะขาดน้ำรุนแรง กรุณาติดต่อโรงพยาบาลสัตว์ฉุกเฉินทันที';

  @override
  String get advEmergencyBlood =>
      'เลือดปนในอาเจียนอาจบ่งบอกถึงภาวะเลือดออกภายในหรือปัญหาทางเดินอาหารร้ายแรง กรุณาพาไปพบสัตวแพทย์ฉุกเฉินทันที';

  @override
  String get advEmergencyToxin =>
      'การกินสารพิษหรือสิ่งแปลกปลอมเป็นภาวะฉุกเฉิน กรุณาติดต่อโรงพยาบาลสัตว์ฉุกเฉินทันที';

  @override
  String get advEmergencyBloat =>
      'ท้องบวมป่องร่วมกับการพยายามอาเจียนอาจเป็นสัญญาณของภาวะกระเพาะบิด (GDV) ซึ่งอันตรายถึงชีวิต กรุณาพาไปโรงพยาบาลสัตว์ฉุกเฉินทันที';

  @override
  String get advVetLethargy =>
      'อาการซึมร่วมกับอาเจียนควรพาไปพบสัตวแพทย์ภายในวันนี้ งดอาหารและให้จิบน้ำทีละน้อย';

  @override
  String get advVetVulnerable =>
      'ลูกสุนัข สุนัขสูงวัย และสุนัขที่มีโรคประจำตัวจะเกิดภาวะขาดน้ำได้เร็ว ควรพาไปพบสัตวแพทย์ภายใน 24 ชั่วโมง';

  @override
  String get advVetModerate =>
      'การอาเจียนซ้ำ ๆ แม้ไม่มีสัญญาณอันตรายอื่นก็ควรพบสัตวแพทย์ภายใน 24 ชั่วโมง งดอาหาร 12 ชั่วโมงและให้น้ำทีละน้อย';

  @override
  String get advMonitorMild =>
      'การอาเจียนเพียงครั้งเดียวโดยไม่มีอาการอื่นมักเฝ้าดูอาการที่บ้านได้ งดอาหารสักสองสามชั่วโมง เตรียมน้ำสะอาดไว้ให้ และสังเกตว่ามีอาเจียนซ้ำหรือไม่';

  @override
  String get gender => 'เพศ';

  @override
  String get genderMale => 'ตัวผู้';

  @override
  String get genderFemale => 'ตัวเมีย';

  @override
  String get spayedNeutered => 'ทำหมันแล้ว';

  @override
  String get careParasiteControl => 'การป้องกันปรสิต';

  @override
  String get careHeatCycle => 'วงรอบการเป็นสัด';

  @override
  String get careMedicalSurgery => 'การรักษาและการผ่าตัด';

  @override
  String get careGrooming => 'การอาบน้ำตัดขน';

  @override
  String get addEntry => 'เพิ่มบันทึก';

  @override
  String get careNote => 'บันทึก';

  @override
  String get noteRequired => 'กรุณากรอกบันทึก';

  @override
  String get noEntriesYet => 'ยังไม่มีบันทึก';

  @override
  String get cancel => 'ยกเลิก';

  @override
  String get save => 'บันทึก';

  @override
  String get language => 'ภาษา';

  @override
  String get chooseLanguage => 'เลือกภาษา';

  @override
  String get careTitle => 'หัวข้อ';

  @override
  String get careDetails => 'รายละเอียด';

  @override
  String get titleRequired => 'กรุณากรอกหัวข้อ';

  @override
  String get categoryLabel => 'หมวดหมู่';

  @override
  String healthDashboardTitle(String petName) {
    return '$petName · สุขภาพ';
  }

  @override
  String get generateReport => 'สร้างรายงาน';

  @override
  String get addHealthRecord => 'เพิ่มบันทึกสุขภาพ';

  @override
  String get filterAll => 'ทั้งหมด';

  @override
  String get filterVaccination => 'วัคซีน';

  @override
  String get filterMedical => 'การรักษา';

  @override
  String get filterGrooming => 'อาบน้ำตัดขน';

  @override
  String get filterOther => 'อื่น ๆ';

  @override
  String get timelineEmpty => 'ยังไม่มีบันทึกสุขภาพ';

  @override
  String get weight => 'น้ำหนัก';

  @override
  String get logWeight => 'บันทึกน้ำหนัก';

  @override
  String get weightChartNeedTwo =>
      'บันทึกน้ำหนักอย่างน้อย 2 ครั้งเพื่อดูแนวโน้ม';

  @override
  String get addVaccine => 'เพิ่มวัคซีน';

  @override
  String get vaccineName => 'ชื่อวัคซีน';

  @override
  String administeredOn(String date) {
    return 'ฉีดเมื่อ: $date';
  }

  @override
  String nextDueOn(String date) {
    return 'ครั้งถัดไป: $date';
  }

  @override
  String get selectNextDueDate => 'เลือกวันครบกำหนดครั้งถัดไป';

  @override
  String get selectNextDueDateError => 'กรุณาเลือกวันครบกำหนดครั้งถัดไป';

  @override
  String vaccinationDates(String given, String next) {
    return 'ฉีดเมื่อ $given · ครั้งถัดไป $next';
  }

  @override
  String get editHealthRecord => 'แก้ไขบันทึกสุขภาพ';

  @override
  String get delete => 'ลบ';

  @override
  String get deleteRecordTitle => 'ลบบันทึก';

  @override
  String get deleteConfirmMessage =>
      'คุณแน่ใจหรือไม่ว่าต้องการลบบันทึกนี้? การลบไม่สามารถย้อนกลับได้';

  @override
  String get healthRecordButton => 'บันทึกสุขภาพ';

  @override
  String get editVaccination => 'แก้ไขวัคซีน';

  @override
  String get speciesRabbit => 'กระต่าย';

  @override
  String get speciesBird => 'นก';

  @override
  String get speciesExotic => 'สัตว์เอ็กโซติก / อื่น ๆ';

  @override
  String get speciesLabel => 'ชนิดสัตว์เลี้ยง';

  @override
  String get breedOther => 'อื่น ๆ (โปรดระบุ)';

  @override
  String get enterBreed => 'กรุณากรอกสายพันธุ์';

  @override
  String get microchipId => 'หมายเลขไมโครชิป';

  @override
  String get allergies => 'อาการแพ้ที่ทราบ (อาหาร/ยา)';

  @override
  String ageYearsMonths(int years, int months) {
    return '$years ปี $months เดือน';
  }

  @override
  String ageMonths(int months) {
    return '$months เดือน';
  }

  @override
  String get optNoSymptoms => 'ไม่มีอาการ / ตรวจสุขภาพทั่วไป';

  @override
  String get advHealthy =>
      'สัตว์เลี้ยงของคุณดูแข็งแรงดี! ดูแลแบบนี้ต่อไป และพาไปตรวจสุขภาพกับสัตวแพทย์เป็นประจำ';

  @override
  String get shareWithVet => 'แชร์ให้สัตวแพทย์';

  @override
  String checkSavedToHistory(String petName) {
    return 'บันทึกลงประวัติสุขภาพของ $petName แล้ว';
  }

  @override
  String get checkSaveFailed => 'บันทึกผลตรวจไม่สำเร็จ แตะแชร์เพื่อลองอีกครั้ง';

  @override
  String symptomPickerTitle(String petName) {
    return '$petName มีอาการอะไร?';
  }

  @override
  String get symptomPickerHint =>
      'เลือกอาการหลัก แล้วเราจะถามคำถามสั้น ๆ อีกเล็กน้อย';

  @override
  String get emergencyNotice =>
      'หากสัตว์เลี้ยงล้มทรุด ไม่หายใจ หรือกำลังชัก กรุณาพาไปโรงพยาบาลสัตว์ฉุกเฉินทันที อย่ารอ';

  @override
  String get symptomDiarrhea => 'ท้องเสีย';

  @override
  String get symptomNotEating => 'ไม่กินอาหารหรือซึม';

  @override
  String get symptomUrinary => 'ปัญหาการปัสสาวะ';

  @override
  String get symptomToxin => 'กินสิ่งที่เป็นอันตราย';

  @override
  String get symptomBreathing => 'ปัญหาการหายใจ';

  @override
  String get symptomLimping => 'ขาเจ็บหรือบาดเจ็บ';

  @override
  String get qDdSystemic =>
      'สุนัขอาเจียนซ้ำหลายครั้ง อ่อนแรงมาก หรือล้มทรุดร่วมด้วยหรือไม่?';

  @override
  String get qDdBlood =>
      'มีเลือดปนในอุจจาระจำนวนมาก (สีแดงคล้ายวุ้น) หรืออุจจาระเป็นสีดำเหนียวคล้ายยางมะตอยหรือไม่?';

  @override
  String get qDdToxin =>
      'สุนัขอาจกินสิ่งที่เป็นพิษ (เช่น ยา ช็อกโกแลต ไซลิทอล หรือองุ่น) หรือสิ่งแปลกปลอมเข้าไปหรือไม่?';

  @override
  String get qDdVulnerable =>
      'สุนัขเป็นลูกสุนัข (อายุต่ำกว่า 6 เดือน) สุนัขสูงวัย (อายุเกิน 8 ปี) ยังไม่ได้รับวัคซีน หรือมีโรคประจำตัวหรือไม่?';

  @override
  String get qDiarrheaDuration => 'ท้องเสียมานานเท่าไหร่แล้ว?';

  @override
  String get qCollapse =>
      'สัตว์เลี้ยงล้มทรุด หรือเหงือกซีด ขาว เทา หรือเขียวคล้ำหรือไม่?';

  @override
  String get qDnFluids => 'สุนัขไม่ยอมดื่มน้ำ หรืออาเจียนร่วมด้วยหรือไม่?';

  @override
  String get qDnDuration => 'สุนัขไม่ยอมกินอาหารมานานเท่าไหร่แล้ว?';

  @override
  String get qCatVomitFrequency => 'ใน 24 ชั่วโมงที่ผ่านมา แมวอาเจียนกี่ครั้ง?';

  @override
  String get qCatForeign =>
      'แมวอาจกลืนเชือก ด้าย ริบบิ้น ยางรัดผม หรือส่วนใดส่วนหนึ่งของต้นลิลลี่เข้าไปหรือไม่?';

  @override
  String get qCatLethargy =>
      'แมวหยุดกินอาหาร ซ่อนตัว หรือเคลื่อนไหวน้อยกว่าปกติมากหรือไม่?';

  @override
  String get qUrinaryStraining =>
      'แมวเบ่งในกระบะทรายแต่ปัสสาวะออกน้อยมากหรือไม่ออกเลยหรือไม่?';

  @override
  String get qCnDuration => 'แมวไม่กินอาหารมานานเท่าไหร่แล้ว?';

  @override
  String get qCnSigns =>
      'แมวอาเจียน ซ่อนตัว หรือเคลื่อนไหวน้อยกว่าปกติมากร่วมด้วยหรือไม่?';

  @override
  String get qCuBlood =>
      'มีเลือดปนในปัสสาวะ แมวร้องขณะอยู่ในกระบะทราย หรือเลียอวัยวะเพศบ่อยหรือไม่?';

  @override
  String get qCuFrequency =>
      'แมวปัสสาวะบ่อยกว่าปกติ หรือปัสสาวะนอกกระบะทรายหรือไม่?';

  @override
  String get qCuThirst => 'แมวดื่มน้ำมากกว่าปกติมากร่วมด้วยหรือไม่?';

  @override
  String get qTxSigns =>
      'สัตว์เลี้ยงมีอาการชัก สั่น ล้มทรุด หรือหายใจลำบากหรือไม่?';

  @override
  String get qTxWhat => 'สัตว์เลี้ยงอาจกินหรือสัมผัสอะไรเข้าไป?';

  @override
  String get qTxObject =>
      'สัตว์เลี้ยงอาเจียนซ้ำหลายครั้ง กินอาหารแล้วอาเจียนออกมา หรือดูเหมือนเจ็บท้องหรือไม่?';

  @override
  String get qTxEvidence =>
      'คุณพบบรรจุภัณฑ์ที่ถูกกัด ยาที่หกกระจาย ต้นไม้ที่ถูกกัดแทะ หรือภาชนะที่เปิดอยู่ใกล้ ๆ หรือไม่?';

  @override
  String get qBrHeat =>
      'สัตว์เลี้ยงเพิ่งอยู่ในรถที่ร้อน ตากแดด หรือออกกำลังกายในอากาศร้อน และหอบหนักหรือน้ำลายไหลมากหรือไม่?';

  @override
  String get qBrEffort =>
      'สัตว์เลี้ยงหายใจลำบากขณะพัก เช่น หายใจเร็ว หายใจแรงจนเห็นได้ชัด หรือ (สำหรับแมว) อ้าปากหายใจหรือไม่?';

  @override
  String get qBrCough => 'สัตว์เลี้ยงไอ จาม หรือมีน้ำมูกหรือไม่?';

  @override
  String get qBrUnwell =>
      'สัตว์เลี้ยงกินน้อยลงหรือดูไม่มีแรงร่วมด้วย หรือเป็นมานานเกิน 3 วันหรือไม่?';

  @override
  String get qLmTrauma =>
      'สัตว์เลี้ยงถูกรถชนหรือตกจากที่สูง หรือมีกระดูกหักอย่างเห็นได้ชัด แผลลึก หรือเลือดออกมากหรือไม่?';

  @override
  String get qLmParalysis =>
      'สัตว์เลี้ยงใช้ขาหลังไม่ได้อย่างกะทันหัน ลากขา หรือร้องเพราะเจ็บปวดหรือไม่?';

  @override
  String get qLmWeight =>
      'สัตว์เลี้ยงสามารถลงน้ำหนักที่ขาข้างนั้นได้บ้างหรือไม่?';

  @override
  String get qLmDuration =>
      'ขาเจ็บมานานเกิน 2 วัน หรือขาบวมหรือจับแล้วรู้สึกร้อนหรือไม่?';

  @override
  String get optLess24h => 'น้อยกว่า 24 ชั่วโมง';

  @override
  String get optMore24h => 'มากกว่า 24 ชั่วโมง';

  @override
  String get optHumanMedication => 'ยาของคน';

  @override
  String get optToxicFoods =>
      'ช็อกโกแลต ไซลิทอล องุ่น ลูกเกด หัวหอม หรือกระเทียม';

  @override
  String get optToxicPlant => 'ลิลลี่หรือพืชมีพิษชนิดอื่น';

  @override
  String get optChemicals => 'ยาเบื่อหนู น้ำยาหล่อเย็นรถยนต์ หรือสารเคมีในบ้าน';

  @override
  String get optObject => 'ของเล่น ถุงเท้า กระดูก หรือสิ่งของอื่น ๆ';

  @override
  String get optNotSure => 'ไม่แน่ใจ';

  @override
  String get optLimpingYes => 'ได้ แต่เดินกะเผลก';

  @override
  String get optLimpingNo => 'ไม่ได้ ยกขาข้างนั้นไว้ตลอด';

  @override
  String get advDdSystemic =>
      'ท้องเสียร่วมกับอาเจียนซ้ำ อ่อนแรง หรือล้มทรุด อาจทำให้ขาดน้ำอย่างรุนแรงอย่างรวดเร็ว หรือเป็นสัญญาณของโรคร้ายแรง กรุณาพาไปโรงพยาบาลสัตว์ฉุกเฉินทันที';

  @override
  String get advDdBlood =>
      'เลือดปนในอุจจาระจำนวนมาก หรืออุจจาระสีดำเหนียว อาจหมายถึงมีเลือดออกในทางเดินอาหารอย่างรุนแรง กรุณาพาไปพบสัตวแพทย์ฉุกเฉินทันที';

  @override
  String get advDdVulnerable =>
      'ลูกสุนัข สุนัขสูงวัย สุนัขที่ยังไม่ได้รับวัคซีน และสุนัขที่มีโรคประจำตัวจะขาดน้ำได้เร็ว และลูกสุนัขเสี่ยงต่อโรคลำไส้อักเสบจากเชื้อพาร์โวไวรัส ควรพาไปพบสัตวแพทย์ภายในวันนี้';

  @override
  String get advDdDuration =>
      'ท้องเสียนานเกิน 1 วันควรได้รับการตรวจจากสัตวแพทย์ภายใน 24 ชั่วโมง เตรียมน้ำสะอาดให้ดื่มตลอดเวลา และหากเป็นไปได้ให้นำตัวอย่างอุจจาระใหม่ ๆ ไปด้วย';

  @override
  String get advDdMonitor =>
      'ท้องเสียเล็กน้อยในสุนัขที่ยังร่าเริงและกินอาหารได้ตามปกติ มักเฝ้าดูอาการที่บ้านได้ เตรียมน้ำสะอาดให้ดื่มตลอดเวลา ให้อาหารอ่อน ๆ ครั้งละน้อย และพาไปพบสัตวแพทย์หากเป็นนานเกิน 24 ชั่วโมงหรือมีอาการอื่นเพิ่มขึ้น';

  @override
  String get advEmergencyCollapse =>
      'การล้มทรุด หรือเหงือกซีด ขาว เทา หรือเขียวคล้ำ อาจเป็นสัญญาณของภาวะช็อก การเสียเลือด หรือปัญหาการหายใจ กรุณาพาไปโรงพยาบาลสัตว์ฉุกเฉินทันที';

  @override
  String get advDnVetToday =>
      'การไม่กินอาหารร่วมกับไม่ดื่มน้ำหรืออาเจียน อาจทำให้ขาดน้ำได้อย่างรวดเร็ว ควรพาสุนัขไปพบสัตวแพทย์ภายในวันนี้';

  @override
  String get advDnDuration =>
      'สุนัขที่ไม่กินอาหารนานเกิน 1 วัน ควรพาไปพบสัตวแพทย์ภายใน 24 ชั่วโมง แม้จะไม่มีอาการอื่นก็ตาม';

  @override
  String get advDnMonitor =>
      'สุนัขที่ยังร่าเริงและกระฉับกระเฉงแต่ไม่กินอาหารไปหนึ่งมื้อ มักเกิดจากอากาศร้อน ความเครียด หรือกิจวัตรที่เปลี่ยนไป ให้น้ำสะอาดและอาหารที่กินเป็นประจำ และพาไปพบสัตวแพทย์หากยังไม่กินอาหารหลัง 24 ชั่วโมงหรือมีอาการอื่นเพิ่มขึ้น';

  @override
  String get advCvForeign =>
      'เชือกที่แมวกลืนเข้าไปอาจทำให้ลำไส้เสียหายรุนแรง และทุกส่วนของต้นลิลลี่มีพิษร้ายแรงต่อแมว กรุณาพาไปโรงพยาบาลสัตว์ฉุกเฉินทันที และห้ามดึงเชือกที่มองเห็นออกมาเองเด็ดขาด';

  @override
  String get advCvLethargy =>
      'การอาเจียนร่วมกับเบื่ออาหาร ซ่อนตัว หรือไม่มีแรง ควรพาไปพบสัตวแพทย์ภายในวันนี้ เพราะแมวที่หยุดกินอาหารอาจเกิดปัญหาตับที่ร้ายแรงได้';

  @override
  String get advCvRepeat =>
      'การอาเจียนซ้ำควรได้รับการตรวจจากสัตวแพทย์ภายใน 24 ชั่วโมง เตรียมน้ำสะอาดให้ดื่มตลอดเวลา และไม่ควรงดอาหารนานเกินไม่กี่ชั่วโมง เพราะแมวไม่ควรอดอาหารเป็นเวลานาน';

  @override
  String get advCvMonitor =>
      'การอาเจียนครั้งเดียว (มักเป็นก้อนขน) ในแมวที่ยังกินอาหารและมีพฤติกรรมปกติ มักเฝ้าดูอาการที่บ้านได้ พาไปพบสัตวแพทย์หากอาเจียนอีกหรือมีอาการอื่นร่วมด้วย';

  @override
  String get advEmergencyUrinary =>
      'การเบ่งปัสสาวะแต่ออกน้อยมากหรือไม่ออกเลย อาจหมายถึงท่อปัสสาวะอุดตัน ซึ่งเป็นภาวะฉุกเฉินที่อันตรายถึงชีวิต โดยเฉพาะในแมวเพศผู้ กรุณาพาไปโรงพยาบาลสัตว์ฉุกเฉินทันที';

  @override
  String get advCnFasting =>
      'แมวที่ไม่กินอาหารนานเกิน 1 วันเสี่ยงต่อภาวะไขมันพอกตับ (hepatic lipidosis) ซึ่งอาจอันตรายถึงชีวิต ควรพาแมวไปพบสัตวแพทย์ภายในวันนี้';

  @override
  String get advCnSigns =>
      'การไม่กินอาหารร่วมกับอาเจียน ซ่อนตัว หรือไม่มีแรง ควรพาไปพบสัตวแพทย์ภายในวันนี้';

  @override
  String get advCnMonitor =>
      'แมวที่ไม่กินอาหารไปหนึ่งมื้อแต่ยังมีพฤติกรรมปกติ สามารถเฝ้าดูอาการอย่างใกล้ชิดที่บ้านได้ ให้อาหารและน้ำสะอาด และติดต่อสัตวแพทย์หากยังไม่กินอาหารภายใน 24 ชั่วโมง';

  @override
  String get advCuPain =>
      'เลือดปนในปัสสาวะ อาการเจ็บ หรือการเลียบ่อย อาจบ่งบอกถึงกระเพาะปัสสาวะอักเสบหรือการติดเชื้อทางเดินปัสสาวะ ควรพาแมวไปพบสัตวแพทย์ภายในวันนี้ และหากแมวเริ่มเบ่งแต่ไม่มีปัสสาวะออก ให้ถือเป็นเหตุฉุกเฉิน';

  @override
  String get advCuThirst =>
      'การดื่มน้ำและปัสสาวะมากกว่าปกติ อาจเป็นสัญญาณของโรคไต เบาหวาน หรือปัญหาต่อมไทรอยด์ ควรนัดพบสัตวแพทย์ภายในไม่กี่วันนี้';

  @override
  String get advCuBehavior =>
      'การปัสสาวะบ่อยขึ้นหรือปัสสาวะนอกกระบะทราย อาจเกิดจากปัญหาทางเดินปัสสาวะหรือความเครียด ควรนัดพบสัตวแพทย์ภายในไม่กี่วัน และดูแลกระบะทรายให้สะอาดและเข้าถึงได้ง่าย';

  @override
  String get advCuMonitor =>
      'ตอนนี้ยังไม่พบสัญญาณอันตรายเร่งด่วนเกี่ยวกับการปัสสาวะ คอยสังเกตการใช้กระบะทรายต่อไป การเบ่งแต่ปัสสาวะออกน้อยหรือไม่ออกเลยถือเป็นเหตุฉุกเฉินเสมอ';

  @override
  String get advTxSigns =>
      'อาการเหล่านี้ต้องได้รับการรักษาฉุกเฉินทันที กรุณาพาไปโรงพยาบาลสัตว์ฉุกเฉินที่ใกล้ที่สุด และนำบรรจุภัณฑ์หรือตัวอย่างสิ่งที่กินเข้าไปติดไปด้วยหากทำได้อย่างปลอดภัย';

  @override
  String get advTxKnown =>
      'สิ่งเหล่านี้หลายอย่างเป็นพิษแม้ในปริมาณเล็กน้อย และอาการอาจใช้เวลาหลายชั่วโมงกว่าจะปรากฏ กรุณาติดต่อโรงพยาบาลสัตว์ฉุกเฉินหรือศูนย์พิษวิทยาสำหรับสัตว์ทันที อย่ารอให้มีอาการ และอย่าทำให้สัตว์เลี้ยงอาเจียนเองเว้นแต่สัตวแพทย์แนะนำ';

  @override
  String get advTxObstruction =>
      'อาการเหล่านี้อาจเป็นสัญญาณของการอุดตันในทางเดินอาหาร กรุณาพาไปโรงพยาบาลสัตว์ฉุกเฉินทันที';

  @override
  String get advTxObject =>
      'สิ่งของที่กลืนเข้าไปอาจทำให้เกิดการอุดตันได้ในอีกหลายชั่วโมงหรือหลายวันต่อมา ควรโทรปรึกษาสัตวแพทย์ภายในวันนี้ และคอยสังเกตอาการอาเจียน ไม่กินอาหาร หรือเจ็บท้อง';

  @override
  String get advTxUnsure =>
      'หากสงสัยว่าได้รับสารพิษแต่ไม่แน่ใจ ให้โทรปรึกษาสัตวแพทย์หรือศูนย์พิษวิทยาสำหรับสัตว์ทันที การตรวจสอบไว้ก่อนปลอดภัยกว่าเสมอ คอยสังเกตอาการอาเจียน น้ำลายไหล ตัวสั่น หรือพฤติกรรมผิดปกติ';

  @override
  String get advBrHeat =>
      'อาจเป็นโรคลมแดด (ฮีทสโตรก) ซึ่งอันตรายถึงชีวิตได้ ย้ายสัตว์เลี้ยงไปอยู่ในที่เย็น ใช้น้ำเย็น (ไม่ใช่น้ำเย็นจัด) ราดให้ขนเปียก และพาไปโรงพยาบาลสัตว์ฉุกเฉินทันที';

  @override
  String get advBrBreathing =>
      'การหายใจลำบากขณะพักเป็นเหตุฉุกเฉิน ให้สัตว์เลี้ยงสงบและอยู่ในที่เย็น แล้วพาไปโรงพยาบาลสัตว์ฉุกเฉินทันที โดยปกติแมวไม่ควรอ้าปากหายใจเลย';

  @override
  String get advBrVet =>
      'อาการไอหรือจามร่วมกับไม่มีแรงหรือเบื่ออาหาร หรือเป็นมานานหลายวัน ควรได้รับการตรวจจากสัตวแพทย์ภายใน 1–2 วัน';

  @override
  String get advBrMonitorCough =>
      'อาการไอหรือจามเล็กน้อยในสัตว์เลี้ยงที่ยังกินอาหารและกระฉับกระเฉงตามปกติ มักเฝ้าดูอาการที่บ้านได้ ให้พักผ่อน หลีกเลี่ยงควันและฝุ่น และพาไปพบสัตวแพทย์หากอาการแย่ลงหรือเป็นนานเกิน 3 วัน';

  @override
  String get advBrMonitor =>
      'ตอนนี้ยังไม่พบสัญญาณอันตรายเร่งด่วนเกี่ยวกับการหายใจ การหายใจขณะพักควรเงียบและสบาย หากสัตว์เลี้ยงเริ่มหายใจเร็วหรือหายใจแรงขณะพัก ให้ถือเป็นเหตุฉุกเฉิน';

  @override
  String get advLmTrauma =>
      'การบาดเจ็บรุนแรงต้องได้รับการรักษาฉุกเฉิน แม้สัตว์เลี้ยงจะดูเหมือนไม่เป็นอะไร เพราะการบาดเจ็บภายในอาจมองไม่เห็น ให้สัตว์เลี้ยงอยู่นิ่งที่สุดและพาไปโรงพยาบาลสัตว์ฉุกเฉินทันที';

  @override
  String get advLmParalysis =>
      'ขาหลังอ่อนแรงหรือเป็นอัมพาตอย่างกะทันหัน อาจเกิดจากการบาดเจ็บที่กระดูกสันหลัง หรือในแมวอาจเกิดจากลิ่มเลือดอุดตัน นี่เป็นเหตุฉุกเฉิน กรุณาพาไปพบสัตวแพทย์ทันที';

  @override
  String get advLmNonWeight =>
      'การไม่ลงน้ำหนักที่ขาเลย ควรได้รับการตรวจจากสัตวแพทย์ภายใน 24 ชั่วโมง อาจเป็นกระดูกหัก เอ็นฉีกขาด หรือการติดเชื้อที่เจ็บปวด ระหว่างนี้ให้สัตว์เลี้ยงพักผ่อน';

  @override
  String get advLmPersistent =>
      'อาการขาเจ็บที่เป็นนานเกิน 2–3 วัน หรือขาบวมหรือร้อน ควรได้รับการตรวจจากสัตวแพทย์ภายใน 1–2 วัน';

  @override
  String get advLmMonitor =>
      'อาการขาเจ็บเล็กน้อยมักเกิดจากกล้ามเนื้อหรือเอ็นเคล็ดเล็กน้อย ให้สัตว์เลี้ยงพักผ่อน 24–48 ชั่วโมง ตรวจดูอุ้งเท้าว่ามีหนามหรือบาดแผลหรือไม่ และพาไปพบสัตวแพทย์หากอาการไม่ดีขึ้น ห้ามให้ยาแก้ปวดของคนเด็ดขาด เพราะหลายชนิดเป็นพิษต่อสัตว์เลี้ยง';

  @override
  String get deleteAccount => 'ลบบัญชี';

  @override
  String get deleteAccountTitle => 'ลบบัญชีของคุณใช่ไหม?';

  @override
  String get deleteAccountMessage =>
      'การดำเนินการนี้จะลบบัญชีและข้อมูลทั้งหมดอย่างถาวร ได้แก่ สัตว์เลี้ยง ประวัติสุขภาพ วัคซีน ผลตรวจอาการ และรูปภาพทั้งหมด ไม่สามารถย้อนกลับได้';

  @override
  String get deleteAccountSubscriptionNote =>
      'การลบบัญชีไม่ได้ยกเลิกการสมัครสมาชิกที่ซื้อผ่าน App Store หรือ Google Play กรุณายกเลิกในการตั้งค่าของสโตร์เพื่อหยุดการเรียกเก็บเงิน';

  @override
  String get confirmPasswordToDelete => 'กรอกรหัสผ่านเพื่อยืนยัน';

  @override
  String get deleteAccountConfirm => 'ลบอย่างถาวร';

  @override
  String get accountDeleted => 'ลบบัญชีของคุณแล้ว';

  @override
  String get errIncorrectPassword => 'รหัสผ่านไม่ถูกต้อง';

  @override
  String get deleteAccountFailed =>
      'ลบบัญชีไม่สำเร็จ กรุณาตรวจสอบการเชื่อมต่อแล้วลองอีกครั้ง บัญชีของคุณยังใช้งานได้ จึงสามารถลบต่อให้เสร็จได้';

  @override
  String get forgotPassword => 'ลืมรหัสผ่าน?';

  @override
  String get resetPasswordTitle => 'ตั้งรหัสผ่านใหม่';

  @override
  String get resetPasswordMessage =>
      'กรอกอีเมลของบัญชี แล้วเราจะส่งลิงก์สำหรับตั้งรหัสผ่านใหม่ให้คุณ';

  @override
  String get sendResetLink => 'ส่งลิงก์ตั้งรหัสผ่าน';

  @override
  String resetLinkSent(String email) {
    return 'หากมีบัญชีที่ใช้อีเมล $email เราได้ส่งลิงก์ตั้งรหัสผ่านใหม่ไปแล้ว กรุณาตรวจสอบกล่องจดหมายและโฟลเดอร์สแปม';
  }

  @override
  String get reminderPromptTitle => 'รับการแจ้งเตือนวัคซีนไหม?';

  @override
  String reminderPromptMessage(String petName) {
    return 'เราจะแจ้งเตือนคุณล่วงหน้า 1 วันก่อนถึงกำหนดฉีดวัคซีนของ $petName คุณเปลี่ยนการตั้งค่านี้ได้ทุกเมื่อในการตั้งค่าโทรศัพท์';
  }

  @override
  String get turnOnReminders => 'เปิดการแจ้งเตือน';

  @override
  String get paywallMobileOnly =>
      'PawHealth Plus สมัครได้ในแอป PawHealth บน iPhone และ Android ขณะนี้ยังไม่สามารถสมัครผ่านเว็บได้';

  @override
  String get paywallUnavailable =>
      'ขณะนี้ยังไม่สามารถสมัครสมาชิกได้ กรุณาลองใหม่ภายหลัง';

  @override
  String get tryAgain => 'ลองอีกครั้ง';

  @override
  String get weightOutOfRange => 'กรุณากรอกน้ำหนักระหว่าง 0.1 ถึง 150 กก.';
}
