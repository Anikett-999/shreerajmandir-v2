import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Exact Logo Brand Colors
  static const Color primaryRed = Color(0xFFC62828); // Rajmandir Red
  static const Color brandGreen = Color(0xFF2E7D32); // Rajmandir Green
  
  // Status Colors (Thumb Friendly & Waiter readable)
  static const Color availableGreen = Color(0xFF4CAF50);
  static const Color occupiedOrange = Color(0xFFFF9800);
  static const Color billingBlue = Color(0xFF2196F3);
  static const Color darkBg = Color(0xFF121212);

  // Common Button Style for Thumb Friendliness (54px tall, rounded)
  static final _buttonStyle = ElevatedButton.styleFrom(
    minimumSize: const Size(64, 56), // Very thumb-friendly 56px height
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
  );

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryRed,
        primary: primaryRed,
        secondary: brandGreen,
        brightness: Brightness.light,
      ),
      textTheme: GoogleFonts.outfitTextTheme(),
      elevatedButtonTheme: ElevatedButtonThemeData(style: _buttonStyle),
      cardTheme: CardThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 4,
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryRed,
        primary: primaryRed,
        secondary: brandGreen,
        brightness: Brightness.dark,
        surface: darkBg,
      ),
      textTheme: GoogleFonts.outfitTextTheme(ThemeData.dark().textTheme),
      elevatedButtonTheme: ElevatedButtonThemeData(style: _buttonStyle),
      cardTheme: CardThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 4,
      ),
    );
  }
}
