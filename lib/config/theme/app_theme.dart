import 'package:flutter/material.dart';
import 'package:taskly/core/utils/colors_manger.dart';
import 'package:taskly/core/utils/app_text_styles.dart';

class AppTheme {
  /// Light Theme
  static ThemeData lightTheme = ThemeData(
    fontFamily: "Cairo",
    primaryColor: ColorsManager.primary,
    scaffoldBackgroundColor: ColorsManager.background,
    appBarTheme: AppBarTheme(
      backgroundColor: ColorsManager.primary,
      elevation: 0,
      titleTextStyle: AppTextStyles.bold20.copyWith(color: Colors.white),
      iconTheme: const IconThemeData(color: Colors.white),
    ),
    cardColor: ColorsManager.card,
    textTheme: TextTheme(
      headlineLarge: AppTextStyles.bold24.copyWith(color: ColorsManager.textPrimary),
      headlineSmall: AppTextStyles.bold16.copyWith(color: ColorsManager.textPrimary),
      bodyLarge: AppTextStyles.regular16.copyWith(color: ColorsManager.textSecondary),
      bodyMedium: AppTextStyles.regular14.copyWith(color: ColorsManager.textSecondary),
      bodySmall: AppTextStyles.regular12.copyWith(color: ColorsManager.textSecondary),
    ),
    colorScheme: ColorScheme.fromSwatch().copyWith(
      secondary: ColorsManager.accent,
      brightness: Brightness.light,
    ),
  );

  /// Dark Theme
  static ThemeData darkTheme = ThemeData(
    fontFamily: "Cairo",
    primaryColor: ColorsManager.primary,
    scaffoldBackgroundColor: Colors.black,
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.black,
      elevation: 0,
      titleTextStyle: AppTextStyles.bold20.copyWith(color: Colors.white),
      iconTheme: const IconThemeData(color: Colors.white),
    ),
    cardColor: ColorsManager.black,
    textTheme: TextTheme(
      headlineLarge: AppTextStyles.bold24.copyWith(color: Colors.white),
      headlineSmall: AppTextStyles.bold16.copyWith(color: Colors.white),
      bodyLarge: AppTextStyles.regular16.copyWith(color: Colors.grey[300]),
      bodyMedium: AppTextStyles.regular14.copyWith(color: Colors.grey[400]),
      bodySmall: AppTextStyles.regular12.copyWith(color: Colors.grey[500]),
    ),
    colorScheme: ColorScheme.fromSwatch().copyWith(
      secondary: ColorsManager.accent,
      brightness: Brightness.dark,
    ),
  );
}
