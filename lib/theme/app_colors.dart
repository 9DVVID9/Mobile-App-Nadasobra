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

  // Recipe tile tints (Figma)
  static const tileMint  = Color(0xFFC2EFDF);
  static const tilePeach = Color(0xFFFFD9C7);
  static const tileSand  = Color(0xFFFFE8B3);

  // Category icon backgrounds (used on fridge item cards)
  static const tintVegetable = Color(0xFFC2EFDF); // mint
  static const tintDairy     = Color(0xFFE6F0FA); // soft sky
  static const tintProtein   = Color(0xFFFFD9C7); // peach
  static const tintOther     = Color(0xFFFFE8B3); // sand

  // Impact stat-card backgrounds (Figma soft pastels)
  static const statGoldBg  = Color(0xFFFFF1D6);
  static const statMintBg  = Color(0xFFE0F6EE);
  static const statPeachBg = Color(0xFFFFE8E0);

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
