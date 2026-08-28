// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => 'PawHealth';

  @override
  String get myPets => '我的宠物';

  @override
  String get healthArticles => '健康文章';

  @override
  String get settings => '设置';

  @override
  String get articlesTab => '文章';

  @override
  String get noPetsYet => '还没有宠物，点按 + 添加';

  @override
  String get editProfile => '编辑资料';

  @override
  String get checkSymptoms => '症状检查';

  @override
  String get upgradeToPlusTooltip => '升级至 Plus';

  @override
  String get pawHealthPlus => 'PawHealth Plus';

  @override
  String get upgradeToPlus => '升级至 Plus';

  @override
  String monthlyPrice(String price) {
    return '$price/月';
  }

  @override
  String get unlimitedSymptomChecks => '无限次症状检查';

  @override
  String get unlimitedPdfReports => '无限份兽医 PDF 报告';

  @override
  String get adFreeExperience => '无广告体验';

  @override
  String get freeTierIncludes => '免费版包含';

  @override
  String get freeChecksPerMonth => '每月 5 次症状检查';

  @override
  String get containsAds => '含广告';

  @override
  String get subscribe => '订阅';

  @override
  String get restorePurchases => '恢复购买';

  @override
  String get upgrade => '升级';

  @override
  String get notNow => '暂不';

  @override
  String get close => '关闭';

  @override
  String get account => '账户';

  @override
  String get email => '邮箱';

  @override
  String get subscription => '订阅状态';

  @override
  String get freeTier => '免费版';

  @override
  String get logOut => '退出登录';

  @override
  String get pdfPlusFeatureMessage =>
      '兽医 PDF 报告是 PawHealth Plus 专属功能。升级即可无限导出和分享报告。';

  @override
  String get symptomLimitMessage => '本月的 5 次免费症状检查已用完。升级即可不限次数检查。';

  @override
  String get fetchingArticles => '正在加载文章…';

  @override
  String get noArticlesAvailable => '暂时没有可用的文章';

  @override
  String get logIn => '登录';

  @override
  String get register => '注册';

  @override
  String get password => '密码';

  @override
  String get confirmPassword => '确认密码';

  @override
  String get createAccount => '创建账户';

  @override
  String get noAccountRegister => '还没有账户？立即注册';

  @override
  String get loggingIn => '正在登录…';

  @override
  String get loginBrandTagline => '疫苗、体重和每一次兽医就诊，尽在一条时间线上。';

  @override
  String get creatingAccount => '正在创建账户…';

  @override
  String get emailRequired => '请输入邮箱';

  @override
  String get emailInvalid => '请输入有效的邮箱地址';

  @override
  String get passwordRequired => '请输入密码';

  @override
  String get passwordTooShort => '密码至少需要 6 个字符';

  @override
  String get passwordsDoNotMatch => '两次输入的密码不一致';

  @override
  String get errInvalidEmail => '邮箱格式不正确';

  @override
  String get errIncorrectCredentials => '邮箱或密码错误';

  @override
  String get errEmailInUse => '该邮箱已注册';

  @override
  String get errWeakPassword => '密码至少需要 6 个字符';

  @override
  String get errPermissionDenied => '无法保存个人资料（权限不足），请检查 Firestore 安全规则';

  @override
  String get errGeneric => '出错了，请重试';

  @override
  String get addPet => '添加宠物';

  @override
  String get editPet => '编辑宠物资料';

  @override
  String get petName => '名字';

  @override
  String get nameRequired => '请输入名字';

  @override
  String get breed => '品种';

  @override
  String get speciesDog => '狗';

  @override
  String get speciesCat => '猫';

  @override
  String get selectBirthdate => '选择出生日期';

  @override
  String get weightKg => '体重（公斤）';

  @override
  String get enterValidWeight => '请输入有效的体重';

  @override
  String get selectBreedError => '请选择品种';

  @override
  String get selectBirthdateError => '请选择出生日期';

  @override
  String get saveChanges => '保存修改';

  @override
  String get savingPet => '正在保存…';

  @override
  String get uploadingPhoto => '正在上传照片…';

  @override
  String get errSaveTimeout => '当前网络较慢，照片可能仍在上传中，请稍后再试一次';

  @override
  String get errRulesPermission => '权限不足，请确认已部署 Firestore/Storage 安全规则';

  @override
  String get errCouldNotSavePet => '无法保存宠物信息，请重试';

  @override
  String get errSubscriptionLoad => '无法加载订阅状态';

  @override
  String get errPurchaseFailed => '购买失败，请重试';

  @override
  String get errRestoreFailed => '恢复失败，请重试';

  @override
  String get processingPurchase => '正在处理购买…';

  @override
  String get restoringPurchases => '正在恢复购买…';

  @override
  String symptomCheckerTitle(String petName) {
    return '症状检查 · $petName';
  }

  @override
  String get noChecksForSpecies => '该物种暂无可用的症状检查';

  @override
  String get back => '返回';

  @override
  String get saveShareWithVet => '保存并分享给兽医';

  @override
  String get savedShareAgain => '已保存 — 再次分享';

  @override
  String get savingCheck => '正在保存检查结果…';

  @override
  String get triageMonitor => '在家观察';

  @override
  String get triageVet => '尽快就医';

  @override
  String get triageEmergency => '紧急 — 立即处理';

  @override
  String get medicalDisclaimer => '本工具仅提供一般性指导，不能替代专业兽医诊断。如有疑问，请咨询兽医。';

  @override
  String get symptomVomiting => '呕吐';

  @override
  String shareSummaryTitle(String petName) {
    return 'PawHealth 症状检查 — $petName';
  }

  @override
  String shareSymptom(String symptom) {
    return '症状：$symptom';
  }

  @override
  String shareTriageLevel(String level) {
    return '分诊级别：$level';
  }

  @override
  String shareAdvice(String advice) {
    return '建议：$advice';
  }

  @override
  String get shareAnswersHeader => '问答记录：';

  @override
  String get qVomitFrequency => '过去 24 小时内，您的狗呕吐了几次？';

  @override
  String get qBloodInVomit => '呕吐物中是否带血（红色血丝或咖啡渣样）？';

  @override
  String get qLethargyMild => '您的狗是否精神萎靡、乏力或状态反常？';

  @override
  String get qToxinIngestion => '您的狗是否可能误食了有毒物质、异物、人用药物或变质食物？';

  @override
  String get qBloatedAbdomen => '您的狗是否腹部肿胀鼓起，或干呕却吐不出东西？';

  @override
  String get qAgeVulnerable => '您的狗是幼犬（6 个月以下）、老年犬（8 岁以上），或患有慢性疾病吗？';

  @override
  String get qLethargyModerate => '您的狗是否精神萎靡、乏力或拒绝饮水？';

  @override
  String get opt1Time => '1 次';

  @override
  String get opt2to3Times => '2-3 次';

  @override
  String get opt4Plus => '4 次及以上';

  @override
  String get optYes => '是';

  @override
  String get optNo => '否';

  @override
  String get advEmergencyFrequent => '24 小时内呕吐 4 次及以上有严重脱水风险，请立即联系急诊兽医。';

  @override
  String get advEmergencyBlood => '呕吐物带血可能提示内出血或严重的胃肠道疾病，请立即寻求急诊兽医救治。';

  @override
  String get advEmergencyToxin => '疑似误食毒物或异物属于紧急情况，请立即联系急诊兽医或宠物中毒热线。';

  @override
  String get advEmergencyBloat => '腹部肿胀伴干呕可能是胃扭转（GDV）的征兆，危及生命，请立即前往急诊动物医院。';

  @override
  String get advVetLethargy => '呕吐伴精神萎靡应当天就医。暂停喂食，可少量多次喂水。';

  @override
  String get advVetVulnerable => '幼犬、老年犬及患慢性病的狗脱水很快，请在 24 小时内就医。';

  @override
  String get advVetModerate => '即使没有其他危险信号，反复呕吐也应在 24 小时内就医。禁食 12 小时，少量多次喂水。';

  @override
  String get advMonitorMild => '单次呕吐且无其他症状通常可在家观察。禁食几小时，备好清水，并留意是否再次呕吐。';

  @override
  String get gender => '性别';

  @override
  String get genderMale => '公';

  @override
  String get genderFemale => '母';

  @override
  String get spayedNeutered => '已绝育';

  @override
  String get careParasiteControl => '驱虫防护';

  @override
  String get careHeatCycle => '发情周期';

  @override
  String get careMedicalSurgery => '医疗与手术';

  @override
  String get careGrooming => '美容与洗澡';

  @override
  String get addEntry => '添加记录';

  @override
  String get careNote => '备注';

  @override
  String get noteRequired => '请输入备注';

  @override
  String get noEntriesYet => '暂无记录';

  @override
  String get cancel => '取消';

  @override
  String get save => '保存';

  @override
  String get language => '语言';

  @override
  String get chooseLanguage => '选择语言';

  @override
  String get careTitle => '标题';

  @override
  String get careDetails => '详情';

  @override
  String get titleRequired => '请输入标题';

  @override
  String get categoryLabel => '类别';

  @override
  String healthDashboardTitle(String petName) {
    return '$petName · 健康';
  }

  @override
  String get generateReport => '生成报告';

  @override
  String get addHealthRecord => '添加健康记录';

  @override
  String get filterAll => '全部';

  @override
  String get filterVaccination => '疫苗';

  @override
  String get filterMedical => '医疗';

  @override
  String get filterGrooming => '美容';

  @override
  String get filterOther => '其他';

  @override
  String get timelineEmpty => '暂无健康记录';

  @override
  String get weight => '体重';

  @override
  String get logWeight => '记录体重';

  @override
  String get weightChartNeedTwo => '至少记录两次体重后可查看趋势';

  @override
  String get addVaccine => '添加疫苗';

  @override
  String get vaccineName => '疫苗名称';

  @override
  String administeredOn(String date) {
    return '接种于：$date';
  }

  @override
  String nextDueOn(String date) {
    return '下次应接种：$date';
  }

  @override
  String get selectNextDueDate => '选择下次接种日期';

  @override
  String get selectNextDueDateError => '请选择下次接种日期';

  @override
  String vaccinationDates(String given, String next) {
    return '接种于 $given · 下次 $next';
  }

  @override
  String get editHealthRecord => '编辑健康记录';

  @override
  String get delete => '删除';

  @override
  String get deleteRecordTitle => '删除记录';

  @override
  String get deleteConfirmMessage => '确定要删除这条记录吗？删除后无法恢复。';

  @override
  String get healthRecordButton => '健康记录';

  @override
  String get editVaccination => '编辑疫苗';

  @override
  String get speciesRabbit => '兔子';

  @override
  String get speciesBird => '鸟';

  @override
  String get speciesExotic => '异宠／其他';

  @override
  String get speciesLabel => '物种';

  @override
  String get breedOther => '其他（请注明）';

  @override
  String get enterBreed => '请输入品种';

  @override
  String get microchipId => '芯片编号';

  @override
  String get allergies => '已知过敏（食物／药物）';

  @override
  String ageYearsMonths(int years, int months) {
    return '$years 岁 $months 个月';
  }

  @override
  String ageMonths(int months) {
    return '$months 个月';
  }

  @override
  String get optNoSymptoms => '无症状／常规体检';

  @override
  String get advHealthy => '您的宠物看起来很健康！继续保持，定期体检并做好预防护理。';
}
