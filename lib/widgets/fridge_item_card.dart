import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/fridge_item.dart';
import '../theme/app_colors.dart';
import 'expiry_badge.dart';

class FridgeItemCard extends StatelessWidget {
  final FridgeItem item;
  final VoidCallback onDelete;

  const FridgeItemCard({super.key, required this.item, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(item.id),
      direction: DismissDirection.endToStart,
      onDismissed: (_) {
        HapticFeedback.mediumImpact();
        onDelete();
      },
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: AppColors.red.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Icon(Icons.delete_outline_rounded, color: AppColors.red, size: 24),
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.dark.withValues(alpha: 0.08), width: 1.5),
          boxShadow: AppColors.cardShadow,
        ),
        child: Row(
          children: [
            Text(item.emoji, style: const TextStyle(fontSize: 28)),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.name,
                      style: GoogleFonts.fredoka(
                          fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.dark)),
                  const SizedBox(height: 2),
                  Text(item.quantity,
                      style: GoogleFonts.inter(fontSize: 12, color: AppColors.muted)),
                ],
              ),
            ),
            ExpiryBadge(item: item),
          ],
        ),
      ),
    );
  }
}
