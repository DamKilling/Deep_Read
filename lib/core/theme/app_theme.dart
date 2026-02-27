import 'package:flutter/material.dart';

class AppTheme {
  // Primary colors
  static const Color _primaryColor = Color(0xFF4CAF50); // A fresh green
  // static const Color _secondaryColor = Color(0xFF81C784);
  
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: const Color(0xFFFDFBF7), // Warm paper-like background
      colorScheme: ColorScheme.fromSeed(
        seedColor: _primaryColor,
        brightness: Brightness.light,
        surface: const Color(0xFFFDFBF7),
        primaryContainer: const Color(0xFFE8F5E9), // Light green for highlight
      ),
      appBarTheme: const AppBarTheme(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Color(0xFFFDFBF7),
        foregroundColor: Colors.black87,
        scrolledUnderElevation: 1, // Subtle shadow on scroll
      ),
      cardTheme: const CardThemeData(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: const Color(0xFF121212), // Deep dark for night reading
      colorScheme: ColorScheme.fromSeed(
        seedColor: _primaryColor,
        brightness: Brightness.dark,
        surface: const Color(0xFF121212),
        primaryContainer: const Color(0xFF2E3B32), // Dark green highlight
      ),
      appBarTheme: const AppBarTheme(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Color(0xFF121212),
        scrolledUnderElevation: 1,
      ),
      cardTheme: const CardThemeData(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
      ),
    );
  }
}