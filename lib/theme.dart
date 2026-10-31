import 'package:flutter/material.dart';

/// Palette from the spec: an evening circus, never red for mistakes.
class Palette {
  static const night = Color(0xFF2B2D5C);
  static const nightDeep = Color(0xFF1E1F45);
  static const violet = Color(0xFF8C6BD9);
  static const marigold = Color(0xFFF5B53F);
  static const mint = Color(0xFF4CC9A0);
  static const coral = Color(0xFFF28A6B);
  static const cream = Color(0xFFFFF6E5);
  static const ink = Color(0xFF2B2D5C);
}

/// Rubik is a variable font; set the weight axis so bold really is bold.
TextStyle rubik(double size, {FontWeight weight = FontWeight.w500, Color? color}) =>
    TextStyle(
      fontFamily: 'Rubik',
      fontSize: size,
      fontWeight: weight,
      fontVariations: [FontVariation('wght', weight.value.toDouble())],
      color: color,
    );

ThemeData buildTheme() {
  final base = ThemeData(
    useMaterial3: true,
    fontFamily: 'Rubik',
    colorScheme: ColorScheme.fromSeed(
      seedColor: Palette.violet,
      brightness: Brightness.dark,
      surface: Palette.night,
      primary: Palette.marigold,
      onPrimary: Palette.ink,
      secondary: Palette.violet,
      error: Palette.coral,
    ),
    scaffoldBackgroundColor: Palette.night,
  );
  return base.copyWith(
    textTheme: base.textTheme.apply(
      fontFamily: 'Rubik',
      bodyColor: Palette.cream,
      displayColor: Palette.cream,
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: Palette.marigold,
        foregroundColor: Palette.ink,
        disabledBackgroundColor: Palette.marigold.withValues(alpha: 0.35),
        minimumSize: const Size(160, 64),
        textStyle: rubik(24, weight: FontWeight.w700),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Palette.cream,
      hintStyle: rubik(24, color: Palette.ink.withValues(alpha: 0.4)),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(24),
        borderSide: BorderSide.none,
      ),
    ),
  );
}
