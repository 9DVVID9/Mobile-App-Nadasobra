import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_colors.dart';

class StatCard extends StatelessWidget {
  final String value;
  final String label;
  final String emoji;
  final Color background;

  const StatCard({
    super.key,
    required this.value,
    required this.label,
    required this.emoji,
    required this.background,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(20),
        boxShadow: AppColors.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 22)),
          const SizedBox(height: 8),
          Text(value,
              style: GoogleFonts.fredoka(
                  fontSize: 22, fontWeight: FontWeight.w600, color: AppColors.dark)),
          const SizedBox(height: 2),
          Text(label,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.inter(fontSize: 11, color: AppColors.muted)),
        ],
      ),
    );
  }
}
