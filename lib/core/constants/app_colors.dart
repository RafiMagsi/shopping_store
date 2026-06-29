import 'package:flutter/material.dart';

/// Muted premium light ecommerce palette with soft contrast and restrained accents.
class AppColors {
  AppColors._();

  // ── Backgrounds — warm porcelain and clean whites ────────────────────
  static const Color bg = Color(0xFFF7F4EE);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color card = Color(0xFFFFFBF6);
  static const Color cardElevated = Color(0xFFF3EDE4);
  static const Color divider = Color(0xFFE5DED3);

  // ── Accents — taupe bronze, dusty rose, tailored slate ──────────────
  static const Color champagne = Color(0xFF92735D);
  static const Color champagneDeep = Color(0xFF755947);
  static const Color champagneLight = Color(0xFFC5A690);
  static const Color champagneMuted = Color(0xFFF0E4D9);

  static const Color rose = Color(0xFFAF7E73);
  static const Color roseDeep = Color(0xFF8F6158);
  static const Color roseMuted = Color(0xFFF3E4E0);

  static const Color ice = Color(0xFF738291);
  static const Color iceDeep = Color(0xFF596675);
  static const Color iceMuted = Color(0xFFE4EAF0);

  static const Color sage = Color(0xFF839383);
  static const Color sageMuted = Color(0xFFE7EEE7);

  // ── Text ─────────────────────────────────────────────────────────────
  static const Color textPrimary = Color(0xFF161412);
  static const Color textSecondary = Color(0xFF676057);
  static const Color textMuted = Color(0xFFA29688);
  static const Color textInverse = Color(0xFFFAF8F4);

  // ── Glass / Borders ──────────────────────────────────────────────────
  static const Color glass = Color(0xCCFFFFFF);
  static const Color glassBorder = Color(0x24B6A28D);
  static const Color glassHighlight = Color(0xA6FFFFFF);
  static const Color glassWhite = glass;

  // ── Backwards-compat aliases ──────────────────────────────────────────
  static const Color gold = champagne;
  static const Color goldDeep = champagneDeep;
  static const Color goldLight = champagneLight;
  static const Color goldMuted = champagneMuted;
  static const Color amber = champagne;
  static const Color amberDeep = champagneDeep;
  static const Color amberMuted = champagneMuted;
  static const Color coral = rose;
  static const Color coralDeep = roseDeep;
  static const Color coralMuted = roseMuted;
  static const Color pink = rose;
  static const Color pinkDeep = roseDeep;
  static const Color pinkMuted = roseMuted;
  static const Color violet = champagne;
  static const Color violetBright = champagneLight;
  static const Color violetDeep = champagneDeep;
  static const Color violetMuted = champagneMuted;
  static const Color violetGlow = Color(0x289A7B4F);
  static const Color neon = sage;
  static const Color neonDim = Color(0xFF3A6045);
  static const Color neonMuted = sageMuted;
  static const Color blue = ice;
  static const Color blueBright = Color(0xFF5A80B0);
  static const Color blueMuted = iceMuted;
  static const Color emerald = sage;
  static const Color emeraldMuted = sageMuted;
  static const Color success = sage;

  // ── Gradients ─────────────────────────────────────────────────────────
  static const LinearGradient goldGradient = LinearGradient(
    colors: [champagneDeep, champagne, champagneLight],
    stops: [0.0, 0.55, 1.0],
  );

  static const LinearGradient heroGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFFFCFAF5), Color(0xFFF3EEE5), Color(0xFFE9E0D2)],
  );

  static const LinearGradient cardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFFFFBF6), Color(0xFFF2EBE1)],
  );

  static const LinearGradient flashGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFF8F2EA), Color(0xFFEEE4D8)],
  );

  static const LinearGradient violetGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [iceDeep, ice],
  );
}
