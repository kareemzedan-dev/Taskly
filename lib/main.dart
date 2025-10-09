import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:firebase_core/firebase_core.dart'; // 👈 أضف دي
import 'package:firebase_messaging/firebase_messaging.dart'; // 👈 لو هتستخدم الإشعارات

import 'package:taskly/core/di/di.dart';
import 'package:taskly/core/helper/my_bloc_observer.dart';
import 'package:taskly/core/cache/shared_preferences.dart';
import 'package:taskly/config/theme/app_theme.dart';
import 'package:taskly/config/routes/routes_manager.dart';
import 'package:taskly/core/utils/strings_manager.dart';
import 'package:taskly/features/client/presentation/views/tabs/home/presentation/view_model/services_view_model/services_view_model.dart';
import 'package:taskly/config/l10n/app_localizations.dart';
import 'core/services/firebase_notification_service.dart';
import 'core/services/supabase_service.dart';
import 'core/services/user_status_service.dart';
import 'core/utils/constants_manager.dart';
import 'features/profile/presentation/manager/profile_view_model/profile_view_model.dart';
import 'firebase_options.dart';

late final UserStatusService? userStatusService;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await Supabase.initialize(
    url: ConstantsManager.supabaseUrl,
    anonKey: ConstantsManager.supabaseAnonKey,
  );
  await FirebaseNotificationService.initializeLocalNotifications();
  await FirebaseNotificationService.initializeFCM();
  await SharedPrefHelper.init();
  configureDependencies();

  final userId = SharedPrefHelper.getString(StringsManager.idKey);
  final role = SharedPrefHelper.getString(StringsManager.roleKey);

  userStatusService = userId != null
      ? UserStatusService(
    supabaseService: getIt<SupabaseService>(),
    userId: userId,
  )
      : null;

  Bloc.observer = MyBlocObserver();

  FirebaseMessaging messaging = FirebaseMessaging.instance;
  await messaging.requestPermission();
  final fcmToken = await messaging.getToken();
  print("FCM Token: $fcmToken");

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
      ],
      child: const Taskly(),
    ),
  );
}


class Taskly extends StatelessWidget {
  const Taskly({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(393, 851),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [  Locale('ar')],
          builder: (context, child) {
            return Overlay(
              initialEntries: [OverlayEntry(builder: (context) => child!)],
            );
          },
          theme: AppTheme.lightTheme,
          onGenerateRoute: (settings) => RoutesManager.onGenerateRoute(settings),
          initialRoute: RoutesManager.splash,
        );
      },
    );
  }
}
