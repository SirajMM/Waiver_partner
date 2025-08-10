import 'package:flutter/material.dart';
import 'package:waiver_driver/core/themes/text_style/test_style.dart';

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
          textColor: AppColors.black
      ),
      textTheme: TextTheme(
        // Display styles (largest text)
        displayLarge: albertSansExtraBlack.copyWith(fontSize: 57),
        displayMedium: albertSansBold.copyWith(fontSize: 45),
        displaySmall: albertSansSemiBold.copyWith(fontSize: 36),

        // Headline styles
        headlineLarge: albertSansBold.copyWith(fontSize: 32),
        headlineMedium: albertSansMedium.copyWith(fontSize: 28),
        headlineSmall: albertSansMedium.copyWith(fontSize: 24),

        // Title styles
        titleLarge: albertSansMedium.copyWith(fontSize: 22),
        titleMedium: albertSansRegular.copyWith(fontSize: 16, fontWeight: FontWeight.w500),
        titleSmall: albertSansRegular.copyWith(fontSize: 14, fontWeight: FontWeight.w500),

        // Body styles (most common text)
        bodyLarge: albertSansRegular.copyWith(fontSize: 16),
        bodyMedium: albertSansRegular.copyWith(fontSize: 14),
        bodySmall: albertSansRegular.copyWith(fontSize: 12),

        // Label styles (buttons, tabs, etc.)
        labelLarge: albertSansMedium.copyWith(fontSize: 14),
        labelMedium: albertSansMedium.copyWith(fontSize: 12),
        labelSmall: albertSansMedium.copyWith(fontSize: 11),
      ),
      dropdownMenuTheme: DropdownMenuThemeData(
          inputDecorationTheme: InputDecorationTheme(
              filled: true,
              fillColor: AppColors.white
          )
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
      )
  );
}
