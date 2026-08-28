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
  String get saveShareWithVet => 'บันทึกและแชร์ให้สัตวแพทย์';

  @override
  String get savedShareAgain => 'บันทึกแล้ว — แชร์อีกครั้ง';

  @override
  String get savingCheck => 'กำลังบันทึกผลตรวจ…';

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
}
