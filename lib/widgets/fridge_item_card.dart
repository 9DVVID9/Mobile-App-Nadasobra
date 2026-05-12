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

  Future<void> _confirmDelete(BuildContext context) async {
    HapticFeedback.selectionClick();
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('Delete ${item.name}?',
            style: GoogleFonts.fredoka(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.dark)),
        content: Text('This item will be removed from your fridge.',
            style: GoogleFonts.inter(fontSize: 13, color: AppColors.muted)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text('Cancel',
                style: GoogleFonts.fredoka(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.muted)),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text('Delete',
                style: GoogleFonts.fredoka(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.red)),
          ),
        ],
      ),
    );
    if (shouldDelete == true) {
      HapticFeedback.mediumImpact();
      onDelete();
    }
  }

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
      child: GestureDetector(
        onLongPress: () => _confirmDelete(context),
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
      ),
    );
  }
}
