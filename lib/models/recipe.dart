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
  });

  // Maps tag to the card accent color strip
  Color get accentColor {
    switch (tag) {
      case RecipeTag.usesExpiring: return const Color(0xFF00C896); // teal
      case RecipeTag.protein:      return const Color(0xFFFF7A59); // coral
      case RecipeTag.pantry:       return const Color(0xFFFFD66B); // gold
    }
  }
}
