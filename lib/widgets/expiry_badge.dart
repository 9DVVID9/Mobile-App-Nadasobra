import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/fridge_item.dart';
import '../theme/app_colors.dart';

class ExpiryBadge extends StatelessWidget {
  final FridgeItem item;
  const ExpiryBadge({super.key, required this.item});

  Color get _color {
    switch (item.expiryStatus) {
      case ExpiryStatus.expiring:     return AppColors.red;
      case ExpiryStatus.soonExpiring: return AppColors.amber;
      case ExpiryStatus.fresh:        return AppColors.green;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: _color,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Text(
        item.expiryLabel,
        style: GoogleFonts.fredoka(
          fontSize: 12, fontWeight: FontWeight.w600, color: Colors.white,
        ),
      ),
    );
  }
}
