import 'package:flutter/material.dart';

class AppColors {
  static const background = Color(0xFF15121C);
  static const surface = Color(0xFF221D2C);
  static const surfaceHigh = Color(0xFF2E2739);
  static const gold = Color(0xFFD9A441);
  static const crimson = Color(0xFFB8333A);
  static const text = Color(0xFFF1EADB);
  static const textMuted = Color(0xFFA79FB3);
}

ThemeData buildAppTheme() {
  final base = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.gold,
      brightness: Brightness.dark,
      primary: AppColors.gold,
      secondary: AppColors.crimson,
      surface: AppColors.surface,
    ),
    scaffoldBackgroundColor: AppColors.background,
  );

  return base.copyWith(
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.background,
      foregroundColor: AppColors.text,
      elevation: 0,
      centerTitle: false,
    ),
    cardTheme: CardThemeData(
      color: AppColors.surface,
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      clipBehavior: Clip.antiAlias,
    ),
    textTheme: base.textTheme.apply(
      bodyColor: AppColors.text,
      displayColor: AppColors.text,
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: AppColors.gold,
        foregroundColor: AppColors.background,
        minimumSize: const Size.fromHeight(52),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    ),
  );
}

/// 1250 -> "₺1.250"
String formatPrice(double value) {
  final digits = value.round().toString();
  final buffer = StringBuffer();
  for (int i = 0; i < digits.length; i++) {
    final remaining = digits.length - i;
    buffer.write(digits[i]);
    if (remaining > 1 && remaining % 3 == 1) buffer.write('.');
  }
  return '₺$buffer';
}
