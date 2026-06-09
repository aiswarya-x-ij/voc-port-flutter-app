import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // VOC Port Authority Brand Colors
  static const Color vocNavy = Color(0xFF1A237E);       // Deep navy - primary
  static const Color vocBlue = Color(0xFF283593);        // Brand blue
  static const Color vocLightBlue = Color(0xFF3949AB);   // Lighter blue
  static const Color vocAccent = Color(0xFF5C6BC0);      // Accent indigo
  static const Color vocGreen = Color(0xFF2E7D32);       // Driver portal green
  static const Color vocLightGreen = Color(0xFF388E3C);
  static const Color vocGrey = Color(0xFF546E7A);
  static const Color vocLightGrey = Color(0xFFF5F6FA);
  static const Color vocWhite = Color(0xFFFFFFFF);
  static const Color vocSurface = Color(0xFFF8F9FE);
  static const Color vocBorder = Color(0xFFE3E8F7);
  static const Color vocError = Color(0xFFD32F2F);
  static const Color vocWarning = Color(0xFFF57C00);
  static const Color vocSuccess = Color(0xFF2E7D32);

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: vocNavy,
        brightness: Brightness.light,
        primary: vocNavy,
        secondary: vocAccent,
        surface: vocSurface,
        error: vocError,
      ),
      textTheme: GoogleFonts.interTextTheme().copyWith(
        displayLarge: GoogleFonts.inter(
          fontSize: 32, fontWeight: FontWeight.w700, color: vocNavy,
        ),
        displayMedium: GoogleFonts.inter(
          fontSize: 24, fontWeight: FontWeight.w700, color: vocNavy,
        ),
        displaySmall: GoogleFonts.inter(
          fontSize: 20, fontWeight: FontWeight.w600, color: vocNavy,
        ),
        headlineLarge: GoogleFonts.inter(
          fontSize: 18, fontWeight: FontWeight.w600, color: vocNavy,
        ),
        headlineMedium: GoogleFonts.inter(
          fontSize: 16, fontWeight: FontWeight.w600, color: vocNavy,
        ),
        bodyLarge: GoogleFonts.inter(
          fontSize: 14, fontWeight: FontWeight.w400, color: Color(0xFF1A1A2E),
        ),
        bodyMedium: GoogleFonts.inter(
          fontSize: 13, fontWeight: FontWeight.w400, color: vocGrey,
        ),
        labelLarge: GoogleFonts.inter(
          fontSize: 14, fontWeight: FontWeight.w600, color: vocWhite,
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: vocNavy,
        foregroundColor: vocWhite,
        elevation: 0,
        titleTextStyle: GoogleFonts.inter(
          fontSize: 16, fontWeight: FontWeight.w600, color: vocWhite,
        ),
        iconTheme: const IconThemeData(color: vocWhite),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: vocNavy,
          foregroundColor: vocWhite,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          textStyle: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600),
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: vocWhite,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: vocBorder, width: 1),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: vocLightGrey,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: vocBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: vocBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: vocNavy, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: vocError),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        labelStyle: GoogleFonts.inter(fontSize: 13, color: vocGrey),
        hintStyle: GoogleFonts.inter(fontSize: 13, color: Color(0xFFADB5BD)),
      ),
      scaffoldBackgroundColor: vocSurface,
      dividerColor: vocBorder,
    );
  }
}
