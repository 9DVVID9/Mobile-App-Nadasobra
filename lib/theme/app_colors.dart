import 'package:flutter/material.dart';

class AppColors {
  static const cream   = Color(0xFFF4ECE0);
  static const teal    = Color(0xFF00C896);
  static const dark    = Color(0xFF0B1F1A);
  static const gold    = Color(0xFFFFD66B);
  static const coral   = Color(0xFFFF7A59);
  static const muted   = Color(0xFF667870);
  static const green   = Color(0xFF34C778);
  static const amber   = Color(0xFFFFB61E);
  static const red     = Color(0xFFED3F3F);
  static const white   = Color(0xFFFFFFFF);

  // Convenience: card shadows (reused everywhere)
  static List<BoxShadow> get cardShadow => [
    BoxShadow(color: dark.withValues(alpha: 0.08), offset: const Offset(0, 4), blurRadius: 0),
    BoxShadow(color: dark.withValues(alpha: 0.05), offset: const Offset(0, 10), blurRadius: 20),
  ];

  static List<BoxShadow> get elevatedShadow => [
    BoxShadow(color: dark.withValues(alpha: 0.15), offset: const Offset(0, 5), blurRadius: 0),
    BoxShadow(color: dark.withValues(alpha: 0.06), offset: const Offset(0, 12), blurRadius: 24),
  ];
}
