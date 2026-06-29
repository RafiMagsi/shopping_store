import 'package:flutter/material.dart';

enum AppThemePreset { minimalLuxury, nordicClean, organicBotanical }

const AppThemePreset activeThemePreset = AppThemePreset.organicBotanical;

@immutable
class AppThemePalette {
  final AppThemePreset preset;
  final ColorScheme scheme;
  final Color bg;
  final Color surface;
  final Color card;
  final Color cardElevated;
  final Color divider;
  final Color textPrimary;
  final Color textSecondary;
  final Color textMuted;
  final Color textInverse;
  final Color glass;
  final Color glassBorder;
  final Color glassHighlight;
  final Color champagne;
  final Color champagneDeep;
  final Color champagneLight;
  final Color champagneMuted;
  final Color rose;
  final Color roseDeep;
  final Color roseMuted;
  final Color ice;
  final Color iceDeep;
  final Color iceMuted;
  final Color sage;
  final Color sageMuted;
  final LinearGradient goldGradient;
  final LinearGradient heroGradient;
  final LinearGradient cardGradient;
  final LinearGradient flashGradient;
  final LinearGradient violetGradient;

  const AppThemePalette({
    required this.preset,
    required this.scheme,
    required this.bg,
    required this.surface,
    required this.card,
    required this.cardElevated,
    required this.divider,
    required this.textPrimary,
    required this.textSecondary,
    required this.textMuted,
    required this.textInverse,
    required this.glass,
    required this.glassBorder,
    required this.glassHighlight,
    required this.champagne,
    required this.champagneDeep,
    required this.champagneLight,
    required this.champagneMuted,
    required this.rose,
    required this.roseDeep,
    required this.roseMuted,
    required this.ice,
    required this.iceDeep,
    required this.iceMuted,
    required this.sage,
    required this.sageMuted,
    required this.goldGradient,
    required this.heroGradient,
    required this.cardGradient,
    required this.flashGradient,
    required this.violetGradient,
  });
}

class AppThemePresets {
  AppThemePresets._();

  static const minimalLuxury = AppThemePalette(
    preset: AppThemePreset.minimalLuxury,
    scheme: ColorScheme.light(
      surface: Color(0xFFFFFFFF),
      primary: Color(0xFF191919),
      onPrimary: Color(0xFFFFFFFF),
      secondary: Color(0xFF9E8A78),
      onSecondary: Color(0xFFFFFFFF),
      error: Color(0xFFBC4749),
      onError: Color(0xFFFFFFFF),
      onSurface: Color(0xFF2B2B2B),
    ),
    bg: Color(0xFFFCFBFA),
    surface: Color(0xFFFFFFFF),
    card: Color(0xFFFFFEFD),
    cardElevated: Color(0xFFF7F2EC),
    divider: Color(0xFFE9E1D9),
    textPrimary: Color(0xFF2B2B2B),
    textSecondary: Color(0xFF62584F),
    textMuted: Color(0xFFA19386),
    textInverse: Color(0xFFFFFFFF),
    glass: Color(0xD9FFFFFF),
    glassBorder: Color(0x2B9E8A78),
    glassHighlight: Color(0xB8FFFFFF),
    champagne: Color(0xFF9E8A78),
    champagneDeep: Color(0xFF766556),
    champagneLight: Color(0xFFD7C7B8),
    champagneMuted: Color(0xFFF3EAE1),
    rose: Color(0xFFBC4749),
    roseDeep: Color(0xFF9F3C3E),
    roseMuted: Color(0xFFF6E6E6),
    ice: Color(0xFF6C7280),
    iceDeep: Color(0xFF4F5560),
    iceMuted: Color(0xFFEAECEF),
    sage: Color(0xFF8F9786),
    sageMuted: Color(0xFFEAEDE7),
    goldGradient: LinearGradient(
      colors: [Color(0xFF766556), Color(0xFF9E8A78), Color(0xFFD7C7B8)],
      stops: [0.0, 0.58, 1.0],
    ),
    heroGradient: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [Color(0xFFFFFEFD), Color(0xFFF8F3EE), Color(0xFFF1E8DF)],
    ),
    cardGradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFFFFFFFF), Color(0xFFF6F0EA)],
    ),
    flashGradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFFFBF6F2), Color(0xFFF1E5DE)],
    ),
    violetGradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFF4F5560), Color(0xFF6C7280)],
    ),
  );

  static const nordicClean = AppThemePalette(
    preset: AppThemePreset.nordicClean,
    scheme: ColorScheme.light(
      surface: Color(0xFFFFFFFF),
      primary: Color(0xFF0F172A),
      onPrimary: Color(0xFFFFFFFF),
      secondary: Color(0xFF475569),
      onSecondary: Color(0xFFFFFFFF),
      error: Color(0xFFD97706),
      onError: Color(0xFFFFFFFF),
      onSurface: Color(0xFF1E293B),
    ),
    bg: Color(0xFFF4F6F8),
    surface: Color(0xFFFFFFFF),
    card: Color(0xFFFFFFFF),
    cardElevated: Color(0xFFEDEFF3),
    divider: Color(0xFFDCE3EA),
    textPrimary: Color(0xFF1E293B),
    textSecondary: Color(0xFF526071),
    textMuted: Color(0xFF94A3B8),
    textInverse: Color(0xFFFFFFFF),
    glass: Color(0xD9FFFFFF),
    glassBorder: Color(0x33475569),
    glassHighlight: Color(0xB8FFFFFF),
    champagne: Color(0xFF475569),
    champagneDeep: Color(0xFF334155),
    champagneLight: Color(0xFFCBD5E1),
    champagneMuted: Color(0xFFEFF3F7),
    rose: Color(0xFFD97706),
    roseDeep: Color(0xFFB86200),
    roseMuted: Color(0xFFF9ECDA),
    ice: Color(0xFF64748B),
    iceDeep: Color(0xFF475569),
    iceMuted: Color(0xFFE8EEF4),
    sage: Color(0xFF7A8798),
    sageMuted: Color(0xFFE9EEF2),
    goldGradient: LinearGradient(
      colors: [Color(0xFF0F172A), Color(0xFF475569), Color(0xFFCBD5E1)],
      stops: [0.0, 0.58, 1.0],
    ),
    heroGradient: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [Color(0xFFFBFCFD), Color(0xFFF0F4F7), Color(0xFFE7EDF3)],
    ),
    cardGradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFFFFFFFF), Color(0xFFF1F5F9)],
    ),
    flashGradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFFF8FAFC), Color(0xFFECEFF4)],
    ),
    violetGradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFF334155), Color(0xFF64748B)],
    ),
  );

  static const organicBotanical = AppThemePalette(
    preset: AppThemePreset.organicBotanical,
    scheme: ColorScheme.light(
      surface: Color(0xFFFFFFFF),
      primary: Color(0xFF2C3E35),
      onPrimary: Color(0xFFFFFFFF),
      secondary: Color(0xFF8A9A86),
      onSecondary: Color(0xFFFFFFFF),
      error: Color(0xFFB86B5C),
      onError: Color(0xFFFFFFFF),
      onSurface: Color(0xFF222825),
    ),
    bg: Color(0xFFF7F8F6),
    surface: Color(0xFFFFFFFF),
    card: Color(0xFFFFFEFC),
    cardElevated: Color(0xFFF0F3ED),
    divider: Color(0xFFDDE4DC),
    textPrimary: Color(0xFF222825),
    textSecondary: Color(0xFF556059),
    textMuted: Color(0xFF97A095),
    textInverse: Color(0xFFFFFFFF),
    glass: Color(0xD9FFFFFF),
    glassBorder: Color(0x338A9A86),
    glassHighlight: Color(0xB8FFFFFF),
    champagne: Color(0xFF8A9A86),
    champagneDeep: Color(0xFF62705E),
    champagneLight: Color(0xFFC9D2C6),
    champagneMuted: Color(0xFFEAF0E8),
    rose: Color(0xFFB86B5C),
    roseDeep: Color(0xFF965548),
    roseMuted: Color(0xFFF4E4DF),
    ice: Color(0xFF6D7B73),
    iceDeep: Color(0xFF526058),
    iceMuted: Color(0xFFE7ECE8),
    sage: Color(0xFF8A9A86),
    sageMuted: Color(0xFFEAF0E8),
    goldGradient: LinearGradient(
      colors: [Color(0xFF2C3E35), Color(0xFF8A9A86), Color(0xFFC9D2C6)],
      stops: [0.0, 0.58, 1.0],
    ),
    heroGradient: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [Color(0xFFFBFCFA), Color(0xFFF0F4EF), Color(0xFFE7ECE6)],
    ),
    cardGradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFFFFFFFF), Color(0xFFF1F5F0)],
    ),
    flashGradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFFF8FAF7), Color(0xFFECEFE9)],
    ),
    violetGradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFF526058), Color(0xFF6D7B73)],
    ),
  );

  static AppThemePalette get current {
    switch (activeThemePreset) {
      case AppThemePreset.minimalLuxury:
        return minimalLuxury;
      case AppThemePreset.nordicClean:
        return nordicClean;
      case AppThemePreset.organicBotanical:
        return organicBotanical;
    }
  }
}
