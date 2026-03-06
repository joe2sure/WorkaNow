import 'package:flutter/material.dart';

class AppColors {
  // ── Primary Brand — Deep Navy Blue (trust, authority, professionalism)
  static const primary         = Color(0xFF1B2A4A); // Deep navy
  static const primaryMid      = Color(0xFF253D6B); // Navy mid
  static const primaryLight    = Color(0xFFECF0F8); // Navy tint bg
  static const primaryAccent   = Color(0xFF2F5299); // Bright navy for CTAs

  // ── Secondary — Slate Teal (clarity, calm, modern)
  static const secondary       = Color(0xFF2E7D6F); // Deep teal
  static const secondaryLight  = Color(0xFFEAF4F2); // Teal tint

  // ── Accent — Warm Amber (highlights, alerts — used sparingly)
  static const accent          = Color(0xFFC8862A); // Warm amber
  static const accentLight     = Color(0xFFFBF3E6); // Amber tint

  // ── Semantic
  static const success         = Color(0xFF1E7B4B); // Forest green
  static const successLight    = Color(0xFFE8F5EE);
  static const warning         = Color(0xFFC8862A); // Amber
  static const warningLight    = Color(0xFFFBF3E6);
  static const error           = Color(0xFFB03A2E); // Muted red
  static const errorLight      = Color(0xFFFAECEB);
  static const info            = Color(0xFF1A5276); // Deep blue-info

  // ── Neutrals — Warm slate scale
  static const background      = Color(0xFFF4F5F7); // Warm off-white
  static const surface         = Color(0xFFFFFFFF);
  static const surfaceRaised   = Color(0xFFFAFAFB);
  static const surfaceVariant  = Color(0xFFF0F2F5);
  static const divider         = Color(0xFFE2E6ED);
  static const outline         = Color(0xFFD4D9E2);

  // ── Text
  static const textPrimary     = Color(0xFF0F1E35); // Near-black
  static const textSecondary   = Color(0xFF4A5568); // Slate grey
  static const textTertiary    = Color(0xFF8A95A3); // Muted
  static const textOnDark      = Color(0xFFFFFFFF);
  static const textOnDarkMuted = Color(0xFFB8C5D9);

  // ── Header Gradients — subtle, not neon
  static const List<Color> headerGradient   = [Color(0xFF1B2A4A), Color(0xFF253D6B)];
  static const List<Color> tealGradient     = [Color(0xFF1D5E52), Color(0xFF2E7D6F)];
  static const List<Color> amberGradient    = [Color(0xFFA0681E), Color(0xFFC8862A)];
  static const List<Color> purpleGradient   = [Color(0xFF3D2B6B), Color(0xFF5C3FA0)];

  // ── Status chips
  static const presentBg   = Color(0xFFE8F5EE);
  static const presentFg   = Color(0xFF1E7B4B);
  static const lateBg      = Color(0xFFFBF3E6);
  static const lateFg      = Color(0xFFC8862A);
  static const absentBg    = Color(0xFFFAECEB);
  static const absentFg    = Color(0xFFB03A2E);
  static const onLeaveBg   = Color(0xFFECF0F8);
  static const onLeaveFg   = Color(0xFF2F5299);
}



// import 'package:flutter/material.dart';

// class AppColors {
//   // Brand Colors
//   static const primary = Color(0xFF1A73E8);
//   static const primaryDark = Color(0xFF1557B0);
//   static const primaryLight = Color(0xFFD2E3FC);
//   static const secondary = Color(0xFF00BFA5);
//   static const secondaryLight = Color(0xFFE0F7FA);
//   static const accent = Color(0xFFFF6D00);

//   // Status Colors
//   static const success = Color(0xFF00C853);
//   static const successLight = Color(0xFFE8F5E9);
//   static const warning = Color(0xFFFFAB00);
//   static const warningLight = Color(0xFFFFF8E1);
//   static const error = Color(0xFFD32F2F);
//   static const errorLight = Color(0xFFFFEBEE);
//   static const info = Color(0xFF0288D1);

//   // Neutral Colors
//   static const background = Color(0xFFF5F7FA);
//   static const surface = Color(0xFFFFFFFF);
//   static const surfaceVariant = Color(0xFFF0F4FF);
//   static const onSurface = Color(0xFF1C1B1F);
//   static const onSurfaceVariant = Color(0xFF49454F);
//   static const outline = Color(0xFFE0E0E0);
//   static const textSecondary = Color(0xFF6B7280);
//   static const textTertiary = Color(0xFF9CA3AF);

//   // Gradient
//   static const gradientPrimary = [Color(0xFF1A73E8), Color(0xFF0D47A1)];
//   static const gradientSecondary = [Color(0xFF00BFA5), Color(0xFF00695C)];
//   static const gradientAccent = [Color(0xFFFF6D00), Color(0xFFE64A19)];
// }