import 'package:flutter/material.dart';

/// "Warm Ivory Luxury" — a premium light theme.
/// Inspired by SSENSE, Hermès, Net-a-Porter, and Apple Light.
class AppColors {
  AppColors._();

  // ── Backgrounds — warm ivory paper ──────────────────────────────────
  static const Color bg           = Color(0xFFF7F5F1);
  static const Color surface      = Color(0xFFFFFFFF);
  static const Color card         = Color(0xFFFFFFFF);
  static const Color cardElevated = Color(0xFFF2F0EC);
  static const Color divider      = Color(0xFFE6E3DF);

  // ── Bronze Gold — primary luxury accent ─────────────────────────────
  static const Color champagne      = Color(0xFF9A7B4F); // deep bronze (legible on white)
  static const Color champagneDeep  = Color(0xFF7A5F38); // richer, darker
  static const Color champagneLight = Color(0xFFC9A96E); // lighter gold
  static const Color champagneMuted = Color(0xFFF5EFE5); // very light gold bg

  // ── Terracotta Rose — warm secondary ────────────────────────────────
  static const Color rose        = Color(0xFFC47560);
  static const Color roseDeep    = Color(0xFFA05040);
  static const Color roseMuted   = Color(0xFFFAF0EC);

  // ── Slate Blue — cool accent for tech ───────────────────────────────
  static const Color ice         = Color(0xFF3D5A80);
  static const Color iceDeep     = Color(0xFF2A3F5A);
  static const Color iceMuted    = Color(0xFFEBF0F5);

  // ── Forest Sage — green for new/eco ─────────────────────────────────
  static const Color sage        = Color(0xFF4E7A5A);
  static const Color sageMuted   = Color(0xFFEBF2EE);

  // ── Text — warm tones ────────────────────────────────────────────────
  static const Color textPrimary   = Color(0xFF1A1916);
  static const Color textSecondary = Color(0xFF6B6560);
  static const Color textMuted     = Color(0xFFB0ABA5);
  static const Color textInverse   = Color(0xFFF7F5F1);

  // ── Glass / Borders ──────────────────────────────────────────────────
  static const Color glass          = Color(0xB3FFFFFF);
  static const Color glassBorder    = Color(0x14000000); // 8% black
  static const Color glassHighlight = Color(0x08FFFFFF);
  static const Color glassWhite     = glass;

  // ── Backwards-compat aliases ──────────────────────────────────────────
  static const Color gold        = champagne;
  static const Color goldDeep    = champagneDeep;
  static const Color goldLight   = champagneLight;
  static const Color goldMuted   = champagneMuted;
  static const Color amber       = champagne;
  static const Color amberDeep   = champagneDeep;
  static const Color amberMuted  = champagneMuted;
  static const Color coral       = rose;
  static const Color coralDeep   = roseDeep;
  static const Color coralMuted  = roseMuted;
  static const Color pink        = rose;
  static const Color pinkDeep    = roseDeep;
  static const Color pinkMuted   = roseMuted;
  static const Color violet      = champagne;
  static const Color violetBright = champagneLight;
  static const Color violetDeep  = champagneDeep;
  static const Color violetMuted = champagneMuted;
  static const Color violetGlow  = Color(0x289A7B4F);
  static const Color neon        = sage;
  static const Color neonDim     = Color(0xFF3A6045);
  static const Color neonMuted   = sageMuted;
  static const Color blue        = ice;
  static const Color blueBright  = Color(0xFF5A80B0);
  static const Color blueMuted   = iceMuted;
  static const Color emerald     = sage;
  static const Color emeraldMuted = sageMuted;
  static const Color success     = sage;

  // ── Gradients ─────────────────────────────────────────────────────────
  static const LinearGradient goldGradient = LinearGradient(
    colors: [champagneDeep, champagne, champagneLight],
    stops: [0.0, 0.5, 1.0],
  );

  static const LinearGradient heroGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFF0A0808), Color(0xFF141010), Color(0xFF1A1614)],
  );

  static const LinearGradient cardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFFBFAF8), Color(0xFFF5F3F0)],
  );

  static const LinearGradient flashGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFFAF0EC), Color(0xFFF7EBE6)],
  );

  static const LinearGradient violetGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [champagneDeep, champagne],
  );
}
