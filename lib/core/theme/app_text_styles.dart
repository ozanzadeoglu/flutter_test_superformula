import 'package:flutter/material.dart';

/// Application text styles extracted from Figma.
class AppTextStyles {
  AppTextStyles._();

  // Headings - using Lora font
  static const TextStyle headingLarge = TextStyle(
    fontSize: 28,
    fontFamily: 'Lora',
    fontWeight: FontWeight.w700,
    height: 36 / 28,
    letterSpacing: 0,
  );

  static const TextStyle headingMedium = TextStyle(
    fontSize: 18,
    fontFamily: 'Lora',
    fontWeight: FontWeight.w700,
    height: 24 / 18,
    letterSpacing: 0,
  );

  static const TextStyle headingSmall = TextStyle(
    fontSize: 16,
    fontFamily: 'Lora',
    fontWeight: FontWeight.w500,
    height: 24 / 16,
    letterSpacing: 0,
  );

  // Body text - using OpenSans font
  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16,
    fontFamily: 'OpenSans',
    fontWeight: FontWeight.w400,
    height: 24 / 16,
    letterSpacing: 0,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14,
    fontFamily: 'OpenSans',
    fontWeight: FontWeight.w400,
    height: 24 / 14,
    letterSpacing: 0,
  );

  static const TextStyle bodySmall = TextStyle(
    fontSize: 12,
    fontFamily: 'OpenSans',
    fontWeight: FontWeight.w400,
    height: 20 / 12,
    letterSpacing: 0,
  );

  // Labels and buttons
  static const TextStyle labelLarge = TextStyle(
    fontSize: 14,
    fontFamily: 'OpenSans',
    fontWeight: FontWeight.w600,
    height: 24 / 14,
    letterSpacing: 0,
  );

  // Specialty styles
  static const TextStyle caption = TextStyle(
    fontSize: 12,
    fontFamily: 'OpenSans',
    fontWeight: FontWeight.w400,
    height: 20 / 12,
    letterSpacing: 0,
  );

  static const TextStyle overline = TextStyle(
    fontSize: 12,
    fontFamily: 'OpenSans',
    fontStyle: FontStyle.italic,
    fontWeight: FontWeight.w400,
    height: 12 / 12,
    letterSpacing: 0,
  );
}