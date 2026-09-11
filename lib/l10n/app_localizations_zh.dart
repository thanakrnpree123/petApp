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
  String get deletePet => '删除宠物';

  @override
  String deletePetTitle(String petName) {
    return '删除$petName？';
  }

  @override
  String deletePetConfirmMessage(String petName) {
    return '此操作会永久删除$petName的资料，以及其所有健康记录、疫苗记录和护理记录，且无法撤销。';
  }

  @override
  String petDeleted(String petName) {
    return '已删除$petName。';
  }

  @override
  String deletePetFailed(String petName) {
    return '无法删除$petName，请重试。';
  }

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

  @override
  String get shareWithVet => '分享给兽医';

  @override
  String checkSavedToHistory(String petName) {
    return '已保存到$petName的健康记录';
  }

  @override
  String get checkSaveFailed => '无法保存本次检查，请点击分享重试。';

  @override
  String symptomPickerTitle(String petName) {
    return '$petName怎么了？';
  }

  @override
  String get symptomPickerHint => '请选择主要症状，我们会问几个简单的问题。';

  @override
  String get emergencyNotice => '如果宠物虚脱倒地、没有呼吸或正在抽搐，请立即前往急诊动物医院——不要等待。';

  @override
  String get symptomDiarrhea => '腹泻';

  @override
  String get symptomNotEating => '不吃东西或没精神';

  @override
  String get symptomUrinary => '排尿问题';

  @override
  String get symptomToxin => '误食有害物';

  @override
  String get symptomBreathing => '呼吸问题';

  @override
  String get symptomLimping => '跛行或受伤';

  @override
  String get qDdSystemic => '狗狗是否同时反复呕吐、非常虚弱或虚脱倒地？';

  @override
  String get qDdBlood => '粪便中是否带有大量血液（鲜红色、果冻状），或呈黑色柏油样？';

  @override
  String get qDdToxin => '狗狗是否可能吃了有毒的东西（如药物、巧克力、木糖醇或葡萄）或异物？';

  @override
  String get qDdVulnerable => '狗狗是否为幼犬（6 个月以下）、老年犬（8 岁以上）、未接种疫苗，或患有慢性疾病？';

  @override
  String get qDiarrheaDuration => '腹泻持续多久了？';

  @override
  String get qCollapse => '宠物是否虚脱倒地，或牙龈苍白、发白、发灰或发紫？';

  @override
  String get qDnFluids => '狗狗是否同时拒绝喝水或呕吐？';

  @override
  String get qDnDuration => '狗狗不吃东西多久了？';

  @override
  String get qCatVomitFrequency => '过去 24 小时内猫咪呕吐了几次？';

  @override
  String get qCatForeign => '猫咪是否可能吞下了绳子、线、丝带、发圈，或百合花的任何部分？';

  @override
  String get qCatLethargy => '猫咪是否不再进食，或躲起来、活动量明显比平时少？';

  @override
  String get qUrinaryStraining => '猫咪是否在猫砂盆里用力排尿，但尿量很少或完全尿不出来？';

  @override
  String get qCnDuration => '猫咪不吃东西多久了？';

  @override
  String get qCnSigns => '猫咪是否同时呕吐、躲起来，或活动量明显比平时少？';

  @override
  String get qCuBlood => '尿液中是否带血，或猫咪在猫砂盆里痛叫、频繁舔舐生殖器？';

  @override
  String get qCuFrequency => '猫咪是否比平时更频繁地排尿，或在猫砂盆外排尿？';

  @override
  String get qCuThirst => '猫咪是否同时比平时喝更多的水？';

  @override
  String get qTxSigns => '宠物是否出现抽搐、颤抖、虚脱倒地或呼吸困难？';

  @override
  String get qTxWhat => '宠物可能吃了或接触了什么？';

  @override
  String get qTxObject => '宠物是否反复呕吐、吃了东西就吐，或腹部似乎疼痛？';

  @override
  String get qTxEvidence => '您是否在附近发现被咬过的包装、散落的药片、被啃过的植物或打开的容器？';

  @override
  String get qBrHeat => '宠物是否曾待在高温车内、在烈日下或在炎热天气中运动，并且正在剧烈喘气或流口水？';

  @override
  String get qBrEffort => '宠物在休息时是否呼吸困难——呼吸急促、明显费力，或（猫咪）张口呼吸？';

  @override
  String get qBrCough => '宠物是否咳嗽、打喷嚏或流鼻涕？';

  @override
  String get qBrUnwell => '宠物是否同时食欲下降或精神不振，或症状已持续超过 3 天？';

  @override
  String get qLmTrauma => '宠物是否被车撞或严重摔伤，或有明显骨折、深部伤口或大量出血？';

  @override
  String get qLmParalysis => '宠物是否突然无法使用后腿、拖着后腿行走，或疼得叫出声？';

  @override
  String get qLmWeight => '宠物的这条腿能承受一点重量吗？';

  @override
  String get qLmDuration => '跛行是否已持续超过 2 天，或腿部肿胀、摸起来发热？';

  @override
  String get optLess24h => '不到 24 小时';

  @override
  String get optMore24h => '超过 24 小时';

  @override
  String get optHumanMedication => '人用药物';

  @override
  String get optToxicFoods => '巧克力、木糖醇、葡萄、葡萄干、洋葱或大蒜';

  @override
  String get optToxicPlant => '百合或其他有毒植物';

  @override
  String get optChemicals => '老鼠药、防冻液或家用化学品';

  @override
  String get optObject => '玩具、袜子、骨头或其他物品';

  @override
  String get optNotSure => '不确定';

  @override
  String get optLimpingYes => '能，但走路一瘸一拐';

  @override
  String get optLimpingNo => '不能，一直抬着这条腿';

  @override
  String get advDdSystemic => '腹泻伴反复呕吐、虚弱或虚脱，可能迅速导致危险的脱水，或提示严重疾病。请立即前往急诊动物医院。';

  @override
  String get advDdBlood => '大量便血或黑色柏油样便可能意味着肠胃严重出血。请立即寻求急诊兽医救治。';

  @override
  String get advDdVulnerable =>
      '幼犬、老年犬、未接种疫苗的狗以及患有疾病的狗脱水很快，而且幼犬有感染细小病毒的风险。请今天就带狗狗去看兽医。';

  @override
  String get advDdDuration => '腹泻超过一天应在 24 小时内就医。确保随时有干净的饮用水，如有可能请带上新鲜的粪便样本。';

  @override
  String get advDdMonitor =>
      '如果狗狗精神良好、食欲正常，轻度腹泻通常可以在家观察。确保随时有干净的饮用水，少量多次喂食清淡食物；如腹泻超过 24 小时或出现新症状，请就医。';

  @override
  String get advEmergencyCollapse =>
      '虚脱倒地或牙龈苍白、发白、发灰或发紫，可能提示休克、失血或呼吸问题。请立即前往急诊动物医院。';

  @override
  String get advDnVetToday => '不吃东西同时拒绝喝水或呕吐，可能很快导致脱水。请今天就带狗狗去看兽医。';

  @override
  String get advDnDuration => '狗狗超过一天不吃东西，即使没有其他症状，也应在 24 小时内就医。';

  @override
  String get advDnMonitor =>
      '精神良好、活泼好动的狗狗偶尔少吃一顿，通常是因为天气炎热、压力或日常作息改变。提供干净的水和平时的食物；如 24 小时后仍不进食或出现新症状，请就医。';

  @override
  String get advCvForeign =>
      '吞下的绳子可能严重损伤猫咪的肠道，而百合的每个部分对猫都有剧毒。请立即前往急诊动物医院——切勿拉扯看得到的绳子。';

  @override
  String get advCvLethargy => '呕吐伴食欲不振、躲藏或精神不振，需要今天就医——停止进食的猫咪可能出现严重的肝脏问题。';

  @override
  String get advCvRepeat =>
      '反复呕吐应在 24 小时内就医。确保随时有干净的饮用水，禁食不要超过几个小时——猫咪不宜长时间不进食。';

  @override
  String get advCvMonitor =>
      '猫咪只吐了一次（通常是毛球），且仍正常进食、行为正常，一般可以在家观察。如再次呕吐或出现其他症状，请就医。';

  @override
  String get advEmergencyUrinary =>
      '用力排尿却几乎尿不出来，可能意味着尿路梗阻——这是危及生命的急症，公猫尤其常见。请立即前往急诊动物医院。';

  @override
  String get advCnFasting => '猫咪超过一天不进食，有患脂肪肝（肝脂质沉积症）的风险，可能危及生命。请今天就带猫咪去看兽医。';

  @override
  String get advCnSigns => '不进食同时伴有呕吐、躲藏或精神不振，应今天就医。';

  @override
  String get advCnMonitor =>
      '猫咪少吃了一顿但其他方面表现正常，可以在家密切观察。提供新鲜的食物和水；如 24 小时内仍未进食，请联系兽医。';

  @override
  String get advCuPain =>
      '尿中带血、疼痛或频繁舔舐，可能提示膀胱炎或尿路感染。请今天就带猫咪去看兽医——如果开始用力排尿却尿不出来，应按急症处理。';

  @override
  String get advCuThirst => '喝水和排尿比平时多，可能是肾病、糖尿病或甲状腺问题的征兆。请在未来几天内预约兽医。';

  @override
  String get advCuBehavior =>
      '排尿更频繁或在猫砂盆外排尿，可能由尿路问题或压力引起。请在几天内预约兽医，并保持猫砂盆清洁、方便猫咪使用。';

  @override
  String get advCuMonitor =>
      '目前没有紧急的泌尿系统警示信号。请持续观察猫砂盆的使用情况——用力排尿却尿量很少或尿不出来，始终属于急症。';

  @override
  String get advTxSigns => '这些症状需要立即急诊。请前往最近的急诊动物医院，如能安全取得，请带上包装或所吃东西的样本。';

  @override
  String get advTxKnown =>
      '其中许多东西即使少量也有毒，且症状可能数小时后才出现。请立即联系急诊兽医或动物中毒求助热线——不要等出现症状，也不要自行催吐，除非兽医指示。';

  @override
  String get advTxObstruction => '这些可能是肠胃梗阻的征兆。请立即前往急诊动物医院。';

  @override
  String get advTxObject => '吞下的异物可能在数小时甚至数天后引起梗阻。请今天致电兽医咨询，并留意是否出现呕吐、不进食或腹痛。';

  @override
  String get advTxUnsure =>
      '如果怀疑中毒但不确定，请立即致电兽医或动物中毒求助热线——确认一下总是更安全。留意是否出现呕吐、流口水、颤抖或异常行为。';

  @override
  String get advBrHeat => '这可能是中暑，可能致命。请把宠物移到凉爽的地方，用凉水（不要用冰水）打湿毛发，并立即前往急诊动物医院。';

  @override
  String get advBrBreathing =>
      '休息时呼吸困难属于急症。让宠物保持安静、凉爽，并立即前往急诊动物医院。猫咪正常情况下绝不应张口呼吸。';

  @override
  String get advBrVet => '咳嗽或打喷嚏伴精神不振或食欲下降，或已持续数天，应在 1–2 天内就医。';

  @override
  String get advBrMonitorCough =>
      '宠物食欲和精神正常，只是轻微咳嗽或打喷嚏，通常可以在家观察。让它多休息，远离烟雾和灰尘；如症状加重或持续超过 3 天，请就医。';

  @override
  String get advBrMonitor =>
      '目前没有紧急的呼吸警示信号。休息时的呼吸应安静、轻松——如果宠物在休息时开始呼吸急促或费力，应按急症处理。';

  @override
  String get advLmTrauma =>
      '严重受伤即使宠物看起来没事也需要急诊——内伤并不总是看得见。尽量让宠物保持不动，并立即前往急诊动物医院。';

  @override
  String get advLmParalysis => '后腿突然无力或瘫痪，可能由脊椎损伤引起，猫咪还可能是血栓所致。这是急症——请立即就医。';

  @override
  String get advLmNonWeight =>
      '这条腿完全不承重，需要在 24 小时内就医——可能是骨折、韧带撕裂或疼痛性感染。在此之前请让宠物静养。';

  @override
  String get advLmPersistent => '跛行持续超过两三天，或腿部肿胀、发热，应在 1–2 天内就医。';

  @override
  String get advLmMonitor =>
      '轻微跛行通常是轻度拉伤。让宠物休息 24–48 小时，检查脚掌是否有刺或伤口；如未好转，请就医。切勿给宠物服用人用止痛药——很多对宠物有毒。';

  @override
  String get deleteAccount => '删除账户';

  @override
  String get deleteAccountTitle => '确定删除账户吗？';

  @override
  String get deleteAccountMessage =>
      '此操作将永久删除您的账户及其中的所有内容——包括所有宠物、健康记录、疫苗、症状检查和照片。此操作无法撤销。';

  @override
  String get deleteAccountSubscriptionNote =>
      '删除账户不会取消通过 App Store 或 Google Play 购买的订阅。请在商店设置中取消订阅以停止扣费。';

  @override
  String get confirmPasswordToDelete => '请输入密码以确认';

  @override
  String get deleteAccountConfirm => '永久删除';

  @override
  String get accountDeleted => '您的账户已删除。';

  @override
  String get errIncorrectPassword => '密码错误。';

  @override
  String get deleteAccountFailed => '未能完成账户删除。请检查网络连接后重试——您的账户仍然有效，可以继续完成删除。';

  @override
  String get forgotPassword => '忘记密码？';

  @override
  String get resetPasswordTitle => '重置密码';

  @override
  String get resetPasswordMessage => '请输入您的账户邮箱，我们会发送一个用于设置新密码的链接。';

  @override
  String get sendResetLink => '发送重置链接';

  @override
  String resetLinkSent(String email) {
    return '如果存在使用 $email 的账户，重置链接已发出。请查看收件箱和垃圾邮件文件夹。';
  }

  @override
  String get reminderPromptTitle => '开启疫苗提醒？';

  @override
  String reminderPromptMessage(String petName) {
    return '我们会在$petName的疫苗到期前一天提醒您。您可以随时在手机设置中更改。';
  }

  @override
  String get turnOnReminders => '开启';

  @override
  String get paywallMobileOnly =>
      'PawHealth Plus 可在 iPhone 和 Android 版 PawHealth 应用中订阅。目前暂不支持在网页上购买订阅。';

  @override
  String get paywallUnavailable => '目前暂时无法订阅，请稍后再试。';

  @override
  String get tryAgain => '重试';

  @override
  String get weightOutOfRange => '请输入 0.1 到 150 公斤之间的体重。';
}
