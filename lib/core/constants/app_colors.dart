import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // ── Backgrounds ─────────────────────────────────────────────────────────
  static const Color bg           = Color(0xFF080810); // near-black blue-tinted
  static const Color surface      = Color(0xFF0F0F1C);
  static const Color card         = Color(0xFF14142A);
  static const Color cardElevated = Color(0xFF1C1C38);

  // ── Violet / Primary ────────────────────────────────────────────────────
  static const Color violet       = Color(0xFF7C3AED);
  static const Color violetBright = Color(0xFF9F67FF);
  static const Color violetDeep   = Color(0xFF5B21B6);
  static const Color violetMuted  = Color(0xFF2D1B69);
  static const Color violetGlow   = Color(0x557C3AED);

  // ── Neon Mint / Green ───────────────────────────────────────────────────
  static const Color neon         = Color(0xFF00FFA3);
  static const Color neonDim      = Color(0xFF00CC82);
  static const Color neonMuted    = Color(0xFF003D26);

  // ── Electric Blue ───────────────────────────────────────────────────────
  static const Color blue         = Color(0xFF0EA5E9);
  static const Color blueBright   = Color(0xFF38BDF8);
  static const Color blueMuted    = Color(0xFF0C2A3D);

  // ── Hot Pink / Sale ─────────────────────────────────────────────────────
  static const Color pink         = Color(0xFFFF2D6B);
  static const Color pinkBright   = Color(0xFFFF5C8A);
  static const Color pinkMuted    = Color(0xFF3D0D1E);

  // ── Amber / Price ───────────────────────────────────────────────────────
  static const Color amber        = Color(0xFFFBBF24);
  static const Color amberDeep    = Color(0xFFD97706);
  static const Color amberMuted   = Color(0xFF3D2A00);

  // ── Emerald / Success ───────────────────────────────────────────────────
  static const Color emerald      = Color(0xFF10B981);
  static const Color emeraldMuted = Color(0xFF0A2E22);

  // ── Text ────────────────────────────────────────────────────────────────
  static const Color textPrimary   = Color(0xFFF5F5FF);
  static const Color textSecondary = Color(0xFF7878A0);
  static const Color textMuted     = Color(0xFF3D3D60);
  static const Color textInverse   = Color(0xFF080810);

  // ── Glass / Border ──────────────────────────────────────────────────────
  static const Color glass          = Color(0x14FFFFFF);
  static const Color glassBorder    = Color(0x22FFFFFF);
  static const Color glassHighlight = Color(0x08FFFFFF);
  static const Color glassWhite     = glass; // alias

  // ── Backwards compat aliases ────────────────────────────────────────────
  static const Color gold      = amber;
  static const Color goldDeep  = amberDeep;
  static const Color goldMuted = amberMuted;
  static const Color coral     = pink;
  static const Color coralDeep = pink;
  static const Color coralMuted = pinkMuted;
  static const Color pinkDeep   = pink;     // alias
  static const Color success   = emerald;

  // ── Gradients ────────────────────────────────────────────────────────────
  static const LinearGradient goldGradient = LinearGradient(
    colors: [amberDeep, amber, amberDeep],
    stops: [0.0, 0.5, 1.0],
  );

  static const LinearGradient violetGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [violetDeep, violet, violetBright],
  );

  static const LinearGradient neonGradient = LinearGradient(
    colors: [neonDim, neon],
  );

  static const LinearGradient heroGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFF0A0A18), Color(0xFF12082E), Color(0xFF080810)],
  );

  static const LinearGradient cardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF1A1A30), Color(0xFF0F0F1E)],
  );

  static const LinearGradient flashGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF1A0814), Color(0xFF2A0D1E)],
  );
}
