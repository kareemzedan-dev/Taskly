import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:taskly/core/di/di.dart';
import 'package:taskly/core/helper/my_bloc_observer.dart';
import 'package:taskly/core/helper/shared_preferences.dart';
import 'package:taskly/core/theme/app_theme.dart';

import 'package:taskly/core/utils/routes_manager.dart';
import 'package:taskly/l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://bztszvzfcnbfmsxkhkhn.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImJ6dHN6dnpmY25iZm1zeGtoa2huIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTY2Njc1NzcsImV4cCI6MjA3MjI0MzU3N30.wErI53sqLbmnK_WXe3oJhuYffS7Xcl9yGne1arhhLoA',
  );
   await SharedPrefHelper.init();
  configureDependencies();
    Bloc.observer = MyBlocObserver();
  runApp(const Taskly());
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

          theme: AppTheme.lightTheme,

          onGenerateRoute:
              (settings) => RoutesManager.onGenerateRoute(settings),
          initialRoute: RoutesManager.clientHome,
        );
      },
    );
  }
}
