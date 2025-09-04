import 'package:flutter/material.dart';

/// Application color palette extracted from Figma design system.
/// 
/// Contains semantic colors for consistent theming across the app.
class AppColors {
  AppColors._();

  // Status colors
  static const Color open = Color(0xff5cd313);
  static const Color closed = Color(0xffea5e5e);
  static const Color star = Color(0xffffb800);

  // Background colors
  static const Color background = Color(0xfffafafa);
  static const Color placeholder = Color(0xffeeeeee);

  // UI elements
  static const Color dividerLine = Color(0xffeeeeee);
  static const Color primarySplash = Color(0x12000000);

  // Text colors
  static const Color primaryText = Color(0xff000000);
  static const Color secondaryText = Color(0xff606060);

  // Legacy naming (for backward compatibility)
  static const Color primaryFill = Color(0xff000000);
  static const Color defaultText = Color(0xff000000);
}