import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Brand Identity Colors
  static const Color maroon = Color(0xFF650012); // Premium Maroon
  static const Color cream = Color(0xFFFCF9F4);  // Warm Cream Background
  static const Color deepGreen = Color(0xFF1F6B3E); // Royal Green
  static const Color softGrey = Color(0xFFE5E5E5);
  
  // Status Colors (Editorial & Premium)
  static const Color statusAvailable = deepGreen;
  static const Color statusOccupied = Color(0xFFC27D0E); // Deep Gold/Amber
  static const Color statusBilling = maroon;
  static const Color darkBg = Color(0xFF1A1A1A);
  
  // Color Aliases for legacy code and status
  static const Color successGreen = deepGreen;
  static const Color occupiedOrange = statusOccupied;
  static const Color billingBlue = Color(0xFF1F4E6B); // Deep Steel Blue
  static const Color primaryRed = maroon;

  // Premium Button Style (Editorial look)
  static final _buttonStyle = ElevatedButton.styleFrom(
    backgroundColor: maroon,
    foregroundColor: Colors.white,
    minimumSize: const Size(64, 56), 
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)), // Sharper corners for editorial feel
    elevation: 0, // Flat design for "No-Line" rule
    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
    textStyle: GoogleFonts.epilogue(
      fontWeight: FontWeight.w600,
      letterSpacing: 0.5,
    ),
  );

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: cream,
      colorScheme: ColorScheme.fromSeed(
        seedColor: maroon,
        primary: maroon,
        secondary: deepGreen,
        surface: Colors.white,
        brightness: Brightness.light,
      ),
      textTheme: GoogleFonts.epilogueTextTheme(),
      elevatedButtonTheme: ElevatedButtonThemeData(style: _buttonStyle),
      cardTheme: CardThemeData(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide.none, // Explicitly no lines
        ),
        elevation: 1, // Minimalist elevation for separation
        margin: const EdgeInsets.all(8),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: cream,
        foregroundColor: maroon,
        elevation: 0,
        titleTextStyle: GoogleFonts.epilogue(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: maroon,
        ),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: maroon,
        primary: maroon,
        secondary: deepGreen,
        brightness: Brightness.dark,
        surface: darkBg,
      ),
      textTheme: GoogleFonts.epilogueTextTheme(ThemeData.dark().textTheme),
      elevatedButtonTheme: ElevatedButtonThemeData(style: _buttonStyle),
      cardTheme: CardThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 1,
      ),
    );
  }
}

