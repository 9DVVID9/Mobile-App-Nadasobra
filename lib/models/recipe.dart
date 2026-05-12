import 'package:flutter/material.dart';

enum RecipeTag { usesExpiring, protein, pantry }

class Recipe {
  final String id;
  final String name;
  final String emoji;
  final List<String> ingredientNames;
  final List<String> steps;
  final int durationMinutes;
  final String difficulty;
  final double co2SavedKg;
  final RecipeTag tag;
  // When set, RecipeCard / detail show this asset instead of the emoji.
  // Asset path is resolved from `assets/recipes/` registered in pubspec.yaml.
  final String? imagePath;

  const Recipe({
    required this.id,
    required this.name,
    required this.emoji,
    required this.ingredientNames,
    required this.steps,
    required this.durationMinutes,
    required this.difficulty,
    required this.co2SavedKg,
    required this.tag,
    this.imagePath,
  });

  // Tile background per tag (mint / peach / sand) — Figma palette.
  Color get tileColor {
    switch (tag) {
      case RecipeTag.usesExpiring: return const Color(0xFFC2EFDF); // mint
      case RecipeTag.protein:      return const Color(0xFFFFD9C7); // peach
      case RecipeTag.pantry:       return const Color(0xFFFFE8B3); // sand
    }
  }

  // Legacy accent (kept for backwards compatibility — not used by new card layout).
  Color get accentColor {
    switch (tag) {
      case RecipeTag.usesExpiring: return const Color(0xFF00C896);
      case RecipeTag.protein:      return const Color(0xFFFF7A59);
      case RecipeTag.pantry:       return const Color(0xFFFFD66B);
    }
  }
}
