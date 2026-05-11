import 'package:flutter/material.dart';
import '../../models/recipe.dart';
class RecipeDetailScreen extends StatelessWidget {
  final Recipe recipe;
  const RecipeDetailScreen({super.key, required this.recipe});
  @override
  Widget build(BuildContext context) => Scaffold(
    body: Center(child: Text(recipe.name)));
}
