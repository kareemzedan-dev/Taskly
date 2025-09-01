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
}
