// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'Taskly';

  @override
  String get client => 'عميل';

  @override
  String get freelancer => 'مستقل';

  @override
  String get welcomeMessage => 'رتب شغلك، تواصل،\n  وحقق النجاح!';

  @override
  String get freelancerTitle => 'أنا مستقل';

  @override
  String get freelancerSubtitle => 'ابحث عن مشاريع وطوّر مسيرتك';

  @override
  String get clientTitle => 'أنا عميل';

  @override
  String get clientSubtitle => 'وظّف المستقلين لإنجاز عملك';

  @override
  String get createFreelancerAccount => 'إنشاء حساب مستقل';

  @override
  String get createClientAccount => 'إنشاء حساب عميل';

  @override
  String get alreadyHaveAccount => 'لديك حساب بالفعل؟';

  @override
  String get login => 'تسجيل الدخول';

  @override
  String get registerFreelancerSubtitle => 'سجل للبحث عن عمل';

  @override
  String get registerClientSubtitle => 'سجل لتوظيف أفضل المواهب';

  @override
  String get firstName => 'الاسم الأول';

  @override
  String get lastName => 'اسم العائلة';

  @override
  String get email => 'البريد الإلكتروني';

  @override
  String get password => 'كلمة المرور';

  @override
  String get createAccount => 'إنشاء حسابي';

  @override
  String get thisFieldIsRequired => 'هذا الحقل مطلوب';

  @override
  String get welcomeBack => 'مرحباً بعودتك';

  @override
  String get dontHaveAccount => 'ليس لديك حساب؟';

  @override
  String get signUp => 'إنشاء حساب';

  @override
  String get continueWithGoogle => 'المتابعة باستخدام جوجل';

  @override
  String get privacyPolicyAgreement => 'بإنشائك حساباً فإنك توافق على ';

  @override
  String get privacyPolicy => 'سياسة الخصوصية';

  @override
  String get termsAgreement => ' و\nعلى ';

  @override
  String get termsOfUse => 'شروط الاستخدام';

  @override
  String get or => 'او';

  @override
  String get noInternetConnection => 'لا يوجد اتصال بالإنترنت';

  @override
  String get emailAlreadyExists => 'البريد الإلكتروني موجود بالفعل أو لم يتم التأكيد. يرجى التحقق من بريدك الإلكتروني.';

  @override
  String get somethingWentWrong => 'حدث خطأ ما، يرجى المحاولة مرة أخرى';

  @override
  String get loginFailed => 'فشل تسجيل الدخول. يرجى التحقق من البريد الإلكتروني وكلمة المرور.';

  @override
  String notRegisteredAsRole(Object role) {
    return 'أنت غير مسجل كـ $role. يرجى استخدام الحساب الصحيح.';
  }

  @override
  String get googleLoginCancelled => 'تم إلغاء تسجيل الدخول باستخدام جوجل';

  @override
  String accountAlreadyRegistered(Object existingRole, Object role) {
    return 'هذا الحساب مسجل بالفعل كـ $existingRole. لا يمكنك التسجيل كـ $role.';
  }

  @override
  String get userRegisteredSuccessfully => 'تم تسجيل المستخدم بنجاح';

  @override
  String get userLoginSuccessfully => 'تم تسجيل الدخول بنجاح';

  @override
  String get googleLoginSuccessful => 'تم تسجيل الدخول باستخدام جوجل بنجاح';

  @override
  String get dashboardDescription => 'إدارة كل المستقلين والعملاء في لوحة تحكم واحدة';

  @override
  String get performanceTracking => 'تتبع الطلبات، مراقبة الأداء، والحفاظ على كل شيء تحت السيطرة';

  @override
  String get skip => 'تخطي';

  @override
  String get letsGo => 'لنبدأ';

  @override
  String get dashboard => 'لوحة التحكم';

  @override
  String get users => 'المستخدمين';

  @override
  String get orders => 'الطلبات';

  @override
  String get messages => 'الرسائل';

  @override
  String get payments => 'المدفوعات';

  @override
  String hiUser(Object name) {
    return 'مرحبًا $name،';
  }

  @override
  String get welcomeTaskly => 'مرحبًا بك في Taskly';

  @override
  String get revenueTrend => 'اتجاه الإيرادات';

  @override
  String get totalRevenueInfo => 'نمو الإيرادات الإجمالي مع الوقت';

  @override
  String get orderVolume => 'حجم الطلبات';

  @override
  String get dailyOrderInfo => 'معدل إتمام الطلبات اليومي';

  @override
  String get categoryDistribution => 'توزيع الفئات';

  @override
  String get serviceCategoryInfo => 'فئات الخدمة حسب حصة الإيرادات';

  @override
  String errorPrefix(Object message) {
    return 'خطأ: $message';
  }

  @override
  String get dashboardOrders => 'الطلبات';

  @override
  String get dashboardEarnings => 'الإيرادات';

  @override
  String get dashboardClients => 'العملاء';

  @override
  String get dashboardFreelancers => 'المستقلين';

  @override
  String get pendingVerifications => 'التحققات المعلقة';

  @override
  String get disputesNeedingReview => 'النزاعات التي تحتاج مراجعة';

  @override
  String get pendingPayments => 'المدفوعات المعلقة';

  @override
  String get lateOrders => 'الطلبات المتأخرة';

  @override
  String get kpiTitle => 'المؤشرات الرئيسية للأداء';

  @override
  String get trendsTitle => 'الاتجاهات والرؤى البيانية';

  @override
  String get monthlyView => 'عرض شهري';

  @override
  String get pendingActionsTitle => 'الإجراءات والتنبيهات المعلقة';

  @override
  String get exportCSVTitle => 'تصدير CSV المالي';

  @override
  String get exportMoneyCSV => 'تصدير CSV للأموال';

  @override
  String get categoryAcademic => 'أكاديمي';

  @override
  String get categoryReports => 'تقارير';

  @override
  String get categoryMindMaps => 'خرائط ذهنية';

  @override
  String get categoryTranslation => 'ترجمة';

  @override
  String get categorySummaries => 'ملخصات';

  @override
  String get categoryProjects => 'مشاريع';

  @override
  String get categoryPresentations => 'عروض تقديمية';

  @override
  String get categorySPSS => 'SPSS';

  @override
  String get categoryProofreading => 'تدقيق لغوي';

  @override
  String get categoryCV => 'السيرة الذاتية';

  @override
  String get categoryProgramming => 'برمجة';

  @override
  String get categoryCourses => 'دورات';

  @override
  String get categoryConsulting => 'استشارات';

  @override
  String get categoryDesign => 'تصميم';

  @override
  String get categoryEngineering => 'هندسة';

  @override
  String get categoryFinance => 'تمويل';

  @override
  String get legendAcademic => 'مصادر أكاديمية';

  @override
  String get legendReports => 'تقارير علمية';

  @override
  String get legendMindMaps => 'خرائط ذهنية';

  @override
  String get legendTranslation => 'اللغات والترجمة';

  @override
  String get legendSummaries => 'ملخصات';

  @override
  String get legendProjects => 'مشاريع علمية';

  @override
  String get legendPresentations => 'عروض تقديمية';

  @override
  String get legendSPSS => 'تحليل SPSS';

  @override
  String get legendProofreading => 'تدقيق لغوي';

  @override
  String get legendCV => 'السيرة الذاتية';

  @override
  String get legendProgramming => 'برمجة وتصميم ويب';

  @override
  String get legendCourses => 'الدورات التعليمية';

  @override
  String get legendConsulting => 'استشارات متخصصة';

  @override
  String get legendDesign => 'تصميم جرافيك';

  @override
  String get legendEngineering => 'خدمات هندسية';

  @override
  String get legendFinance => 'المالية والمحاسبة';

  @override
  String get manageDashboard => 'ادارة اللوحة القيادية';

  @override
  String get manageUsers => 'إدارة المستخدمين';

  @override
  String get searchByName => 'ابحث بالاسم';

  @override
  String get searchByEmail => 'ابحث بالإيميل';

  @override
  String get clients => 'العملاء';

  @override
  String get freelancers => 'المستقلين';

  @override
  String get totalOrders => 'إجمالي الطلبات';

  @override
  String get completed => 'المكتملة';

  @override
  String get earnings => 'الأرباح';

  @override
  String get rating => 'التقييم';

  @override
  String get keyPerformanceIndicators => 'المؤشرات الرئيسية للأداء';

  @override
  String get visualTrendsInsights => 'الرؤى والاتجاهات البصرية';

  @override
  String get pendingActionAlerts => 'الإجراءات والتنبيهات المعلقة';

  @override
  String get exportFinancialCSV => 'تصدير CSV المالي';

  @override
  String get academic => 'أكاديمي';

  @override
  String get reports => 'تقارير';

  @override
  String get mindMaps => 'خرائط ذهنية';

  @override
  String get translation => 'ترجمة';

  @override
  String get summaries => 'ملخصات';

  @override
  String get projects => 'مشاريع';

  @override
  String get presentations => 'عروض تقديمية';

  @override
  String get spss => 'SPSS';

  @override
  String get proofreading => 'مراجعة لغوية';

  @override
  String get cv => 'السيرة الذاتية';

  @override
  String get programming => 'برمجة';

  @override
  String get courses => 'دورات';

  @override
  String get consulting => 'استشارات';

  @override
  String get design => 'تصميم';

  @override
  String get engineering => 'هندسة';

  @override
  String get finance => 'مالية';

  @override
  String get academicSources => 'مصادر أكاديمية';

  @override
  String get scientificReports => 'تقارير علمية';

  @override
  String get languagesTranslation => 'اللغات والترجمة';

  @override
  String get scientificProjects => 'مشاريع علمية';

  @override
  String get spssAnalysis => 'تحليل SPSS';

  @override
  String get cvResume => 'السيرة الذاتية / CV';

  @override
  String get programmingWebDesign => 'برمجة وتصميم مواقع';

  @override
  String get coursesTutorials => 'الدورات التعليمية';

  @override
  String get specializedConsulting => 'استشارات متخصصة';

  @override
  String get graphicDesign => 'تصميم جرافيكي';

  @override
  String get engineeringServices => 'خدمات هندسية';

  @override
  String get financialAccounting => 'الخدمات المالية والمحاسبية';

  @override
  String get clearAll => 'مسح الكل';

  @override
  String get status => 'الحالة';

  @override
  String get sortedBy => 'ترتيب حسب';

  @override
  String get apply => 'تطبيق';

  @override
  String get highestRating => 'أعلى تقييم';

  @override
  String get mostEarnings => 'الأكثر ربحًا';

  @override
  String get mostCompleted => 'الأكثر إكمالًا';

  @override
  String get newest => 'الأحدث';

  @override
  String get oldest => 'الأقدم';

  @override
  String get active => 'نشط';

  @override
  String get suspended => 'معلق';

  @override
  String get inactive => 'غير نشط';

  @override
  String get all => 'الكل';

  @override
  String get filters => 'الفلاتر';

  @override
  String get pending => 'قيد الانتظار';

  @override
  String get verifiedFreelancer => 'مستقل موثق';

  @override
  String get userDetails => 'تفاصيل المستخدم';

  @override
  String get phone => 'الهاتف:';

  @override
  String get registrationDate => 'تاريخ التسجيل:';

  @override
  String get lastUpdated => 'آخر تحديث:';

  @override
  String get adminActions => 'إجراءات المسؤول';

  @override
  String get activeDeactivate => 'تفعيل/تعطيل';

  @override
  String get sendMessage => 'إرسال رسالة';

  @override
  String get verify => 'توثيق';

  @override
  String get unverify => 'إلغاء التوثيق';

  @override
  String get activityStatistics => 'إحصائيات النشاط';

  @override
  String get noOrdersYet => 'لا توجد طلبات بعد';

  @override
  String get filtersTooltip => 'الفلاتر';

  @override
  String get notAvailable => 'غير متوفر';

  @override
  String get unassigned => 'غير معين';

  @override
  String get jobs => 'وظائف';

  @override
  String get reviews => 'التقييمات';

  @override
  String get orderDetails => 'تفاصيل الطلب';

  @override
  String get manageOrders => 'إدارة الطلبات';

  @override
  String get searchForOrder => 'البحث عن طلب';

  @override
  String get searchByStatus => 'البحث بالحالة';

  @override
  String get searchByClientName => 'البحث باسم العميل';

  @override
  String get delayed => 'متأخر';

  @override
  String get newOrder => 'جديد';

  @override
  String get progress => 'قيد التنفيذ';

  @override
  String get delivered => 'تم التسليم';

  @override
  String get cancelled => 'ملغي';

  @override
  String get noOrdersHere => 'لا توجد طلبات هنا';

  @override
  String get late => 'متأخر';

  @override
  String get viewDetails => 'عرض التفاصيل';

  @override
  String get loadingUserInfo => 'جاري تحميل معلومات العميل والمستقل...';

  @override
  String get clientDetails => 'تفاصيل العميل';

  @override
  String get freelancerDetails => 'تفاصيل المستقل';

  @override
  String get requestId => 'رقم الطلب';

  @override
  String get offerId => 'رقم العرض';

  @override
  String get orderTimeline => 'خطة زمنية للطلب';

  @override
  String get cancelOrder => 'إلغاء الطلب';

  @override
  String get orderCreated => 'تم إنشاء الطلب';

  @override
  String get paymentConfirmed => 'تم تأكيد الدفع';

  @override
  String get workStarted => 'بدأ العمل';

  @override
  String get delivery => 'موعد التسليم';

  @override
  String get deadlineExpired => 'انتهى الموعد النهائي';

  @override
  String get noCategory => 'لا يوجد تصنيف';

  @override
  String get offers => 'العروض';

  @override
  String get filterBy => 'فرز حسب';

  @override
  String get price => 'السعر';

  @override
  String get offersReceived => 'العروض المستلمة';

  @override
  String get posted => 'نشر في';

  @override
  String get description => 'الوصف';

  @override
  String get noDescription => 'لا يوجد وصف';

  @override
  String get created => 'تم الإنشاء';

  @override
  String get paid => 'تم الدفع';

  @override
  String get inProgress => 'قيد التنفيذ';

  @override
  String get accepted => 'تم القبول';

  @override
  String get paidPending => 'مدفوع (بانتظار التأكيد)';

  @override
  String get deadline => 'موعد الانتهاء';

  @override
  String get rejected => 'مرفوض';

  @override
  String get id => 'الرقم التعريفي';

  @override
  String get attachments => 'المرفقات';

  @override
  String get serviceType => 'نوع الخدمة';

  @override
  String get budget => 'المبلغ';

  @override
  String get createdAt => 'موعد الانشاء';

  @override
  String get updatedAt => 'موعد التحديث';

  @override
  String get offersCount => ' عدد العروض';

  @override
  String get theme => 'الوضع';

  @override
  String get dark => 'مظلم';

  @override
  String get light => 'فاتح';

  @override
  String get language => 'اللغة';

  @override
  String get close => 'Close';

  @override
  String get commissionPercentage => 'نسبة التطبيق';

  @override
  String get save => 'حفظ';

  @override
  String get noReviews => 'لا توجد تقييمات';

  @override
  String get noReviewsHere => 'لا توجد تقييمات هنا';

  @override
  String get noReviewsForThisFreelancer => 'لا توجد تقييمات لهذا المستقل';

  @override
  String get noReviewsForThisClient => 'لا توجد تقييمات لهذا العميل';

  @override
  String get reviewsGiven => 'التقييمات المقدمة';

  @override
  String get reviewsReceived => 'التقييمات المستلمة';

  @override
  String get noReviewsGiven => 'لم يتم تقديم أي تقييمات';

  @override
  String get noReviewsReceived => 'لم يتم استلام أي تقييمات';

  @override
  String get noReviewsGivenForThisClient => 'لم يتم تقديم أي تقييمات لهذا العميل';

  @override
  String get noReviewsGivenForThisFreelancer => 'لم يتم تقديم أي تقييمات لهذا المستقل';

  @override
  String get noReviewsReceivedForThisClient => 'لم يتم استلام أي تقييمات لهذا العميل';

  @override
  String get service1 => 'توفير المصادر والمراجع الأكاديمية';

  @override
  String get service2 => 'التقارير العلمية';

  @override
  String get service3 => 'الخرائط الذهنية';

  @override
  String get service4 => 'اللغات والترجمة';

  @override
  String get service5 => 'تلخيص كتب - مقالات - محاضرات';

  @override
  String get service6 => 'مشاريع علمية';

  @override
  String get service7 => 'العروض التقديمية (PowerPoint)';

  @override
  String get service8 => 'تحليل إحصائي SPSS';

  @override
  String get service9 => 'تدقيق لغوي';

  @override
  String get service10 => 'سيره ذاتيه';

  @override
  String get service11 => 'البرمجة وتصميم المواقع';

  @override
  String get service12 => 'الشرح والدورات';

  @override
  String get service13 => 'إستشارات متخصصه حسب المجال';

  @override
  String get service14 => 'التصميم الجرافيكي 🎨';

  @override
  String get service15 => 'الخدمات الهندسية';

  @override
  String get service16 => 'الخدمات المالية والمحاسبية';

  @override
  String get orderNow => 'اطلب الان';

  @override
  String get noServicesFound => 'لا يوجد خدمات';
}
