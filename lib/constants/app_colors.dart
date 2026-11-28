import 'package:flutter/material.dart';

class AppColors {
  // ── Primary ────────────────────────────────────────────────
  final Color primary;
  final Color primarySoft;
  final Color primaryTint;
  final Color primaryInk; // green text, links and icons that sit on a surface
  final Color primaryBorder; // selected / focused borders

  // ── Accent ─────────────────────────────────────────────────
  final Color accent;
  final Color accentSoft;
  final Color accentInk;
  final Color accentStrongInk;

  // ── Background ─────────────────────────────────────────────
  final Color bgScreen;
  final Color bgSurface;
  final Color bgSubtle;
  final Color bgNeutral;

  // ── Text ───────────────────────────────────────────────────
  final Color textPrimary;
  final Color textSecondary;
  final Color textMuted;
  final Color textOnPrimary;
  final Color textOnPrimaryMute;
  final Color textOnAccent; // dark text or icon on the orange accent

  // ── Border ─────────────────────────────────────────────────
  final Color border;
  final Color borderStrong;
  final Color borderDashed;

  // ── Status ─────────────────────────────────────────────────
  final Color success;
  final Color successSoft;
  final Color successInk;
  final Color infoSoft;
  final Color infoInk;
  final Color danger;
  final Color dangerSoft;

  // ── Icon ───────────────────────────────────────────────────
  final Color iconStar;
  final Color iconHeart;

  // ── Photo placeholders ─────────────────────────────────────
  final Color photoEmerald;
  final Color photoEmeraldInk;
  final Color photoMarigold;
  final Color photoMarigoldInk;
  final Color photoSlate;
  final Color photoSlateInk;

  const AppColors({
    required this.primary,
    required this.primarySoft,
    required this.primaryTint,
    required this.primaryInk,
    required this.primaryBorder,
    required this.accent,
    required this.accentSoft,
    required this.accentInk,
    required this.accentStrongInk,
    required this.bgScreen,
    required this.bgSurface,
    required this.bgSubtle,
    required this.bgNeutral,
    required this.textPrimary,
    required this.textSecondary,
    required this.textMuted,
    required this.textOnPrimary,
    required this.textOnPrimaryMute,
    required this.textOnAccent,
    required this.border,
    required this.borderStrong,
    required this.borderDashed,
    required this.success,
    required this.successSoft,
    required this.successInk,
    required this.infoSoft,
    required this.infoInk,
    required this.danger,
    required this.dangerSoft,
    required this.iconStar,
    required this.iconHeart,
    required this.photoEmerald,
    required this.photoEmeraldInk,
    required this.photoMarigold,
    required this.photoMarigoldInk,
    required this.photoSlate,
    required this.photoSlateInk,
  });

  // ════════════════════════════════════════════════════════════
  // LIGHT colors (your original palette, nothing changed)
  // ════════════════════════════════════════════════════════════
  static const AppColors light = AppColors(
    // Primary
    primary: Color(0xFF0E5A4A),
    primarySoft: Color(0xFFE3EFEA),
    primaryTint: Color(0xFFF3F8F6),
    primaryInk: Color(0xFF0E5A4A),
    primaryBorder: Color(0xFF0E5A4A),
    // Accent
    accent: Color(0xFFF2A93B),
    accentSoft: Color(0xFFFDF1DC),
    accentInk: Color(0xFF5C3D00),
    accentStrongInk: Color(0xFF8A5A00),
    // Background
    bgScreen: Color(0xFFF4F6F5),
    bgSurface: Color(0xFFFFFFFF),
    bgSubtle: Color(0xFFEEF1EF),
    bgNeutral: Color(0xFFE8ECEA),
    // Text
    textPrimary: Color(0xFF13201C),
    textSecondary: Color(0xFF3F4B47),
    textMuted: Color(0xFF56655F),
    textOnPrimary: Color(0xFFFFFFFF),
    textOnPrimaryMute: Color(0xFFC9E0D7),
    textOnAccent: Color(0xFF5C3D00),
    // Border
    border: Color(0xFFE1E6E3),
    borderStrong: Color(0xFFD5DDD9),
    borderDashed: Color(0xFFC7D2CD),
    // Status
    success: Color(0xFF16A34A),
    successSoft: Color(0xFFDCFCE7),
    successInk: Color(0xFF14532D),
    infoSoft: Color(0xFFE7EEFF),
    infoInk: Color(0xFF1E3A8A),
    danger: Color(0xFFB42318),
    dangerSoft: Color(0xFFFEE4E2),
    // Icon
    iconStar: Color(0xFFE0871B),
    iconHeart: Color(0xFFC2410C),
    // Photo placeholders
    photoEmerald: Color(0xFFCFE3DA),
    photoEmeraldInk: Color(0xFF2E5247),
    photoMarigold: Color(0xFFF3DFBF),
    photoMarigoldInk: Color(0xFF5C3D00),
    photoSlate: Color(0xFFD9E1EC),
    photoSlateInk: Color(0xFF2F3E52),
  );

  // ════════════════════════════════════════════════════════════
  // DARK colors (from your dark Figma palette)
  // ════════════════════════════════════════════════════════════
  static const AppColors dark = AppColors(
    // Primary
    primary: Color(0xFF0E5A4A),
    primarySoft: Color(0xFF203F35),
    primaryTint: Color(0xFF192F28),
    primaryInk: Color(0xFF79DFC1), // taken from the dark screens
    primaryBorder: Color(0xFF559984), // taken from the dark screens
    // Accent
    accent: Color(0xFFF2A93B),
    accentSoft: Color(0xFF3B2D18),
    accentInk: Color(0xFFF7CF8B),
    accentStrongInk: Color(0xFFF5BE63),
    // Background
    bgScreen: Color(0xFF0F1815),
    bgSurface: Color(0xFF192520),
    bgSubtle: Color(0xFF202E28),
    bgNeutral: Color(0xFF2B3B33),
    // Text
    textPrimary: Color(0xFFF0F6F2),
    textSecondary: Color(0xFFC5D3CB),
    textMuted: Color(0xFFA0B3A8),
    textOnPrimary: Color(0xFFFFFFFF),
    textOnPrimaryMute: Color(0xFFCEE4DA),
    textOnAccent: Color(0xFF5C3D00), // same dark brown in both themes
    // Border
    border: Color(0xFF33473C),
    borderStrong: Color(0xFF486454),
    borderDashed: Color(0xFF607E6D),
    // Status
    success: Color(0xFF58D68B),
    successSoft: Color(0xFF193A29),
    successInk: Color(0xFF8CE6AE),
    infoSoft: Color(0xFF202E49),
    infoInk: Color(0xFFB1C9FF),
    danger: Color(0xFFFF9B92),
    dangerSoft: Color(0xFF422421),
    // Icon
    iconStar: Color(0xFFF4B653),
    iconHeart: Color(0xFFFFAD83),
    // Photo placeholders
    photoEmerald: Color(0xFF294B3E),
    photoEmeraldInk: Color(0xFFBCDCCB),
    photoMarigold: Color(0xFF493921),
    photoMarigoldInk: Color(0xFFF0D3A3),
    photoSlate: Color(0xFF303E52),
    photoSlateInk: Color(0xFFC6D6EF),
  );

  /// Gives the light set or the dark set depending on the current theme.
  static AppColors of(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark ? dark : light;
  }
}
