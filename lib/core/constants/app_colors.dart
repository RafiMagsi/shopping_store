import 'package:flutter/material.dart';

/// Muted light ecommerce palette with soft contrast and restrained accents.
class AppColors {
  AppColors._();

  // ── Backgrounds — soft ivory and clean whites ───────────────────────
  static const Color bg = Color(0xFFF8F6F2);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color card = Color(0xFFFFFCF8);
  static const Color cardElevated = Color(0xFFF2EEE8);
  static const Color divider = Color(0xFFE8E2D9);

  // ── Accents — muted clay, slate, sage ───────────────────────────────
  static const Color champagne = Color(0xFF9B7B63);
  static const Color champagneDeep = Color(0xFF7E624E);
  static const Color champagneLight = Color(0xFFC6A993);
  static const Color champagneMuted = Color(0xFFF1E6DC);

  static const Color rose = Color(0xFFB88474);
  static const Color roseDeep = Color(0xFF946555);
  static const Color roseMuted = Color(0xFFF4E6E0);

  static const Color ice = Color(0xFF778899);
  static const Color iceDeep = Color(0xFF5E6C7A);
  static const Color iceMuted = Color(0xFFE6EBF0);

  static const Color sage = Color(0xFF7E9581);
  static const Color sageMuted = Color(0xFFE8EEE9);

  // ── Text ─────────────────────────────────────────────────────────────
  static const Color textPrimary = Color(0xFF171513);
  static const Color textSecondary = Color(0xFF6B645C);
  static const Color textMuted = Color(0xFFA59B90);
  static const Color textInverse = Color(0xFFFAF8F4);

  // ── Glass / Borders ──────────────────────────────────────────────────
  static const Color glass = Color(0xCCFFFFFF);
  static const Color glassBorder = Color(0x26B7A694);
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
    colors: [Color(0xFFFCFAF6), Color(0xFFF4EFE7), Color(0xFFECE5DA)],
  );

  static const LinearGradient cardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFFFFCF8), Color(0xFFF3EEE6)],
  );

  static const LinearGradient flashGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFF7F1EA), Color(0xFFEEE6DB)],
  );

  static const LinearGradient violetGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [iceDeep, ice],
  );
}
