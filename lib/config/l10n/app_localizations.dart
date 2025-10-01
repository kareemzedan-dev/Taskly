import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

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
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

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
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en')
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Taskly'**
  String get appTitle;

  /// No description provided for @client.
  ///
  /// In en, this message translates to:
  /// **'Client'**
  String get client;

  /// No description provided for @freelancer.
  ///
  /// In en, this message translates to:
  /// **'Freelancer'**
  String get freelancer;

  /// No description provided for @welcomeMessage.
  ///
  /// In en, this message translates to:
  /// **'Organize work, connect,\n and succeed!'**
  String get welcomeMessage;

  /// No description provided for @freelancerTitle.
  ///
  /// In en, this message translates to:
  /// **'I\'m a Freelancer'**
  String get freelancerTitle;

  /// No description provided for @freelancerSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Find projects & grow your career'**
  String get freelancerSubtitle;

  /// No description provided for @clientTitle.
  ///
  /// In en, this message translates to:
  /// **'I\'m a Client'**
  String get clientTitle;

  /// No description provided for @clientSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Hire talents to get your work done'**
  String get clientSubtitle;

  /// No description provided for @createFreelancerAccount.
  ///
  /// In en, this message translates to:
  /// **'Create Freelancer Account'**
  String get createFreelancerAccount;

  /// No description provided for @createClientAccount.
  ///
  /// In en, this message translates to:
  /// **'Create Client Account'**
  String get createClientAccount;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get alreadyHaveAccount;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Log in'**
  String get login;

  /// No description provided for @registerFreelancerSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Sign up to find work'**
  String get registerFreelancerSubtitle;

  /// No description provided for @registerClientSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Sign up to hire the best talent'**
  String get registerClientSubtitle;

  /// No description provided for @firstName.
  ///
  /// In en, this message translates to:
  /// **'First Name'**
  String get firstName;

  /// No description provided for @lastName.
  ///
  /// In en, this message translates to:
  /// **'Last Name'**
  String get lastName;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'Create my account'**
  String get createAccount;

  /// No description provided for @thisFieldIsRequired.
  ///
  /// In en, this message translates to:
  /// **'This field is required'**
  String get thisFieldIsRequired;

  /// No description provided for @welcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome back'**
  String get welcomeBack;

  /// No description provided for @dontHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get dontHaveAccount;

  /// No description provided for @signUp.
  ///
  /// In en, this message translates to:
  /// **'Sign up'**
  String get signUp;

  /// No description provided for @continueWithGoogle.
  ///
  /// In en, this message translates to:
  /// **'Continue with Google'**
  String get continueWithGoogle;

  /// No description provided for @privacyPolicyAgreement.
  ///
  /// In en, this message translates to:
  /// **'By creating an account you agree to the '**
  String get privacyPolicyAgreement;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'privacy policy'**
  String get privacyPolicy;

  /// No description provided for @termsAgreement.
  ///
  /// In en, this message translates to:
  /// **' and to the '**
  String get termsAgreement;

  /// No description provided for @termsOfUse.
  ///
  /// In en, this message translates to:
  /// **'terms of use'**
  String get termsOfUse;

  /// No description provided for @or.
  ///
  /// In en, this message translates to:
  /// **'Or'**
  String get or;

  /// No description provided for @noInternetConnection.
  ///
  /// In en, this message translates to:
  /// **'No internet connection'**
  String get noInternetConnection;

  /// No description provided for @emailAlreadyExists.
  ///
  /// In en, this message translates to:
  /// **'Email already exists or not confirmed. Please check your email.'**
  String get emailAlreadyExists;

  /// No description provided for @somethingWentWrong.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong, please try again'**
  String get somethingWentWrong;

  /// No description provided for @loginFailed.
  ///
  /// In en, this message translates to:
  /// **'Login failed. Please check your email and password.'**
  String get loginFailed;

  /// No description provided for @notRegisteredAsRole.
  ///
  /// In en, this message translates to:
  /// **'You are not registered as {role}. Please use the correct account.'**
  String notRegisteredAsRole(Object role);

  /// No description provided for @googleLoginCancelled.
  ///
  /// In en, this message translates to:
  /// **'Google login cancelled'**
  String get googleLoginCancelled;

  /// No description provided for @accountAlreadyRegistered.
  ///
  /// In en, this message translates to:
  /// **'This account is already registered as {existingRole}. You cannot register as {role}.'**
  String accountAlreadyRegistered(Object existingRole, Object role);

  /// No description provided for @userRegisteredSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'User registered successfully'**
  String get userRegisteredSuccessfully;

  /// No description provided for @userLoginSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'User Login successfully'**
  String get userLoginSuccessfully;

  /// No description provided for @googleLoginSuccessful.
  ///
  /// In en, this message translates to:
  /// **'Google login successful'**
  String get googleLoginSuccessful;

  /// No description provided for @dashboardDescription.
  ///
  /// In en, this message translates to:
  /// **'Manage all freelancers and clients in one dashboard'**
  String get dashboardDescription;

  /// No description provided for @performanceTracking.
  ///
  /// In en, this message translates to:
  /// **'Track orders, monitor performance, and keep everything under control'**
  String get performanceTracking;

  /// No description provided for @skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// No description provided for @letsGo.
  ///
  /// In en, this message translates to:
  /// **'Let\'s Go'**
  String get letsGo;

  /// No description provided for @dashboard.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get dashboard;

  /// No description provided for @users.
  ///
  /// In en, this message translates to:
  /// **'Users'**
  String get users;

  /// No description provided for @orders.
  ///
  /// In en, this message translates to:
  /// **'Orders'**
  String get orders;

  /// No description provided for @messages.
  ///
  /// In en, this message translates to:
  /// **'Messages'**
  String get messages;

  /// No description provided for @payments.
  ///
  /// In en, this message translates to:
  /// **'Payments'**
  String get payments;

  /// No description provided for @hiUser.
  ///
  /// In en, this message translates to:
  /// **'Hi {name},'**
  String hiUser(Object name);

  /// No description provided for @welcomeTaskly.
  ///
  /// In en, this message translates to:
  /// **'Welcome to Taskly'**
  String get welcomeTaskly;

  /// No description provided for @revenueTrend.
  ///
  /// In en, this message translates to:
  /// **'Revenue Trend'**
  String get revenueTrend;

  /// No description provided for @totalRevenueInfo.
  ///
  /// In en, this message translates to:
  /// **'Total revenue growth over time'**
  String get totalRevenueInfo;

  /// No description provided for @orderVolume.
  ///
  /// In en, this message translates to:
  /// **'Order Volume'**
  String get orderVolume;

  /// No description provided for @dailyOrderInfo.
  ///
  /// In en, this message translates to:
  /// **'Daily order completion rate'**
  String get dailyOrderInfo;

  /// No description provided for @categoryDistribution.
  ///
  /// In en, this message translates to:
  /// **'Category Distribution'**
  String get categoryDistribution;

  /// No description provided for @serviceCategoryInfo.
  ///
  /// In en, this message translates to:
  /// **'Service categories by revenue share'**
  String get serviceCategoryInfo;

  /// No description provided for @errorPrefix.
  ///
  /// In en, this message translates to:
  /// **'Error: {message}'**
  String errorPrefix(Object message);

  /// No description provided for @dashboardOrders.
  ///
  /// In en, this message translates to:
  /// **'Orders'**
  String get dashboardOrders;

  /// No description provided for @dashboardEarnings.
  ///
  /// In en, this message translates to:
  /// **'Earnings'**
  String get dashboardEarnings;

  /// No description provided for @dashboardClients.
  ///
  /// In en, this message translates to:
  /// **'Clients'**
  String get dashboardClients;

  /// No description provided for @dashboardFreelancers.
  ///
  /// In en, this message translates to:
  /// **'Freelancers'**
  String get dashboardFreelancers;

  /// No description provided for @pendingVerifications.
  ///
  /// In en, this message translates to:
  /// **'Pending Verifications'**
  String get pendingVerifications;

  /// No description provided for @disputesNeedingReview.
  ///
  /// In en, this message translates to:
  /// **'Disputes Needing Review'**
  String get disputesNeedingReview;

  /// No description provided for @pendingPayments.
  ///
  /// In en, this message translates to:
  /// **'Pending Payments'**
  String get pendingPayments;

  /// No description provided for @lateOrders.
  ///
  /// In en, this message translates to:
  /// **'Late Orders'**
  String get lateOrders;

  /// No description provided for @kpiTitle.
  ///
  /// In en, this message translates to:
  /// **'Key Performance Indicators'**
  String get kpiTitle;

  /// No description provided for @trendsTitle.
  ///
  /// In en, this message translates to:
  /// **'Visual Trends & Insights'**
  String get trendsTitle;

  /// No description provided for @monthlyView.
  ///
  /// In en, this message translates to:
  /// **'Monthly View'**
  String get monthlyView;

  /// No description provided for @pendingActionsTitle.
  ///
  /// In en, this message translates to:
  /// **'Pending Action & Alerts'**
  String get pendingActionsTitle;

  /// No description provided for @exportCSVTitle.
  ///
  /// In en, this message translates to:
  /// **'Export Financial CSV'**
  String get exportCSVTitle;

  /// No description provided for @exportMoneyCSV.
  ///
  /// In en, this message translates to:
  /// **'Export Money CSV'**
  String get exportMoneyCSV;

  /// No description provided for @categoryAcademic.
  ///
  /// In en, this message translates to:
  /// **'Academic'**
  String get categoryAcademic;

  /// No description provided for @categoryReports.
  ///
  /// In en, this message translates to:
  /// **'Reports'**
  String get categoryReports;

  /// No description provided for @categoryMindMaps.
  ///
  /// In en, this message translates to:
  /// **'Mind Maps'**
  String get categoryMindMaps;

  /// No description provided for @categoryTranslation.
  ///
  /// In en, this message translates to:
  /// **'Translation'**
  String get categoryTranslation;

  /// No description provided for @categorySummaries.
  ///
  /// In en, this message translates to:
  /// **'Summaries'**
  String get categorySummaries;

  /// No description provided for @categoryProjects.
  ///
  /// In en, this message translates to:
  /// **'Projects'**
  String get categoryProjects;

  /// No description provided for @categoryPresentations.
  ///
  /// In en, this message translates to:
  /// **'Presentations'**
  String get categoryPresentations;

  /// No description provided for @categorySPSS.
  ///
  /// In en, this message translates to:
  /// **'SPSS'**
  String get categorySPSS;

  /// No description provided for @categoryProofreading.
  ///
  /// In en, this message translates to:
  /// **'Proofreading'**
  String get categoryProofreading;

  /// No description provided for @categoryCV.
  ///
  /// In en, this message translates to:
  /// **'CV'**
  String get categoryCV;

  /// No description provided for @categoryProgramming.
  ///
  /// In en, this message translates to:
  /// **'Programming'**
  String get categoryProgramming;

  /// No description provided for @categoryCourses.
  ///
  /// In en, this message translates to:
  /// **'Courses'**
  String get categoryCourses;

  /// No description provided for @categoryConsulting.
  ///
  /// In en, this message translates to:
  /// **'Consulting'**
  String get categoryConsulting;

  /// No description provided for @categoryDesign.
  ///
  /// In en, this message translates to:
  /// **'Design'**
  String get categoryDesign;

  /// No description provided for @categoryEngineering.
  ///
  /// In en, this message translates to:
  /// **'Engineering'**
  String get categoryEngineering;

  /// No description provided for @categoryFinance.
  ///
  /// In en, this message translates to:
  /// **'Finance'**
  String get categoryFinance;

  /// No description provided for @legendAcademic.
  ///
  /// In en, this message translates to:
  /// **'Academic Sources'**
  String get legendAcademic;

  /// No description provided for @legendReports.
  ///
  /// In en, this message translates to:
  /// **'Scientific Reports'**
  String get legendReports;

  /// No description provided for @legendMindMaps.
  ///
  /// In en, this message translates to:
  /// **'Mind Maps'**
  String get legendMindMaps;

  /// No description provided for @legendTranslation.
  ///
  /// In en, this message translates to:
  /// **'Languages & Translation'**
  String get legendTranslation;

  /// No description provided for @legendSummaries.
  ///
  /// In en, this message translates to:
  /// **'Summaries'**
  String get legendSummaries;

  /// No description provided for @legendProjects.
  ///
  /// In en, this message translates to:
  /// **'Scientific Projects'**
  String get legendProjects;

  /// No description provided for @legendPresentations.
  ///
  /// In en, this message translates to:
  /// **'Presentations'**
  String get legendPresentations;

  /// No description provided for @legendSPSS.
  ///
  /// In en, this message translates to:
  /// **'SPSS Analysis'**
  String get legendSPSS;

  /// No description provided for @legendProofreading.
  ///
  /// In en, this message translates to:
  /// **'Proofreading'**
  String get legendProofreading;

  /// No description provided for @legendCV.
  ///
  /// In en, this message translates to:
  /// **'CV / Resume'**
  String get legendCV;

  /// No description provided for @legendProgramming.
  ///
  /// In en, this message translates to:
  /// **'Programming & Web Design'**
  String get legendProgramming;

  /// No description provided for @legendCourses.
  ///
  /// In en, this message translates to:
  /// **'Courses & Tutorials'**
  String get legendCourses;

  /// No description provided for @legendConsulting.
  ///
  /// In en, this message translates to:
  /// **'Specialized Consulting'**
  String get legendConsulting;

  /// No description provided for @legendDesign.
  ///
  /// In en, this message translates to:
  /// **'Graphic Design'**
  String get legendDesign;

  /// No description provided for @legendEngineering.
  ///
  /// In en, this message translates to:
  /// **'Engineering Services'**
  String get legendEngineering;

  /// No description provided for @legendFinance.
  ///
  /// In en, this message translates to:
  /// **'Financial & Accounting'**
  String get legendFinance;

  /// No description provided for @manageDashboard.
  ///
  /// In en, this message translates to:
  /// **'Manage Dashboard'**
  String get manageDashboard;

  /// No description provided for @manageUsers.
  ///
  /// In en, this message translates to:
  /// **'Manage Users'**
  String get manageUsers;

  /// No description provided for @searchByName.
  ///
  /// In en, this message translates to:
  /// **'Search by name'**
  String get searchByName;

  /// No description provided for @searchByEmail.
  ///
  /// In en, this message translates to:
  /// **'Search by email'**
  String get searchByEmail;

  /// No description provided for @clients.
  ///
  /// In en, this message translates to:
  /// **'Clients'**
  String get clients;

  /// No description provided for @freelancers.
  ///
  /// In en, this message translates to:
  /// **'Freelancers'**
  String get freelancers;

  /// No description provided for @totalOrders.
  ///
  /// In en, this message translates to:
  /// **'Total Orders'**
  String get totalOrders;

  /// No description provided for @completed.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get completed;

  /// No description provided for @earnings.
  ///
  /// In en, this message translates to:
  /// **'Earnings'**
  String get earnings;

  /// No description provided for @rating.
  ///
  /// In en, this message translates to:
  /// **'Rating'**
  String get rating;

  /// No description provided for @keyPerformanceIndicators.
  ///
  /// In en, this message translates to:
  /// **'Key Performance Indicators'**
  String get keyPerformanceIndicators;

  /// No description provided for @visualTrendsInsights.
  ///
  /// In en, this message translates to:
  /// **'Visual Trends & Insights'**
  String get visualTrendsInsights;

  /// No description provided for @pendingActionAlerts.
  ///
  /// In en, this message translates to:
  /// **'Pending Action & Alerts'**
  String get pendingActionAlerts;

  /// No description provided for @exportFinancialCSV.
  ///
  /// In en, this message translates to:
  /// **'Export Financial CSV'**
  String get exportFinancialCSV;

  /// No description provided for @academic.
  ///
  /// In en, this message translates to:
  /// **'Academic'**
  String get academic;

  /// No description provided for @reports.
  ///
  /// In en, this message translates to:
  /// **'Reports'**
  String get reports;

  /// No description provided for @mindMaps.
  ///
  /// In en, this message translates to:
  /// **'Mind Maps'**
  String get mindMaps;

  /// No description provided for @translation.
  ///
  /// In en, this message translates to:
  /// **'Translation'**
  String get translation;

  /// No description provided for @summaries.
  ///
  /// In en, this message translates to:
  /// **'Summaries'**
  String get summaries;

  /// No description provided for @projects.
  ///
  /// In en, this message translates to:
  /// **'Projects'**
  String get projects;

  /// No description provided for @presentations.
  ///
  /// In en, this message translates to:
  /// **'Presentations'**
  String get presentations;

  /// No description provided for @spss.
  ///
  /// In en, this message translates to:
  /// **'SPSS'**
  String get spss;

  /// No description provided for @proofreading.
  ///
  /// In en, this message translates to:
  /// **'Proofreading'**
  String get proofreading;

  /// No description provided for @cv.
  ///
  /// In en, this message translates to:
  /// **'CV'**
  String get cv;

  /// No description provided for @programming.
  ///
  /// In en, this message translates to:
  /// **'Programming'**
  String get programming;

  /// No description provided for @courses.
  ///
  /// In en, this message translates to:
  /// **'Courses'**
  String get courses;

  /// No description provided for @consulting.
  ///
  /// In en, this message translates to:
  /// **'Consulting'**
  String get consulting;

  /// No description provided for @design.
  ///
  /// In en, this message translates to:
  /// **'Design'**
  String get design;

  /// No description provided for @engineering.
  ///
  /// In en, this message translates to:
  /// **'Engineering'**
  String get engineering;

  /// No description provided for @finance.
  ///
  /// In en, this message translates to:
  /// **'Finance'**
  String get finance;

  /// No description provided for @academicSources.
  ///
  /// In en, this message translates to:
  /// **'Academic Sources'**
  String get academicSources;

  /// No description provided for @scientificReports.
  ///
  /// In en, this message translates to:
  /// **'Scientific Reports'**
  String get scientificReports;

  /// No description provided for @languagesTranslation.
  ///
  /// In en, this message translates to:
  /// **'Languages & Translation'**
  String get languagesTranslation;

  /// No description provided for @scientificProjects.
  ///
  /// In en, this message translates to:
  /// **'Scientific Projects'**
  String get scientificProjects;

  /// No description provided for @spssAnalysis.
  ///
  /// In en, this message translates to:
  /// **'SPSS Analysis'**
  String get spssAnalysis;

  /// No description provided for @cvResume.
  ///
  /// In en, this message translates to:
  /// **'CV / Resume'**
  String get cvResume;

  /// No description provided for @programmingWebDesign.
  ///
  /// In en, this message translates to:
  /// **'Programming & Web Design'**
  String get programmingWebDesign;

  /// No description provided for @coursesTutorials.
  ///
  /// In en, this message translates to:
  /// **'Courses & Tutorials'**
  String get coursesTutorials;

  /// No description provided for @specializedConsulting.
  ///
  /// In en, this message translates to:
  /// **'Specialized Consulting'**
  String get specializedConsulting;

  /// No description provided for @graphicDesign.
  ///
  /// In en, this message translates to:
  /// **'Graphic Design'**
  String get graphicDesign;

  /// No description provided for @engineeringServices.
  ///
  /// In en, this message translates to:
  /// **'Engineering Services'**
  String get engineeringServices;

  /// No description provided for @financialAccounting.
  ///
  /// In en, this message translates to:
  /// **'Financial & Accounting'**
  String get financialAccounting;

  /// No description provided for @clearAll.
  ///
  /// In en, this message translates to:
  /// **'Clear All'**
  String get clearAll;

  /// No description provided for @status.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get status;

  /// No description provided for @sortedBy.
  ///
  /// In en, this message translates to:
  /// **'Sorted By'**
  String get sortedBy;

  /// No description provided for @apply.
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get apply;

  /// No description provided for @highestRating.
  ///
  /// In en, this message translates to:
  /// **'Highest Rating'**
  String get highestRating;

  /// No description provided for @mostEarnings.
  ///
  /// In en, this message translates to:
  /// **'Most Earnings'**
  String get mostEarnings;

  /// No description provided for @mostCompleted.
  ///
  /// In en, this message translates to:
  /// **'Most Completed'**
  String get mostCompleted;

  /// No description provided for @newest.
  ///
  /// In en, this message translates to:
  /// **'Newest'**
  String get newest;

  /// No description provided for @oldest.
  ///
  /// In en, this message translates to:
  /// **'Oldest'**
  String get oldest;

  /// No description provided for @active.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get active;

  /// No description provided for @suspended.
  ///
  /// In en, this message translates to:
  /// **'Suspended'**
  String get suspended;

  /// No description provided for @inactive.
  ///
  /// In en, this message translates to:
  /// **'Inactive'**
  String get inactive;

  /// No description provided for @all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;

  /// No description provided for @filters.
  ///
  /// In en, this message translates to:
  /// **'Filters'**
  String get filters;

  /// No description provided for @pending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get pending;

  /// No description provided for @verifiedFreelancer.
  ///
  /// In en, this message translates to:
  /// **'Verified Freelancer'**
  String get verifiedFreelancer;

  /// No description provided for @userDetails.
  ///
  /// In en, this message translates to:
  /// **'User Details'**
  String get userDetails;

  /// No description provided for @phone.
  ///
  /// In en, this message translates to:
  /// **'Phone:'**
  String get phone;

  /// No description provided for @registrationDate.
  ///
  /// In en, this message translates to:
  /// **'Registration Date:'**
  String get registrationDate;

  /// No description provided for @lastUpdated.
  ///
  /// In en, this message translates to:
  /// **'Last Updated:'**
  String get lastUpdated;

  /// No description provided for @adminActions.
  ///
  /// In en, this message translates to:
  /// **'Admin Actions'**
  String get adminActions;

  /// No description provided for @activeDeactivate.
  ///
  /// In en, this message translates to:
  /// **'Active/Deactivate'**
  String get activeDeactivate;

  /// No description provided for @sendMessage.
  ///
  /// In en, this message translates to:
  /// **'Send Message'**
  String get sendMessage;

  /// No description provided for @verify.
  ///
  /// In en, this message translates to:
  /// **'Verify'**
  String get verify;

  /// No description provided for @unverify.
  ///
  /// In en, this message translates to:
  /// **'Unverify'**
  String get unverify;

  /// No description provided for @activityStatistics.
  ///
  /// In en, this message translates to:
  /// **'Activity Statistics'**
  String get activityStatistics;

  /// No description provided for @noOrdersYet.
  ///
  /// In en, this message translates to:
  /// **'No Orders Yet'**
  String get noOrdersYet;

  /// No description provided for @filtersTooltip.
  ///
  /// In en, this message translates to:
  /// **'Filters'**
  String get filtersTooltip;

  /// No description provided for @notAvailable.
  ///
  /// In en, this message translates to:
  /// **'Not Available'**
  String get notAvailable;

  /// No description provided for @unassigned.
  ///
  /// In en, this message translates to:
  /// **'Unassigned'**
  String get unassigned;

  /// No description provided for @jobs.
  ///
  /// In en, this message translates to:
  /// **'jobs'**
  String get jobs;

  /// No description provided for @reviews.
  ///
  /// In en, this message translates to:
  /// **'Reviews'**
  String get reviews;

  /// No description provided for @orderDetails.
  ///
  /// In en, this message translates to:
  /// **'Order Details'**
  String get orderDetails;

  /// No description provided for @manageOrders.
  ///
  /// In en, this message translates to:
  /// **'Manage Orders'**
  String get manageOrders;

  /// No description provided for @searchForOrder.
  ///
  /// In en, this message translates to:
  /// **'Search for order'**
  String get searchForOrder;

  /// No description provided for @searchByStatus.
  ///
  /// In en, this message translates to:
  /// **'Search by status'**
  String get searchByStatus;

  /// No description provided for @searchByClientName.
  ///
  /// In en, this message translates to:
  /// **'Search by client name'**
  String get searchByClientName;

  /// No description provided for @delayed.
  ///
  /// In en, this message translates to:
  /// **'Delayed'**
  String get delayed;

  /// No description provided for @newOrder.
  ///
  /// In en, this message translates to:
  /// **'New'**
  String get newOrder;

  /// No description provided for @progress.
  ///
  /// In en, this message translates to:
  /// **'Progress'**
  String get progress;

  /// No description provided for @delivered.
  ///
  /// In en, this message translates to:
  /// **'Delivered'**
  String get delivered;

  /// No description provided for @cancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get cancelled;

  /// No description provided for @noOrdersHere.
  ///
  /// In en, this message translates to:
  /// **'No orders here'**
  String get noOrdersHere;

  /// No description provided for @late.
  ///
  /// In en, this message translates to:
  /// **'Late'**
  String get late;

  /// No description provided for @viewDetails.
  ///
  /// In en, this message translates to:
  /// **'View Details'**
  String get viewDetails;

  /// No description provided for @loadingUserInfo.
  ///
  /// In en, this message translates to:
  /// **'Loading client & freelancer info...'**
  String get loadingUserInfo;

  /// No description provided for @clientDetails.
  ///
  /// In en, this message translates to:
  /// **'Client Details'**
  String get clientDetails;

  /// No description provided for @freelancerDetails.
  ///
  /// In en, this message translates to:
  /// **'Freelancer Details'**
  String get freelancerDetails;

  /// No description provided for @requestId.
  ///
  /// In en, this message translates to:
  /// **'Request ID'**
  String get requestId;

  /// No description provided for @offerId.
  ///
  /// In en, this message translates to:
  /// **'Offer ID'**
  String get offerId;

  /// No description provided for @orderTimeline.
  ///
  /// In en, this message translates to:
  /// **'Order Timeline'**
  String get orderTimeline;

  /// No description provided for @cancelOrder.
  ///
  /// In en, this message translates to:
  /// **'Cancel Order'**
  String get cancelOrder;

  /// No description provided for @orderCreated.
  ///
  /// In en, this message translates to:
  /// **'Order Created'**
  String get orderCreated;

  /// No description provided for @paymentConfirmed.
  ///
  /// In en, this message translates to:
  /// **'Payment Confirmed'**
  String get paymentConfirmed;

  /// No description provided for @workStarted.
  ///
  /// In en, this message translates to:
  /// **'Work Started'**
  String get workStarted;

  /// No description provided for @delivery.
  ///
  /// In en, this message translates to:
  /// **'Delivery'**
  String get delivery;

  /// No description provided for @deadlineExpired.
  ///
  /// In en, this message translates to:
  /// **'Deadline Expired'**
  String get deadlineExpired;

  /// No description provided for @noCategory.
  ///
  /// In en, this message translates to:
  /// **'No Category'**
  String get noCategory;

  /// No description provided for @offers.
  ///
  /// In en, this message translates to:
  /// **'Offers'**
  String get offers;

  /// No description provided for @filterBy.
  ///
  /// In en, this message translates to:
  /// **'Filter by:'**
  String get filterBy;

  /// No description provided for @price.
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get price;

  /// No description provided for @offersReceived.
  ///
  /// In en, this message translates to:
  /// **'Offers Received'**
  String get offersReceived;

  /// No description provided for @posted.
  ///
  /// In en, this message translates to:
  /// **'Posted'**
  String get posted;

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// No description provided for @noDescription.
  ///
  /// In en, this message translates to:
  /// **'No Description'**
  String get noDescription;

  /// No description provided for @created.
  ///
  /// In en, this message translates to:
  /// **'Created'**
  String get created;

  /// No description provided for @paid.
  ///
  /// In en, this message translates to:
  /// **'Paid'**
  String get paid;

  /// No description provided for @inProgress.
  ///
  /// In en, this message translates to:
  /// **'In Progress'**
  String get inProgress;

  /// No description provided for @accepted.
  ///
  /// In en, this message translates to:
  /// **'Accepted'**
  String get accepted;

  /// No description provided for @paidPending.
  ///
  /// In en, this message translates to:
  /// **'Paid (Pending Confirmation)'**
  String get paidPending;

  /// No description provided for @deadline.
  ///
  /// In en, this message translates to:
  /// **'Deadline'**
  String get deadline;

  /// No description provided for @rejected.
  ///
  /// In en, this message translates to:
  /// **'Rejected'**
  String get rejected;

  /// No description provided for @id.
  ///
  /// In en, this message translates to:
  /// **'ID'**
  String get id;

  /// No description provided for @attachments.
  ///
  /// In en, this message translates to:
  /// **'Attachments'**
  String get attachments;

  /// No description provided for @serviceType.
  ///
  /// In en, this message translates to:
  /// **'Service Type'**
  String get serviceType;

  /// No description provided for @budget.
  ///
  /// In en, this message translates to:
  /// **'Budget'**
  String get budget;

  /// No description provided for @createdAt.
  ///
  /// In en, this message translates to:
  /// **'Created At'**
  String get createdAt;

  /// No description provided for @updatedAt.
  ///
  /// In en, this message translates to:
  /// **'Updated At'**
  String get updatedAt;

  /// No description provided for @offersCount.
  ///
  /// In en, this message translates to:
  /// **'Offers Count'**
  String get offersCount;

  /// No description provided for @theme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// No description provided for @dark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get dark;

  /// No description provided for @light.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get light;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @commissionPercentage.
  ///
  /// In en, this message translates to:
  /// **'Commission Percentage'**
  String get commissionPercentage;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @noReviews.
  ///
  /// In en, this message translates to:
  /// **'No Reviews'**
  String get noReviews;

  /// No description provided for @noReviewsHere.
  ///
  /// In en, this message translates to:
  /// **'No reviews here'**
  String get noReviewsHere;

  /// No description provided for @noReviewsForThisFreelancer.
  ///
  /// In en, this message translates to:
  /// **'No reviews for this freelancer'**
  String get noReviewsForThisFreelancer;

  /// No description provided for @noReviewsForThisClient.
  ///
  /// In en, this message translates to:
  /// **'No reviews for this client'**
  String get noReviewsForThisClient;

  /// No description provided for @reviewsGiven.
  ///
  /// In en, this message translates to:
  /// **'Reviews Given'**
  String get reviewsGiven;

  /// No description provided for @reviewsReceived.
  ///
  /// In en, this message translates to:
  /// **'Reviews Received'**
  String get reviewsReceived;

  /// No description provided for @noReviewsGiven.
  ///
  /// In en, this message translates to:
  /// **'No reviews given'**
  String get noReviewsGiven;

  /// No description provided for @noReviewsReceived.
  ///
  /// In en, this message translates to:
  /// **'No reviews received'**
  String get noReviewsReceived;

  /// No description provided for @noReviewsGivenForThisClient.
  ///
  /// In en, this message translates to:
  /// **'No reviews given for this client'**
  String get noReviewsGivenForThisClient;

  /// No description provided for @noReviewsGivenForThisFreelancer.
  ///
  /// In en, this message translates to:
  /// **'No reviews given for this freelancer'**
  String get noReviewsGivenForThisFreelancer;

  /// No description provided for @noReviewsReceivedForThisClient.
  ///
  /// In en, this message translates to:
  /// **'No reviews received for this client'**
  String get noReviewsReceivedForThisClient;

  /// No description provided for @service1.
  ///
  /// In en, this message translates to:
  /// **'Providing academic sources and references'**
  String get service1;

  /// No description provided for @service2.
  ///
  /// In en, this message translates to:
  /// **'Scientific reports'**
  String get service2;

  /// No description provided for @service3.
  ///
  /// In en, this message translates to:
  /// **'Mind maps'**
  String get service3;

  /// No description provided for @service4.
  ///
  /// In en, this message translates to:
  /// **'Languages and translation'**
  String get service4;

  /// No description provided for @service5.
  ///
  /// In en, this message translates to:
  /// **'Summarizing books, articles, and lectures'**
  String get service5;

  /// No description provided for @service6.
  ///
  /// In en, this message translates to:
  /// **'Scientific projects'**
  String get service6;

  /// No description provided for @service7.
  ///
  /// In en, this message translates to:
  /// **'Presentations (PowerPoint)'**
  String get service7;

  /// No description provided for @service8.
  ///
  /// In en, this message translates to:
  /// **'Statistical analysis (SPSS)'**
  String get service8;

  /// No description provided for @service9.
  ///
  /// In en, this message translates to:
  /// **'Proofreading'**
  String get service9;

  /// No description provided for @service10.
  ///
  /// In en, this message translates to:
  /// **'Resume/CV'**
  String get service10;

  /// No description provided for @service11.
  ///
  /// In en, this message translates to:
  /// **'Programming and web design'**
  String get service11;

  /// No description provided for @service12.
  ///
  /// In en, this message translates to:
  /// **'Tutorials and courses'**
  String get service12;

  /// No description provided for @service13.
  ///
  /// In en, this message translates to:
  /// **'Specialized consultations by field'**
  String get service13;

  /// No description provided for @service14.
  ///
  /// In en, this message translates to:
  /// **'Graphic design 🎨'**
  String get service14;

  /// No description provided for @service15.
  ///
  /// In en, this message translates to:
  /// **'Engineering services'**
  String get service15;

  /// No description provided for @service16.
  ///
  /// In en, this message translates to:
  /// **'Financial and accounting services'**
  String get service16;

  /// No description provided for @orderNow.
  ///
  /// In en, this message translates to:
  /// **'Order Now'**
  String get orderNow;

  /// No description provided for @noServicesFound.
  ///
  /// In en, this message translates to:
  /// **'No services found'**
  String get noServicesFound;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar': return AppLocalizationsAr();
    case 'en': return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
