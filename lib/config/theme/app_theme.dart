import 'package:flutter/material.dart';
import 'package:taskly/core/utils/colors_manger.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    fontFamily: "Cairo",
    primaryColor: ColorsManager.primary,
    scaffoldBackgroundColor: ColorsManager.background,
    appBarTheme: const AppBarTheme(
      backgroundColor: ColorsManager.primary,
      elevation: 0,
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: 20,
      ),
      iconTheme: IconThemeData(color: Colors.white),
    ),
    textTheme: const TextTheme(
      headlineLarge: TextStyle(
        color: ColorsManager.textPrimary,
        fontSize: 24,
        fontWeight: FontWeight.bold,
      ),
      bodyLarge: TextStyle(color: ColorsManager.textSecondary, fontSize: 16),
      bodyMedium: TextStyle(color: ColorsManager.textSecondary, fontSize: 14),
    ),
    // checkboxTheme: CheckboxThemeData(
    //   overlayColor: MaterialStateProperty.all(ColorsManager.black),

 
      
    //   ),
    colorScheme: ColorScheme.fromSwatch().copyWith(
      secondary: ColorsManager.accent,
    ),
  );

  static ThemeData darkTheme = ThemeData(
    fontFamily: "Cairo",
    primaryColor: ColorsManager.primary,
    scaffoldBackgroundColor: Colors.black,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.black,
      elevation: 0,
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: 20,
      ),
      iconTheme: IconThemeData(color: Colors.white),
    ),
    textTheme: const TextTheme(
      headlineLarge: TextStyle(
        color: Colors.white,
        fontSize: 24,
        fontWeight: FontWeight.bold,
      ),
      bodyLarge: TextStyle(color: Colors.grey, fontSize: 16),
      bodyMedium: TextStyle(color: Colors.grey, fontSize: 14),
    ),
    // checkboxTheme: CheckboxThemeData(
    //   overlayColor: MaterialStateProperty.all(ColorsManager.white),),
    colorScheme: ColorScheme.fromSwatch().copyWith(
      secondary: ColorsManager.accent,
      brightness: Brightness.dark,
    ),
  );

  static var textTheme;
}
