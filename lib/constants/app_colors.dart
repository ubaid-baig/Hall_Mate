import 'package:flutter/material.dart';

/// Central color palette for the app.
/// Usage: `AppColors.primary`, `AppColors.textMuted`, etc.
class AppColors {
  AppColors._(); // prevent instantiation

  // ── Primary ────────────────────────────────────────────────
  static const Color primary = Color(0xFF0E5A4A);
  static const Color primarySoft = Color(0xFFE3EFEA);
  static const Color primaryTint = Color(0xFFF3F8F6);

  // ── Accent ─────────────────────────────────────────────────
  static const Color accent = Color(0xFFF2A93B);
  static const Color accentSoft = Color(0xFFFDF1DC);
  static const Color accentInk = Color(0xFF5C3D00);
  static const Color accentStrongInk = Color(0xFF8A5A00);

  // ── Background ─────────────────────────────────────────────
  static const Color bgScreen = Color(0xFFF4F6F5);
  static const Color bgSurface = Color(0xFFFFFFFF);
  static const Color bgSubtle = Color(0xFFEEF1EF);
  static const Color bgNeutral = Color(0xFFE8ECEA);

  // ── Text ───────────────────────────────────────────────────
  static const Color textPrimary = Color(0xFF13201C);
  static const Color textSecondary = Color(0xFF3F4B47);
  static const Color textMuted = Color(0xFF56655F);
  static const Color textOnPrimary = Color(0xFFFFFFFF);
  static const Color textOnPrimaryMute = Color(0xFFC9E0D7);

  // ── Border ─────────────────────────────────────────────────
  static const Color border = Color(0xFFE1E6E3);
  static const Color borderStrong = Color(0xFFD5DDD9);
  static const Color borderDashed = Color(0xFFC7D2CD);

  // ── Status ─────────────────────────────────────────────────
  static const Color success = Color(0xFF16A34A);
  static const Color successSoft = Color(0xFFDCFCE7);
  static const Color successInk = Color(0xFF14532D);
  static const Color infoSoft = Color(0xFFE7EEFF);
  static const Color infoInk = Color(0xFF1E3A8A);
  static const Color danger = Color(0xFFB42318);
  static const Color dangerSoft = Color(0xFFFEE4E2);

  // ── Icon ───────────────────────────────────────────────────
  static const Color iconStar = Color(0xFFE0871B);
  static const Color iconHeart = Color(0xFFC2410C);

  // ── Photo placeholders ─────────────────────────────────────
  static const Color photoEmerald = Color(0xFFCFE3DA);
  static const Color photoEmeraldInk = Color(0xFF2E5247);
  static const Color photoMarigold = Color(0xFFF3DFBF);
  static const Color photoMarigoldInk = Color(0xFF5C3D00);
  static const Color photoSlate = Color(0xFFD9E1EC);
  static const Color photoSlateInk = Color(0xFF2F3E52);
}