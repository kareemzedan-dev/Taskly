import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:taskly/core/di/di.dart';
import 'package:taskly/core/helper/my_bloc_observer.dart';
import 'package:taskly/core/cache/shared_preferences.dart';
import 'package:taskly/config/theme/app_theme.dart';
import 'package:taskly/config/routes/routes_manager.dart';
import 'package:taskly/core/utils/strings_manager.dart';
import 'package:taskly/features/client/presentation/views/tabs/home/presentation/view_model/services_view_model/services_view_model.dart';
import 'package:taskly/config/l10n/app_localizations.dart';

import 'core/services/supabase_service.dart';
import 'core/services/user_status_service.dart';
import 'features/profile/presentation/manager/profile_view_model/profile_view_model.dart';
late final UserStatusService userStatusService;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://bztszvzfcnbfmsxkhkhn.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImJ6dHN6dnpmY25iZm1zeGtoa2huIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTY2Njc1NzcsImV4cCI6MjA3MjI0MzU3N30.wErI53sqLbmnK_WXe3oJhuYffS7Xcl9yGne1arhhLoA',
  );
  await SharedPrefHelper.init();
  configureDependencies();
  final userId = SharedPrefHelper.getString(StringsManager.idKey)!;
  userStatusService = UserStatusService(
    supabaseService: getIt<SupabaseService>(),
    userId: userId,
  );
  Bloc.observer = MyBlocObserver();
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => getIt<ServicesViewModel>()..getServices(),
        ),
        BlocProvider(create:
        (context) => getIt<ProfileViewModel>()..getUserInfo(SharedPrefHelper.getString(StringsManager.idKey)!,  SharedPrefHelper.getString(StringsManager.roleKey)!,)
        )
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
          supportedLocales: const [Locale('en'), Locale('ar')],
          builder: (context, child) {
            return Overlay(
              initialEntries: [
                OverlayEntry(builder: (context) => child!),
              ],
            );
          },
          theme: AppTheme.lightTheme,

          onGenerateRoute:
              (settings) => RoutesManager.onGenerateRoute(settings),
          initialRoute: RoutesManager.splash,
        );
      },
    );
  }
}
