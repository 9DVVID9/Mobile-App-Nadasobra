import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTheme {
  static ThemeData get theme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.cream,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.teal,
        surface: AppColors.cream,
      ),
      textTheme: _buildTextTheme(),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: AppColors.dark.withValues(alpha: 0.08), width: 1.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: AppColors.dark.withValues(alpha: 0.08), width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: AppColors.teal, width: 2),
        ),
      ),
    );
  }

  static TextTheme _buildTextTheme() {
    return TextTheme(
      // Display: Fredoka SemiBold — section titles, screen headings
      displayLarge: GoogleFonts.fredoka(fontSize: 32, fontWeight: FontWeight.w600, color: AppColors.dark),
      displayMedium: GoogleFonts.fredoka(fontSize: 26, fontWeight: FontWeight.w600, color: AppColors.dark),
      displaySmall: GoogleFonts.fredoka(fontSize: 20, fontWeight: FontWeight.w600, color: AppColors.dark),
      // Headlines: Fredoka SemiBold — card titles
      headlineMedium: GoogleFonts.fredoka(fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.dark),
      headlineSmall: GoogleFonts.fredoka(fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.dark),
      // Body: Inter — secondary text, descriptions
      bodyLarge: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w400, color: AppColors.dark),
      bodyMedium: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w400, color: AppColors.muted),
      bodySmall: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w400, color: AppColors.muted),
      // Labels: Fredoka — chips, badges, nav labels
      labelLarge: GoogleFonts.fredoka(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.dark),
      labelMedium: GoogleFonts.fredoka(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.dark),
      labelSmall: GoogleFonts.fredoka(fontSize: 11, fontWeight: FontWeight.w400, color: AppColors.muted),
    );
  }
}
