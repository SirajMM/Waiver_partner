import 'package:flutter/material.dart';

import '../colors/app_colors.dart';



class AppTheme {
  // static ThemeData darkTheme = ThemeData.dark().copyWith(
  //     primaryColor: AppColors.black10,
  //     canvasColor: AppColors.black10,
  //     indicatorColor: AppColors.grey155,
  //     dropdownMenuTheme: DropdownMenuThemeData(
  //         inputDecorationTheme:
  //             InputDecorationTheme(filled: true, fillColor: AppColors.black10)),
  //     expansionTileTheme: ExpansionTileThemeData(
  //         collapsedTextColor: AppColors.white,
  //         iconColor: AppColors.white,
  //         collapsedIconColor: AppColors.white,
  //         textColor: AppColors.white),
  //     textTheme: TextTheme(
  //       displayLarge: TextStyle(color: AppColors.white),
  //       displayMedium: TextStyle(color: AppColors.white),
  //       displaySmall: TextStyle(color: AppColors.white),
  //       headlineLarge: TextStyle(color: AppColors.white),
  //       headlineMedium: TextStyle(color: AppColors.white),
  //       titleLarge: TextStyle(color: AppColors.white),
  //       headlineSmall: TextStyle(color: AppColors.white),
  //       titleMedium: TextStyle(color: AppColors.white),
  //       titleSmall: TextStyle(color: AppColors.white),
  //       bodyLarge: TextStyle(color: AppColors.white),
  //       bodyMedium: TextStyle(color: AppColors.white),
  //       bodySmall: TextStyle(color: AppColors.white),
  //       labelLarge: TextStyle(color: AppColors.white),
  //       labelMedium: TextStyle(color: AppColors.white),
  //       labelSmall: TextStyle(color: AppColors.white),
  //     ),
  //     scaffoldBackgroundColor: AppColors.black10,
  //     bottomSheetTheme: BottomSheetThemeData(
  //       backgroundColor: Colors.transparent,
  //       surfaceTintColor: Colors.transparent,
  //     ));
  static ThemeData lightTheme = ThemeData(
      scaffoldBackgroundColor: AppColors.white,
      primaryColor: AppColors.white,
      canvasColor: AppColors.white,
      indicatorColor: AppColors.black10,
      expansionTileTheme: ExpansionTileThemeData(
          collapsedTextColor: AppColors.black,
          iconColor: AppColors.grey93,
          collapsedIconColor: AppColors.grey93,
          textColor: AppColors.black),
      textTheme: TextTheme(
        displayLarge: TextStyle(color: AppColors.black),
        displayMedium: TextStyle(color: AppColors.black),
        displaySmall: TextStyle(color: AppColors.black),
        headlineLarge: TextStyle(color: AppColors.black),
        headlineMedium: TextStyle(color: AppColors.black),
        titleLarge: TextStyle(color: AppColors.black),
        headlineSmall: TextStyle(color: AppColors.black),
        titleMedium: TextStyle(color: AppColors.black),
        titleSmall: TextStyle(color: AppColors.black),
        bodyLarge: TextStyle(color: AppColors.black),
        bodyMedium: TextStyle(color: AppColors.black),
        bodySmall: TextStyle(color: AppColors.black),
        labelLarge: TextStyle(color: AppColors.black),
        labelMedium: TextStyle(color: AppColors.black),
        labelSmall: TextStyle(color: AppColors.black),
      ),
      dropdownMenuTheme: DropdownMenuThemeData(
          inputDecorationTheme:
              InputDecorationTheme(filled: true, fillColor: AppColors.white)),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
      ));
}
