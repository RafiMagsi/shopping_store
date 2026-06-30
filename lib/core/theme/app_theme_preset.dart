import 'package:flutter/material.dart';

enum AppThemePreset {
  minimalLuxury,
  nordicClean,
  organicBotanical,
  globalEcommerce,
  midToneCashmere,
  midToneConcrete,
  midToneSage,
}

const AppThemePreset activeThemePreset = AppThemePreset.globalEcommerce;

@immutable
class AppThemePalette {
  final AppThemePreset preset;
  final ColorScheme scheme;
  final Color bg;
  final Color surface;
  final Color card;
  final Color cardElevated;
  final Color frameSurface;
  final Color divider;
  final Color textPrimary;
  final Color textSecondary;
  final Color textMuted;
  final Color textInverse;
  final Color price;
  final Color ratingBg;
  final Color ratingText;
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
    required this.frameSurface,
    required this.divider,
    required this.textPrimary,
    required this.textSecondary,
    required this.textMuted,
    required this.textInverse,
    required this.price,
    required this.ratingBg,
    required this.ratingText,
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
    frameSurface: Color(0xFFF1E9DF),
    divider: Color(0xFFE9E1D9),
    textPrimary: Color(0xFF2B2B2B),
    textSecondary: Color(0xFF62584F),
    textMuted: Color(0xFFA19386),
    textInverse: Color(0xFFFFFFFF),
    price: Color(0xFF766556),
    ratingBg: Color(0xFFF1E5D8),
    ratingText: Color(0xFF6D5848),
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
    frameSurface: Color(0xFFE9EEF5),
    divider: Color(0xFFDCE3EA),
    textPrimary: Color(0xFF1E293B),
    textSecondary: Color(0xFF526071),
    textMuted: Color(0xFF94A3B8),
    textInverse: Color(0xFFFFFFFF),
    price: Color(0xFF0F172A),
    ratingBg: Color(0xFFE8EEF7),
    ratingText: Color(0xFF334155),
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
    frameSurface: Color(0xFFE8EEE7),
    divider: Color(0xFFDDE4DC),
    textPrimary: Color(0xFF222825),
    textSecondary: Color(0xFF556059),
    textMuted: Color(0xFF97A095),
    textInverse: Color(0xFFFFFFFF),
    price: Color(0xFF2C3E35),
    ratingBg: Color(0xFFE8F0EA),
    ratingText: Color(0xFF4E6257),
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

  static const globalEcommerce = AppThemePalette(
    preset: AppThemePreset.globalEcommerce,
    scheme: ColorScheme.light(
      surface: Color(0xFFF8FAFC),
      primary: Color(0xFF0F172A),
      onPrimary: Color(0xFFFFFFFF),
      secondary: Color(0xFF4F46E5),
      onSecondary: Color(0xFFFFFFFF),
      error: Color(0xFFEF4444),
      onError: Color(0xFFFFFFFF),
      onSurface: Color(0xFF1E293B),
    ),
    bg: Color(0xFFFFFFFF),
    surface: Color(0xFFF8FAFC),
    card: Color(0xFFFFFFFF),
    cardElevated: Color(0xFFF1F5F9),
    frameSurface: Color(0xFFEDF2F8),
    divider: Color(0xFFE2E8F0),
    textPrimary: Color(0xFF1E293B),
    textSecondary: Color(0xFF334155),
    textMuted: Color(0xFF64748B),
    textInverse: Color(0xFFFFFFFF),
    price: Color(0xFF0F172A),
    ratingBg: Color(0xFFEEF2FF),
    ratingText: Color(0xFF3730A3),
    glass: Color(0xE6FFFFFF),
    glassBorder: Color(0x334F46E5),
    glassHighlight: Color(0xC2FFFFFF),
    champagne: Color(0xFF4F46E5),
    champagneDeep: Color(0xFF3730A3),
    champagneLight: Color(0xFFC7D2FE),
    champagneMuted: Color(0xFFEEF2FF),
    rose: Color(0xFFEF4444),
    roseDeep: Color(0xFFDC2626),
    roseMuted: Color(0xFFFEE2E2),
    ice: Color(0xFF334155),
    iceDeep: Color(0xFF0F172A),
    iceMuted: Color(0xFFE2E8F0),
    sage: Color(0xFF64748B),
    sageMuted: Color(0xFFF1F5F9),
    goldGradient: LinearGradient(
      colors: [Color(0xFF0F172A), Color(0xFF4F46E5), Color(0xFFC7D2FE)],
      stops: [0.0, 0.58, 1.0],
    ),
    heroGradient: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [Color(0xFFFFFFFF), Color(0xFFF8FAFC), Color(0xFFEEF2FF)],
    ),
    cardGradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFFFFFFFF), Color(0xFFF8FAFC)],
    ),
    flashGradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFFFFFBFB), Color(0xFFFEECEC)],
    ),
    violetGradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFF3730A3), Color(0xFF4F46E5)],
    ),
  );

  static const midToneCashmere = AppThemePalette(
    preset: AppThemePreset.midToneCashmere,
    scheme: ColorScheme.light(
      surface: Color(0xFFEDE9E3),
      primary: Color(0xFF2B2A27),
      onPrimary: Color(0xFFFFFFFF),
      secondary: Color(0xFF9E7E6B),
      onSecondary: Color(0xFFFFFFFF),
      error: Color(0xFF8B3A3A),
      onError: Color(0xFFFFFFFF),
      onSurface: Color(0xFF3D3C38),
    ),
    bg: Color(0xFFE6E2DC),
    surface: Color(0xFFEDE9E3),
    card: Color(0xFFF4F0EA),
    cardElevated: Color(0xFFE1DBD2),
    frameSurface: Color(0xFFE8E1D8),
    divider: Color(0xFFD1C8BE),
    textPrimary: Color(0xFF3D3C38),
    textSecondary: Color(0xFF5C5954),
    textMuted: Color(0xFF8C857C),
    textInverse: Color(0xFFFFFFFF),
    price: Color(0xFF7D6454),
    ratingBg: Color(0xFFE7DDD4),
    ratingText: Color(0xFF6A5548),
    glass: Color(0xD9F6F2EC),
    glassBorder: Color(0x339E7E6B),
    glassHighlight: Color(0xA6FFFFFF),
    champagne: Color(0xFF9E7E6B),
    champagneDeep: Color(0xFF7D6454),
    champagneLight: Color(0xFFD3C1B4),
    champagneMuted: Color(0xFFF1E9E2),
    rose: Color(0xFF8B3A3A),
    roseDeep: Color(0xFF6F2E2E),
    roseMuted: Color(0xFFF2E0E0),
    ice: Color(0xFF706C66),
    iceDeep: Color(0xFF58544F),
    iceMuted: Color(0xFFE5E0DA),
    sage: Color(0xFF8D857B),
    sageMuted: Color(0xFFEAE4DC),
    goldGradient: LinearGradient(
      colors: [Color(0xFF2B2A27), Color(0xFF9E7E6B), Color(0xFFD3C1B4)],
      stops: [0.0, 0.58, 1.0],
    ),
    heroGradient: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [Color(0xFFF0ECE7), Color(0xFFE7E1DA), Color(0xFFDAD2C8)],
    ),
    cardGradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFFF5F1EB), Color(0xFFE7DED4)],
    ),
    flashGradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFFF2ECE5), Color(0xFFE5D8CC)],
    ),
    violetGradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFF7D6454), Color(0xFF9E7E6B)],
    ),
  );

  static const midToneConcrete = AppThemePalette(
    preset: AppThemePreset.midToneConcrete,
    scheme: ColorScheme.light(
      surface: Color(0xFFE5E7EB),
      primary: Color(0xFF1E293B),
      onPrimary: Color(0xFFFFFFFF),
      secondary: Color(0xFF2563EB),
      onSecondary: Color(0xFFFFFFFF),
      error: Color(0xFF991B1B),
      onError: Color(0xFFFFFFFF),
      onSurface: Color(0xFF334155),
    ),
    bg: Color(0xFFD1D5DB),
    surface: Color(0xFFE5E7EB),
    card: Color(0xFFF1F3F5),
    cardElevated: Color(0xFFDDE1E6),
    frameSurface: Color(0xFFE3E8EE),
    divider: Color(0xFFC2C9D1),
    textPrimary: Color(0xFF334155),
    textSecondary: Color(0xFF475569),
    textMuted: Color(0xFF7A8797),
    textInverse: Color(0xFFFFFFFF),
    price: Color(0xFF1E293B),
    ratingBg: Color(0xFFE5EDFA),
    ratingText: Color(0xFF1D4ED8),
    glass: Color(0xD9F8FAFC),
    glassBorder: Color(0x332563EB),
    glassHighlight: Color(0xB8FFFFFF),
    champagne: Color(0xFF2563EB),
    champagneDeep: Color(0xFF1D4ED8),
    champagneLight: Color(0xFFBFDBFE),
    champagneMuted: Color(0xFFEFF6FF),
    rose: Color(0xFF991B1B),
    roseDeep: Color(0xFF7F1D1D),
    roseMuted: Color(0xFFFEE2E2),
    ice: Color(0xFF475569),
    iceDeep: Color(0xFF1E293B),
    iceMuted: Color(0xFFE2E8F0),
    sage: Color(0xFF64748B),
    sageMuted: Color(0xFFE8ECF1),
    goldGradient: LinearGradient(
      colors: [Color(0xFF1E293B), Color(0xFF2563EB), Color(0xFFBFDBFE)],
      stops: [0.0, 0.58, 1.0],
    ),
    heroGradient: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [Color(0xFFF1F4F7), Color(0xFFE2E8EE), Color(0xFFD5DCE4)],
    ),
    cardGradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFFF5F7F9), Color(0xFFE5E7EB)],
    ),
    flashGradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFFF5F6F8), Color(0xFFE3E6EA)],
    ),
    violetGradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFF1D4ED8), Color(0xFF2563EB)],
    ),
  );

  static const midToneSage = AppThemePalette(
    preset: AppThemePreset.midToneSage,
    scheme: ColorScheme.light(
      surface: Color(0xFFE2E8F0),
      primary: Color(0xFF1E293B),
      onPrimary: Color(0xFFFFFFFF),
      secondary: Color(0xFF334155),
      onSecondary: Color(0xFFFFFFFF),
      error: Color(0xFFB45309),
      onError: Color(0xFFFFFFFF),
      onSurface: Color(0xFF1E293B),
    ),
    bg: Color(0xFFCBD5E1),
    surface: Color(0xFFE2E8F0),
    card: Color(0xFFEDF2F7),
    cardElevated: Color(0xFFD9E1EA),
    frameSurface: Color(0xFFE0E7EE),
    divider: Color(0xFFBAC6D3),
    textPrimary: Color(0xFF1E293B),
    textSecondary: Color(0xFF334155),
    textMuted: Color(0xFF64748B),
    textInverse: Color(0xFFFFFFFF),
    price: Color(0xFF1E293B),
    ratingBg: Color(0xFFE3EAF2),
    ratingText: Color(0xFF334155),
    glass: Color(0xD9F8FAFC),
    glassBorder: Color(0x33334155),
    glassHighlight: Color(0xB8FFFFFF),
    champagne: Color(0xFF334155),
    champagneDeep: Color(0xFF1E293B),
    champagneLight: Color(0xFFCBD5E1),
    champagneMuted: Color(0xFFE8EEF5),
    rose: Color(0xFFB45309),
    roseDeep: Color(0xFF92400E),
    roseMuted: Color(0xFFFDE7D2),
    ice: Color(0xFF475569),
    iceDeep: Color(0xFF334155),
    iceMuted: Color(0xFFE2E8F0),
    sage: Color(0xFF667A6E),
    sageMuted: Color(0xFFE5ECE7),
    goldGradient: LinearGradient(
      colors: [Color(0xFF1E293B), Color(0xFF334155), Color(0xFFCBD5E1)],
      stops: [0.0, 0.58, 1.0],
    ),
    heroGradient: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [Color(0xFFF4F7FA), Color(0xFFE2E9F0), Color(0xFFD3DCE5)],
    ),
    cardGradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFFF3F6F9), Color(0xFFE2E8F0)],
    ),
    flashGradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFFF4F6F7), Color(0xFFE3E7E9)],
    ),
    violetGradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFF334155), Color(0xFF475569)],
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
      case AppThemePreset.globalEcommerce:
        return globalEcommerce;
      case AppThemePreset.midToneCashmere:
        return midToneCashmere;
      case AppThemePreset.midToneConcrete:
        return midToneConcrete;
      case AppThemePreset.midToneSage:
        return midToneSage;
    }
  }
}
