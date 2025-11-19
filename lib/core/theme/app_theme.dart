import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const primaryCandidates = [
  Color(0xFFF3FF47),
  Color(0xFFFF6B6B),
  Color(0xFF4ECDC4),
  Color(0xFF5B8DEF),
];

class AppTheme {
  static ThemeData light(Color primary) {
    final base = ThemeData.light(useMaterial3: true);
    return base.copyWith(
      colorScheme: ColorScheme.fromSeed(
        seedColor: primary,
        primary: primary,
        brightness: Brightness.light,
      ),
      scaffoldBackgroundColor: Colors.white,
      textTheme: GoogleFonts.outfitTextTheme(base.textTheme),
      appBarTheme: const AppBarTheme(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.black,
          backgroundColor: primary,
          shape: const StadiumBorder(),
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shadowColor: primary.withOpacity(.4),
        ),
      ),
    );
  }

  static ThemeData dark(Color primary) {
    final base = ThemeData.dark(useMaterial3: true);
    return base.copyWith(
      colorScheme: ColorScheme.fromSeed(
        seedColor: primary,
        primary: primary,
        brightness: Brightness.dark,
      ),
      textTheme: GoogleFonts.outfitTextTheme(base.textTheme)
          .apply(bodyColor: Colors.white, displayColor: Colors.white),
      scaffoldBackgroundColor: Colors.black,
      appBarTheme: const AppBarTheme(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
      ),
    );
  }
}

BoxDecoration gradientBackground(Color primary) => BoxDecoration(
      gradient: LinearGradient(
        colors: [Colors.white, primary.withOpacity(.7)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    );
