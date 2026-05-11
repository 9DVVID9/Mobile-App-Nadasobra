import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_colors.dart';
import '../../models/recipe.dart';
import '../../services/recipe_service.dart';
import '../../widgets/recipe_card.dart';
import 'recipe_detail_screen.dart';

class SaveScreen extends StatefulWidget {
  const SaveScreen({super.key});

  @override
  State<SaveScreen> createState() => _SaveScreenState();
}

class _SaveScreenState extends State<SaveScreen> {
  final _service = RecipeService();
  bool _onlyWithFridge = false;

  List<Recipe> get _recipes =>
      _onlyWithFridge ? _service.filterByFridgeIngredients() : _service.getAll();

  void _openDetail(Recipe recipe) {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondary) =>
            RecipeDetailScreen(recipe: recipe),
        transitionsBuilder: (context, animation, secondary, child) =>
            FadeTransition(opacity: animation, child: child),
        transitionDuration: const Duration(milliseconds: 250),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: _buildHeader()),
            SliverToBoxAdapter(child: _buildBanner()),
            SliverToBoxAdapter(child: _buildFilterChips()),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 100),
              sliver: _buildGrid(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Row(
        children: [
          Text('Recetas',
              style: GoogleFonts.fredoka(
                  fontSize: 26,
                  fontWeight: FontWeight.w600,
                  color: AppColors.dark)),
          const Spacer(),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                  color: AppColors.dark.withValues(alpha: 0.08), width: 1.5),
              boxShadow: AppColors.cardShadow,
            ),
            child: const Icon(Icons.search_rounded,
                color: AppColors.muted, size: 20),
          ),
        ],
      ),
    );
  }

  Widget _buildBanner() {
    final matchCount = _service.filterByFridgeIngredients().length;
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.gold.withValues(alpha: 0.25),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.gold, width: 1.5),
        ),
        child: Row(
          children: [
            const Text('✨', style: TextStyle(fontSize: 20)),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                'Con lo que tienes · $matchCount recetas posibles',
                style: GoogleFonts.fredoka(fontSize: 13, color: AppColors.dark),
              ),
            ),
            const Icon(Icons.chevron_right_rounded,
                color: AppColors.dark, size: 18),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChips() {
    const chips = ['Todas', 'Con mi nevera', 'Rápidas (<20 min)', 'Vegetarianas'];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
      child: Row(
        children: List.generate(chips.length, (i) {
          final active = i == 0 ? !_onlyWithFridge : (i == 1 ? _onlyWithFridge : false);
          return GestureDetector(
            onTap: () => setState(() => _onlyWithFridge = i == 1),
            child: Container(
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: active ? AppColors.teal : AppColors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                    color: AppColors.dark.withValues(alpha: 0.08), width: 1.5),
                boxShadow: AppColors.cardShadow,
              ),
              child: Text(chips[i],
                  style: GoogleFonts.fredoka(
                      fontSize: 13,
                      color: active ? AppColors.white : AppColors.dark)),
            ),
          );
        }),
      ),
    );
  }

  SliverGrid _buildGrid() {
    final recipes = _recipes;
    return SliverGrid(
      delegate: SliverChildBuilderDelegate(
        (_, i) => RecipeCard(
            recipe: recipes[i], onTap: () => _openDetail(recipes[i])),
        childCount: recipes.length,
      ),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 0.85,
      ),
    );
  }
}
