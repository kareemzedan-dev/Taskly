// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Taskly';

  @override
  String get welcomeMessage => 'Organize work, connect,\n and succeed!';

  @override
  String get freelancerTitle => 'I\'m a Freelancer';

  @override
  String get freelancerSubtitle => 'Find projects & grow your career';

  @override
  String get clientTitle => 'I\'m a Client';

  @override
  String get clientSubtitle => 'Hire talents to get your work done';

  @override
  String get createFreelancerAccount => 'Create Freelancer Account';

  @override
  String get createClientAccount => 'Create Client Account';

  @override
  String get alreadyHaveAccount => 'Already have an account?';

  @override
  String get login => 'Log in';
}
