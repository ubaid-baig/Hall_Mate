import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTextStyles {
  AppTextStyles._(); // prevent instantiation

  // If no color is passed, the text takes its color from the app theme
  // (see app_theme.dart), so it is dark text in light mode and light text
  // in dark mode automatically.
  static TextStyle _style(double size, FontWeight weight, Color? color) {
    return GoogleFonts.plusJakartaSans(
      fontSize: size,
      fontWeight: weight,
      color: color,
    );
  }

  // Display and headings
  static TextStyle display({Color? color}) => _style(40, FontWeight.w800, color);
  static TextStyle h1({Color? color}) => _style(28, FontWeight.w800, color);
  static TextStyle h2({Color? color}) => _style(22, FontWeight.w800, color);
  static TextStyle h3({Color? color}) => _style(17, FontWeight.w800, color);

  // Titles
  static TextStyle titleLarge({Color? color}) => _style(16, FontWeight.w700, color);
  static TextStyle titleMedium({Color? color}) => _style(15, FontWeight.w700, color);
  static TextStyle titleSmall({Color? color}) => _style(14, FontWeight.w700, color);

  // Body
  static TextStyle bodyLarge({Color? color}) => _style(16, FontWeight.w400, color);
  static TextStyle bodyMedium({Color? color}) => _style(14, FontWeight.w500, color);
  static TextStyle bodySmall({Color? color}) => _style(13, FontWeight.w500, color);

  // Labels
  static TextStyle labelButton({Color? color}) => _style(16, FontWeight.w700, color);
  static TextStyle labelSmall({Color? color}) => _style(12, FontWeight.w700, color);
  static TextStyle labelTiny({Color? color}) => _style(11, FontWeight.w600, color);

  // Other
  static TextStyle caption({Color? color}) => _style(12, FontWeight.w500, color);
  static TextStyle priceLarge({Color? color}) => _style(20, FontWeight.w800, color);
}
