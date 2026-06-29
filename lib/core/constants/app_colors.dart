import 'package:flutter/material.dart';
import '../theme/app_theme_preset.dart';

class AppColors {
  AppColors._();

  static AppThemePalette get _palette => AppThemePresets.current;

  static Color get bg => _palette.bg;
  static Color get surface => _palette.surface;
  static Color get card => _palette.card;
  static Color get cardElevated => _palette.cardElevated;
  static Color get frameSurface => _palette.frameSurface;
  static Color get divider => _palette.divider;
  static Color get champagne => _palette.champagne;
  static Color get champagneDeep => _palette.champagneDeep;
  static Color get champagneLight => _palette.champagneLight;
  static Color get champagneMuted => _palette.champagneMuted;
  static Color get rose => _palette.rose;
  static Color get roseDeep => _palette.roseDeep;
  static Color get roseMuted => _palette.roseMuted;
  static Color get ice => _palette.ice;
  static Color get iceDeep => _palette.iceDeep;
  static Color get iceMuted => _palette.iceMuted;
  static Color get sage => _palette.sage;
  static Color get sageMuted => _palette.sageMuted;
  static Color get textPrimary => _palette.textPrimary;
  static Color get textSecondary => _palette.textSecondary;
  static Color get textMuted => _palette.textMuted;
  static Color get textInverse => _palette.textInverse;
  static Color get price => _palette.price;
  static Color get ratingBg => _palette.ratingBg;
  static Color get ratingText => _palette.ratingText;
  static Color get glass => _palette.glass;
  static Color get glassBorder => _palette.glassBorder;
  static Color get glassHighlight => _palette.glassHighlight;
  static Color get glassWhite => glass;

  // ── Backwards-compat aliases ──────────────────────────────────────────
  static Color get gold => champagne;
  static Color get goldDeep => champagneDeep;
  static Color get goldLight => champagneLight;
  static Color get goldMuted => champagneMuted;
  static Color get amber => champagne;
  static Color get amberDeep => champagneDeep;
  static Color get amberMuted => champagneMuted;
  static Color get coral => rose;
  static Color get coralDeep => roseDeep;
  static Color get coralMuted => roseMuted;
  static Color get pink => rose;
  static Color get pinkDeep => roseDeep;
  static Color get pinkMuted => roseMuted;
  static Color get violet => champagne;
  static Color get violetBright => champagneLight;
  static Color get violetDeep => champagneDeep;
  static Color get violetMuted => champagneMuted;
  static const Color violetGlow = Color(0x289A7B4F);
  static Color get neon => sage;
  static const Color neonDim = Color(0xFF3A6045);
  static Color get neonMuted => sageMuted;
  static Color get blue => ice;
  static const Color blueBright = Color(0xFF5A80B0);
  static Color get blueMuted => iceMuted;
  static Color get emerald => sage;
  static Color get emeraldMuted => sageMuted;
  static Color get success => sage;

  // ── Gradients ─────────────────────────────────────────────────────────
  static LinearGradient get goldGradient => _palette.goldGradient;
  static LinearGradient get heroGradient => _palette.heroGradient;
  static LinearGradient get cardGradient => _palette.cardGradient;
  static LinearGradient get flashGradient => _palette.flashGradient;
  static LinearGradient get violetGradient => _palette.violetGradient;
}
