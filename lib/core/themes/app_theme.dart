
import 'package:flutter/material.dart';
import 'package:lmart/core/colors/app_colors.dart';
import 'package:lmart/core/fonts/app_fonts.dart';

class AppThemes{
  AppThemes._();

  ///[lightMode]
  static final ThemeData lightMode = ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.scaffoldColor,

      elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        textStyle: AppFonts.proximaNova12Regular,
        foregroundColor: AppColors.white_1,
        backgroundColor: AppColors.white_1,
        minimumSize: const Size(130.0, 34.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    ),
    
    appBarTheme: AppBarTheme(color: AppColors.scaffoldColor),

    buttonTheme: ButtonThemeData(
       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0)),
       splashColor: AppColors.secondaryColor,
       buttonColor: AppColors.primaryColor,
       height: 34.0,
       highlightColor: Colors.green,
       textTheme: ButtonTextTheme.normal,
     ),
       textTheme: const TextTheme(
       bodyLarge:AppFonts.proximaNova22Regular,
       bodyMedium:AppFonts.proximaNova16Regular,
       bodySmall:AppFonts.proximaNova12Regular,
     ),

    inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: AppColors.white_1,
    labelStyle: AppFonts.proximaNova12Regular.copyWith(color: AppColors.primaryColor),
    hintStyle: AppFonts.proximaNova12Regular.copyWith(color: AppColors.secondaryColor),
    errorStyle: AppFonts.proximaNova12Regular.copyWith(color: Colors.red),
    contentPadding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(25.0),
      borderSide: BorderSide(color: AppColors.primaryColor),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(25.0),
      borderSide: BorderSide(color: AppColors.primaryColor),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(25.0),
      borderSide: BorderSide(color: AppColors.secondaryColor),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(25.0),
      borderSide: const BorderSide(color: Colors.red),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(25.0),
      borderSide: const BorderSide(color: Colors.redAccent),
    ),
  ),
  );

  ///[darkMode]
  static final ThemeData darkMode = lightMode.copyWith(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.scaffoldColor,
  );
}