import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:taskly/core/di/di.dart';
import 'package:taskly/core/helper/my_bloc_observer.dart';
import 'package:taskly/core/cache/shared_preferences.dart';
import 'package:taskly/config/theme/app_theme.dart';
import 'package:taskly/config/routes/routes_manager.dart';
import 'package:taskly/core/utils/strings_manager.dart';
import 'package:taskly/features/client/presentation/views/tabs/home/presentation/view_model/services_view_model/services_view_model.dart';
import 'package:taskly/config/l10n/app_localizations.dart';
import 'core/helper/language_notifier.dart';
import 'core/services/firebase_notification_service.dart';
import 'core/services/supabase_service.dart';
import 'core/services/user_status_service.dart';
import 'core/utils/constants_manager.dart';
import 'features/profile/presentation/manager/profile_view_model/profile_view_model.dart';
import 'firebase_options.dart';

late final UserStatusService? userStatusService;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase & Supabase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await Supabase.initialize(
    url: ConstantsManager.supabaseUrl,
    anonKey: ConstantsManager.supabaseAnonKey,
  );

  await FirebaseNotificationService.initializeLocalNotifications();
  await FirebaseNotificationService.initializeFCM();
  await SharedPrefHelper.init();
  configureDependencies();

  // Bloc Observer
  Bloc.observer = MyBlocObserver();

  // FCM Token (optional)
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  await messaging.requestPermission();
  final fcmToken = await messaging.getToken();
  print("FCM Token: $fcmToken");

  final savedLanguageCode =
      SharedPrefHelper.getString(StringsManager.languageCodeKey) ?? 'ar';

  final userId = SharedPrefHelper.getString(StringsManager.idKey);
  final role = SharedPrefHelper.getString(StringsManager.roleKey);

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => getIt<ServicesViewModel>()..getServices(),
        ),
        if (userId != null && role != null)
          BlocProvider(
            create: (context) =>
            getIt<ProfileViewModel>()..getUserInfo(userId, role),
          ),
        ChangeNotifierProvider(
          create: (_) => LanguageNotifier(Locale(savedLanguageCode)),
        ),

      ],
      child: Taskly(userId: userId),
    ),
  );
}

class Taskly extends StatefulWidget {
  final String? userId;
  const Taskly({super.key, this.userId});

  @override
  State<Taskly> createState() => _TasklyState();
}

class _TasklyState extends State<Taskly> with WidgetsBindingObserver {
  late final UserStatusService userStatusService;

  @override
  void initState() {
    super.initState();
    userStatusService = getIt<UserStatusService>();
    if (widget.userId != null) {
      userStatusService.initialize(widget.userId!);
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    userStatusService.handleAppLifecycle(state);
  }

  @override
  void dispose() {
    userStatusService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final languageNotifier = context.watch<LanguageNotifier>();

    return ScreenUtilInit(
      designSize: const Size(393, 851),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          locale: Locale(languageNotifier.currentLanguage),
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('ar'),
            Locale('en'),
          ],
          theme: AppTheme.darkTheme,
          onGenerateRoute: RoutesManager.onGenerateRoute,
          initialRoute: RoutesManager.splash,
        );
      },
    );
  }
}
