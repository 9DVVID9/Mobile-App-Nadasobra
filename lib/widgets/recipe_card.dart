import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/recipe.dart';
import '../theme/app_colors.dart';

class RecipeCard extends StatelessWidget {
  final Recipe recipe;
  final VoidCallback onTap;

  const RecipeCard({super.key, required this.recipe, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Hero(
        tag: 'recipe_${recipe.id}',
        child: Material(
          color: Colors.transparent,
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.dark.withValues(alpha: 0.08), width: 1.5),
              boxShadow: AppColors.cardShadow,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(19),
              child: Row(
                children: [
                  Container(width: 4, color: recipe.accentColor),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(recipe.emoji, style: const TextStyle(fontSize: 32)),
                          const SizedBox(height: 6),
                          Text(recipe.name,
                              maxLines: 2, overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.fredoka(
                                  fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.dark)),
                          const SizedBox(height: 4),
                          Text('${recipe.durationMinutes} min · ${recipe.difficulty}',
                              style: GoogleFonts.inter(fontSize: 11, color: AppColors.muted)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
