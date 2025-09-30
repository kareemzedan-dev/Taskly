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
  String get client => 'Client';

  @override
  String get freelancer => 'Freelancer';

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

  @override
  String get registerFreelancerSubtitle => 'Sign up to find work';

  @override
  String get registerClientSubtitle => 'Sign up to hire the best talent';

  @override
  String get firstName => 'First Name';

  @override
  String get lastName => 'Last Name';

  @override
  String get email => 'Email';

  @override
  String get password => 'Password';

  @override
  String get createAccount => 'Create my account';

  @override
  String get thisFieldIsRequired => 'This field is required';

  @override
  String get welcomeBack => 'Welcome back';

  @override
  String get dontHaveAccount => 'Don\'t have an account?';

  @override
  String get signUp => 'Sign up';

  @override
  String get continueWithGoogle => 'Continue with Google';

  @override
  String get privacyPolicyAgreement => 'By creating an account you agree to the ';

  @override
  String get privacyPolicy => 'privacy policy';

  @override
  String get termsAgreement => ' and to the ';

  @override
  String get termsOfUse => 'terms of use';

  @override
  String get or => 'Or';

  @override
  String get noInternetConnection => 'No internet connection';

  @override
  String get emailAlreadyExists => 'Email already exists or not confirmed. Please check your email.';

  @override
  String get somethingWentWrong => 'Something went wrong, please try again';

  @override
  String get loginFailed => 'Login failed. Please check your email and password.';

  @override
  String notRegisteredAsRole(Object role) {
    return 'You are not registered as $role. Please use the correct account.';
  }

  @override
  String get googleLoginCancelled => 'Google login cancelled';

  @override
  String accountAlreadyRegistered(Object existingRole, Object role) {
    return 'This account is already registered as $existingRole. You cannot register as $role.';
  }

  @override
  String get userRegisteredSuccessfully => 'User registered successfully';

  @override
  String get userLoginSuccessfully => 'User Login successfully';

  @override
  String get googleLoginSuccessful => 'Google login successful';

  @override
  String get dashboardDescription => 'Manage all freelancers and clients in one dashboard';

  @override
  String get performanceTracking => 'Track orders, monitor performance, and keep everything under control';

  @override
  String get skip => 'Skip';

  @override
  String get letsGo => 'Let\'s Go';

  @override
  String get dashboard => 'Dashboard';

  @override
  String get users => 'Users';

  @override
  String get orders => 'Orders';

  @override
  String get messages => 'Messages';

  @override
  String get payments => 'Payments';

  @override
  String hiUser(Object name) {
    return 'Hi $name,';
  }

  @override
  String get welcomeTaskly => 'Welcome to Taskly';

  @override
  String get revenueTrend => 'Revenue Trend';

  @override
  String get totalRevenueInfo => 'Total revenue growth over time';

  @override
  String get orderVolume => 'Order Volume';

  @override
  String get dailyOrderInfo => 'Daily order completion rate';

  @override
  String get categoryDistribution => 'Category Distribution';

  @override
  String get serviceCategoryInfo => 'Service categories by revenue share';

  @override
  String errorPrefix(Object message) {
    return 'Error: $message';
  }

  @override
  String get dashboardOrders => 'Orders';

  @override
  String get dashboardEarnings => 'Earnings';

  @override
  String get dashboardClients => 'Clients';

  @override
  String get dashboardFreelancers => 'Freelancers';

  @override
  String get pendingVerifications => 'Pending Verifications';

  @override
  String get disputesNeedingReview => 'Disputes Needing Review';

  @override
  String get pendingPayments => 'Pending Payments';

  @override
  String get lateOrders => 'Late Orders';

  @override
  String get kpiTitle => 'Key Performance Indicators';

  @override
  String get trendsTitle => 'Visual Trends & Insights';

  @override
  String get monthlyView => 'Monthly View';

  @override
  String get pendingActionsTitle => 'Pending Action & Alerts';

  @override
  String get exportCSVTitle => 'Export Financial CSV';

  @override
  String get exportMoneyCSV => 'Export Money CSV';

  @override
  String get categoryAcademic => 'Academic';

  @override
  String get categoryReports => 'Reports';

  @override
  String get categoryMindMaps => 'Mind Maps';

  @override
  String get categoryTranslation => 'Translation';

  @override
  String get categorySummaries => 'Summaries';

  @override
  String get categoryProjects => 'Projects';

  @override
  String get categoryPresentations => 'Presentations';

  @override
  String get categorySPSS => 'SPSS';

  @override
  String get categoryProofreading => 'Proofreading';

  @override
  String get categoryCV => 'CV';

  @override
  String get categoryProgramming => 'Programming';

  @override
  String get categoryCourses => 'Courses';

  @override
  String get categoryConsulting => 'Consulting';

  @override
  String get categoryDesign => 'Design';

  @override
  String get categoryEngineering => 'Engineering';

  @override
  String get categoryFinance => 'Finance';

  @override
  String get legendAcademic => 'Academic Sources';

  @override
  String get legendReports => 'Scientific Reports';

  @override
  String get legendMindMaps => 'Mind Maps';

  @override
  String get legendTranslation => 'Languages & Translation';

  @override
  String get legendSummaries => 'Summaries';

  @override
  String get legendProjects => 'Scientific Projects';

  @override
  String get legendPresentations => 'Presentations';

  @override
  String get legendSPSS => 'SPSS Analysis';

  @override
  String get legendProofreading => 'Proofreading';

  @override
  String get legendCV => 'CV / Resume';

  @override
  String get legendProgramming => 'Programming & Web Design';

  @override
  String get legendCourses => 'Courses & Tutorials';

  @override
  String get legendConsulting => 'Specialized Consulting';

  @override
  String get legendDesign => 'Graphic Design';

  @override
  String get legendEngineering => 'Engineering Services';

  @override
  String get legendFinance => 'Financial & Accounting';

  @override
  String get manageDashboard => 'Manage Dashboard';

  @override
  String get manageUsers => 'Manage Users';

  @override
  String get searchByName => 'Search by name';

  @override
  String get searchByEmail => 'Search by email';

  @override
  String get clients => 'Clients';

  @override
  String get freelancers => 'Freelancers';

  @override
  String get totalOrders => 'Total Orders';

  @override
  String get completed => 'Completed';

  @override
  String get earnings => 'Earnings';

  @override
  String get rating => 'Rating';

  @override
  String get keyPerformanceIndicators => 'Key Performance Indicators';

  @override
  String get visualTrendsInsights => 'Visual Trends & Insights';

  @override
  String get pendingActionAlerts => 'Pending Action & Alerts';

  @override
  String get exportFinancialCSV => 'Export Financial CSV';

  @override
  String get academic => 'Academic';

  @override
  String get reports => 'Reports';

  @override
  String get mindMaps => 'Mind Maps';

  @override
  String get translation => 'Translation';

  @override
  String get summaries => 'Summaries';

  @override
  String get projects => 'Projects';

  @override
  String get presentations => 'Presentations';

  @override
  String get spss => 'SPSS';

  @override
  String get proofreading => 'Proofreading';

  @override
  String get cv => 'CV';

  @override
  String get programming => 'Programming';

  @override
  String get courses => 'Courses';

  @override
  String get consulting => 'Consulting';

  @override
  String get design => 'Design';

  @override
  String get engineering => 'Engineering';

  @override
  String get finance => 'Finance';

  @override
  String get academicSources => 'Academic Sources';

  @override
  String get scientificReports => 'Scientific Reports';

  @override
  String get languagesTranslation => 'Languages & Translation';

  @override
  String get scientificProjects => 'Scientific Projects';

  @override
  String get spssAnalysis => 'SPSS Analysis';

  @override
  String get cvResume => 'CV / Resume';

  @override
  String get programmingWebDesign => 'Programming & Web Design';

  @override
  String get coursesTutorials => 'Courses & Tutorials';

  @override
  String get specializedConsulting => 'Specialized Consulting';

  @override
  String get graphicDesign => 'Graphic Design';

  @override
  String get engineeringServices => 'Engineering Services';

  @override
  String get financialAccounting => 'Financial & Accounting';

  @override
  String get clearAll => 'Clear All';

  @override
  String get status => 'Status';

  @override
  String get sortedBy => 'Sorted By';

  @override
  String get apply => 'Apply';

  @override
  String get highestRating => 'Highest Rating';

  @override
  String get mostEarnings => 'Most Earnings';

  @override
  String get mostCompleted => 'Most Completed';

  @override
  String get newest => 'Newest';

  @override
  String get oldest => 'Oldest';

  @override
  String get active => 'Active';

  @override
  String get suspended => 'Suspended';

  @override
  String get inactive => 'Inactive';

  @override
  String get all => 'All';

  @override
  String get filters => 'Filters';

  @override
  String get pending => 'Pending';

  @override
  String get verifiedFreelancer => 'Verified Freelancer';

  @override
  String get userDetails => 'User Details';

  @override
  String get phone => 'Phone:';

  @override
  String get registrationDate => 'Registration Date:';

  @override
  String get lastUpdated => 'Last Updated:';

  @override
  String get adminActions => 'Admin Actions';

  @override
  String get activeDeactivate => 'Active/Deactivate';

  @override
  String get sendMessage => 'Send Message';

  @override
  String get verify => 'Verify';

  @override
  String get unverify => 'Unverify';

  @override
  String get activityStatistics => 'Activity Statistics';

  @override
  String get noOrdersYet => 'No Orders Yet';

  @override
  String get filtersTooltip => 'Filters';

  @override
  String get notAvailable => 'Not Available';

  @override
  String get unassigned => 'Unassigned';

  @override
  String get jobs => 'jobs';

  @override
  String get reviews => 'Reviews';

  @override
  String get orderDetails => 'Order Details';

  @override
  String get manageOrders => 'Manage Orders';

  @override
  String get searchForOrder => 'Search for order';

  @override
  String get searchByStatus => 'Search by status';

  @override
  String get searchByClientName => 'Search by client name';

  @override
  String get delayed => 'Delayed';

  @override
  String get newOrder => 'New';

  @override
  String get progress => 'Progress';

  @override
  String get delivered => 'Delivered';

  @override
  String get cancelled => 'Cancelled';

  @override
  String get noOrdersHere => 'No orders here';

  @override
  String get late => 'Late';

  @override
  String get viewDetails => 'View Details';

  @override
  String get loadingUserInfo => 'Loading client & freelancer info...';

  @override
  String get clientDetails => 'Client Details';

  @override
  String get freelancerDetails => 'Freelancer Details';

  @override
  String get requestId => 'Request ID';

  @override
  String get offerId => 'Offer ID';

  @override
  String get orderTimeline => 'Order Timeline';

  @override
  String get cancelOrder => 'Cancel Order';

  @override
  String get orderCreated => 'Order Created';

  @override
  String get paymentConfirmed => 'Payment Confirmed';

  @override
  String get workStarted => 'Work Started';

  @override
  String get delivery => 'Delivery';

  @override
  String get deadlineExpired => 'Deadline Expired';

  @override
  String get noCategory => 'No Category';

  @override
  String get offers => 'Offers';

  @override
  String get filterBy => 'Filter by:';

  @override
  String get price => 'Price';

  @override
  String get offersReceived => 'Offers Received';

  @override
  String get posted => 'Posted';

  @override
  String get description => 'Description';

  @override
  String get noDescription => 'No Description';

  @override
  String get created => 'Created';

  @override
  String get paid => 'Paid';

  @override
  String get inProgress => 'In Progress';

  @override
  String get accepted => 'Accepted';

  @override
  String get paidPending => 'Paid (Pending Confirmation)';

  @override
  String get deadline => 'Deadline';

  @override
  String get rejected => 'Rejected';

  @override
  String get id => 'ID';

  @override
  String get attachments => 'Attachments';

  @override
  String get serviceType => 'Service Type';

  @override
  String get budget => 'Budget';

  @override
  String get createdAt => 'Created At';

  @override
  String get updatedAt => 'Updated At';

  @override
  String get offersCount => 'Offers Count';

  @override
  String get theme => 'Theme';

  @override
  String get dark => 'Dark';

  @override
  String get light => 'Light';

  @override
  String get language => 'Language';

  @override
  String get close => 'Close';

  @override
  String get commissionPercentage => 'Commission Percentage';

  @override
  String get save => 'Save';

  @override
  String get noReviews => 'No Reviews';

  @override
  String get noReviewsHere => 'No reviews here';

  @override
  String get noReviewsForThisFreelancer => 'No reviews for this freelancer';

  @override
  String get noReviewsForThisClient => 'No reviews for this client';

  @override
  String get reviewsGiven => 'Reviews Given';

  @override
  String get reviewsReceived => 'Reviews Received';

  @override
  String get noReviewsGiven => 'No reviews given';

  @override
  String get noReviewsReceived => 'No reviews received';

  @override
  String get noReviewsGivenForThisClient => 'No reviews given for this client';

  @override
  String get noReviewsGivenForThisFreelancer => 'No reviews given for this freelancer';

  @override
  String get noReviewsReceivedForThisClient => 'No reviews received for this client';
}
