import 'package:ben_kimim/core/configs/theme/app_color.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static final appTheme = ThemeData(
    scaffoldBackgroundColor: Colors.white,
    primaryColor: AppColors.primary,
    appBarTheme: AppBarTheme(
      
      backgroundColor: AppColors.primary,
      centerTitle: true,
      titleTextStyle: GoogleFonts.fredoka(
        color: Colors.white,
        fontSize: 30,
        fontWeight: FontWeight.w700,
      ),
    ),
    textTheme: GoogleFonts.fredokaTextTheme(), // 🎨 Tüm metinlere uygula
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        textStyle: GoogleFonts.fredoka(
          fontSize: 18,
          fontWeight: FontWeight.w700,
        ),
      ),
    ),
  );
}
