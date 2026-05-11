import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/badge_model.dart';
import '../theme/app_colors.dart';

class AchievementBadge extends StatelessWidget {
  final BadgeModel badge;
  const AchievementBadge({super.key, required this.badge});

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: badge.earned ? 1.0 : 0.35,
      child: Column(
        children: [
          Container(
            width: 64, height: 64,
            decoration: BoxDecoration(
              color: badge.earned ? AppColors.teal.withValues(alpha: 0.12) : AppColors.muted.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: badge.earned ? AppColors.teal : AppColors.muted,
                width: 2,
              ),
              boxShadow: badge.earned ? AppColors.cardShadow : null,
            ),
            child: Center(
              child: Text(badge.emoji, style: const TextStyle(fontSize: 28)),
            ),
          ),
          const SizedBox(height: 6),
          Text(badge.name,
              textAlign: TextAlign.center,
              maxLines: 2,
              style: GoogleFonts.inter(fontSize: 10, color: AppColors.muted)),
        ],
      ),
    );
  }
}
