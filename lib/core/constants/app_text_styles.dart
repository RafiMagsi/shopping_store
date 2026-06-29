import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTextStyles {
  AppTextStyles._();

  // ── Display ───────────────────────────────────────────────────────────────
  static TextStyle get displayXL => TextStyle(
    color: AppColors.textPrimary,
    fontSize: 50,
    fontWeight: FontWeight.w900,
    letterSpacing: -2.2,
    height: 1.02,
  );

  static TextStyle get displayL => TextStyle(
    color: AppColors.textPrimary,
    fontSize: 38,
    fontWeight: FontWeight.w800,
    letterSpacing: -1.8,
    height: 1.06,
  );

  static TextStyle get displayM => TextStyle(
    color: AppColors.textPrimary,
    fontSize: 31,
    fontWeight: FontWeight.w800,
    letterSpacing: -1.3,
    height: 1.08,
  );

  // ── Headings ──────────────────────────────────────────────────────────────
  static TextStyle get h1 => TextStyle(
    color: AppColors.textPrimary,
    fontSize: 27,
    fontWeight: FontWeight.w800,
    letterSpacing: -0.9,
    height: 1.12,
  );

  static TextStyle get h2 => TextStyle(
    color: AppColors.textPrimary,
    fontSize: 21,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.5,
    height: 1.2,
  );

  static TextStyle get h3 => TextStyle(
    color: AppColors.textPrimary,
    fontSize: 18,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.25,
  );

  // ── Body ──────────────────────────────────────────────────────────────────
  static TextStyle get bodyL => TextStyle(
    color: AppColors.textSecondary,
    fontSize: 15,
    fontWeight: FontWeight.w400,
    height: 1.55,
  );

  static TextStyle get bodyM => TextStyle(
    color: AppColors.textSecondary,
    fontSize: 14.5,
    fontWeight: FontWeight.w400,
    height: 1.48,
  );

  static TextStyle get bodyS => TextStyle(
    color: AppColors.textSecondary,
    fontSize: 12.5,
    fontWeight: FontWeight.w400,
    height: 1.4,
  );

  // ── Labels ────────────────────────────────────────────────────────────────
  static TextStyle get labelL => TextStyle(
    color: AppColors.textPrimary,
    fontSize: 13.5,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.2,
  );

  static TextStyle get labelM => TextStyle(
    color: AppColors.textPrimary,
    fontSize: 11.5,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.45,
  );

  static TextStyle get labelS => TextStyle(
    color: AppColors.textSecondary,
    fontSize: 10.5,
    fontWeight: FontWeight.w500,
    letterSpacing: 1.0,
  );

  // ── Price ────────────────────────────────────────────────────────────────
  static TextStyle get price => TextStyle(
    color: AppColors.gold,
    fontSize: 19,
    fontWeight: FontWeight.w800,
    letterSpacing: -0.4,
  );

  static TextStyle get priceStrike => TextStyle(
    color: AppColors.textMuted,
    fontSize: 13,
    fontWeight: FontWeight.w400,
    decoration: TextDecoration.lineThrough,
  );

  // ── Special ──────────────────────────────────────────────────────────────
  static TextStyle get overline => TextStyle(
    color: AppColors.gold,
    fontSize: 11.5,
    fontWeight: FontWeight.w800,
    letterSpacing: 2.2,
  );

  static TextStyle get buttonL => const TextStyle(
    fontSize: 15.5,
    fontWeight: FontWeight.w800,
    letterSpacing: 0.3,
  );
}
