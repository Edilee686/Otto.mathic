import 'package:flutter/material.dart';

/// Light, soft palette (refreshed 31 Oct 2026 at Edi's request: more
/// contemporary and easier on the eye). Never red for mistakes.
class Palette {
  // Backgrounds: a gentle lavender-to-peach wash.
  static const bgTop = Color(0xFFF3EFFF);
  static const bgBottom = Color(0xFFFFF4EC);
  static const surface = Colors.white;
  static const lilac = Color(0xFFEDE7FF); // tinted chips, tracks

  // Text.
  static const ink = Color(0xFF2B2550);
  static const inkSoft = Color(0xFF6E6890);

  // Brand and feedback.
  static const violet = Color(0xFF7B5CF0); // Otto, primary actions
  static const violetDeep = Color(0xFF5A3FD1);
  static const sun = Color(0xFFFFB938); // stars, coins, highlights
  static const mint = Color(0xFF2FC394); // success
  static const coral = Color(0xFFFF8A6B); // try again
  static const sky = Color(0xFF55B6F2);
  static const pink = Color(0xFFFF8FC6);
}

/// Rubik is a variable font; set the weight axis so bold really is bold.
TextStyle rubik(double size, {FontWeight weight = FontWeight.w500, Color? color, double? height}) =>
    TextStyle(
      fontFamily: 'Rubik',
      fontSize: size,
      fontWeight: weight,
      fontVariations: [FontVariation('wght', weight.value.toDouble())],
      color: color ?? Palette.ink,
      height: height,
    );

/// Soft card shadow used across the app.
const softShadow = [
  BoxShadow(color: Color(0x1A5A3FD1), blurRadius: 24, offset: Offset(0, 8)),
];

ThemeData buildTheme() {
  final base = ThemeData(
    useMaterial3: true,
    fontFamily: 'Rubik',
    colorScheme: ColorScheme.fromSeed(
      seedColor: Palette.violet,
      surface: Palette.bgTop,
      primary: Palette.violet,
      onPrimary: Colors.white,
      secondary: Palette.sun,
      error: Palette.coral,
    ),
    scaffoldBackgroundColor: Palette.bgTop,
  );
  final pill = RoundedRectangleBorder(borderRadius: BorderRadius.circular(30));
  return base.copyWith(
    textTheme: base.textTheme.apply(fontFamily: 'Rubik', bodyColor: Palette.ink, displayColor: Palette.ink),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      foregroundColor: Palette.ink,
      elevation: 0,
      scrolledUnderElevation: 0,
    ),
    iconTheme: const IconThemeData(color: Palette.ink),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: Palette.violet,
        foregroundColor: Colors.white,
        disabledBackgroundColor: Palette.violet.withValues(alpha: 0.3),
        disabledForegroundColor: Colors.white,
        minimumSize: const Size(160, 60),
        padding: const EdgeInsets.symmetric(horizontal: 28),
        textStyle: rubik(22, weight: FontWeight.w700),
        shape: pill,
        elevation: 0,
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: Palette.violet,
        minimumSize: const Size(140, 60),
        padding: const EdgeInsets.symmetric(horizontal: 24),
        side: const BorderSide(color: Palette.lilac, width: 2),
        textStyle: rubik(20, weight: FontWeight.w700),
        shape: pill,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      hintStyle: rubik(24, color: Palette.inkSoft.withValues(alpha: 0.5)),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(24),
        borderSide: const BorderSide(color: Palette.lilac, width: 2),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(24),
        borderSide: const BorderSide(color: Palette.lilac, width: 2),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(24),
        borderSide: const BorderSide(color: Palette.violet, width: 2),
      ),
    ),
  );
}
