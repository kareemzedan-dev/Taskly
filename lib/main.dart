import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:taskly/core/theme/app_theme.dart';

import 'package:taskly/core/utils/routes_manager.dart';
import 'package:taskly/l10n/app_localizations.dart';

void main() {
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
          initialRoute: RoutesManager.welcome,
        );
      },
    );
  }
}
