import 'package:flutter/material.dart';

class AppColors {
  // Basisfarben
  static const Color black = Colors.black87;
  static const Color white = Color(0xFFFFFFFF);
  // Textfarben
  static const Color textGrey = Color(0xFF717182);
  static const Color textBlack = black;

  // Primärfarben
  static const Color primaryRed = Color(0xFFD4183D);

  // Bestätigungsfarben (ConfirmationBanner)
  static const Color confirmGreen = Color(0xFF008800);
  static const Color confirmDarkGreen = Color(0xFF002200);
  static const Color confirmGreenBg = Color(0x1A008800); // ~10% grün
  static const Color confirmGreenBorder = Color(0xB3008800); // ~70% grün

  // Container-Hintergründe / Karten
  static const Color cardBackground = Color(0x08000000); // Schwarz ~3%
  static const Color cardBorder = Color(0x1A000000);     // Schwarz ~10%

  // ConfirmationCourses
  static const Color courseCounterBg = Color(0xFF111122);
  static const Color courseCounterText = white;
  static const Color courseCounterBorder = cardBorder;

  // CourseCard
  static const Color courseSelectedBg = primaryRed;
  static const Color courseUnselectedBg = Colors.black87;
  static const Color courseSelectedEctsBg = black;
  static const Color courseUnselectedEctsBg = Color(0xFFE0E0E0);//helles grau
  static const Color courseSeatsFreeBg = primaryRed;

  // Disabled
  static const Color disabledGrey = Color(0x33000000); // Schwarz 20%
}
