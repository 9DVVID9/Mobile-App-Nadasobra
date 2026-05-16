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
  final _searchController = TextEditingController();
  final _searchFocus = FocusNode();
  bool _onlyWithFridge = false;
  bool _quick = false;
  bool _vegetarian = false;
  bool _under30 = false;
  bool _searchOpen = false;
  String _searchQuery = '';

  // Search overrides fridge filter when active; chip filters always apply on top.
  List<Recipe> get _recipes {
    Iterable<Recipe> list;
    if (_searchQuery.isNotEmpty) {
      final q = _searchQuery.toLowerCase();
      list = _service.getAll().where((r) => r.name.toLowerCase().contains(q));
    } else if (_onlyWithFridge) {
      list = _service.filterByFridgeIngredients();
    } else {
      list = _service.getAll();
    }
    if (_quick) list = list.where((r) => r.durationMinutes <= 15);
    if (_vegetarian) list = list.where((r) => r.vegetarian);
    if (_under30) list = list.where((r) => r.durationMinutes < 30);
    return list.toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocus.dispose();
    super.dispose();
  }

  void _toggleSearch() {
    setState(() {
      _searchOpen = !_searchOpen;
      if (!_searchOpen) {
        _searchController.clear();
        _searchQuery = '';
        _searchFocus.unfocus();
      }
    });
    if (_searchOpen) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _searchFocus.requestFocus());
    }
  }

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
            if (!_searchOpen) SliverToBoxAdapter(child: _buildBanner()),
            if (!_searchOpen) SliverToBoxAdapter(child: _buildFilterChips()),
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
    if (_searchOpen) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
        child: Row(
          children: [
            Expanded(
              child: Container(
                height: 44,
                padding: const EdgeInsets.symmetric(horizontal: 14),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                      color: AppColors.dark.withValues(alpha: 0.08), width: 1.5),
                  boxShadow: AppColors.cardShadow,
                ),
                child: Row(
                  children: [
                    const Icon(Icons.search_rounded,
                        color: AppColors.muted, size: 18),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        focusNode: _searchFocus,
                        onChanged: (v) => setState(() => _searchQuery = v),
                        style: GoogleFonts.inter(
                            fontSize: 14, color: AppColors.dark),
                        decoration: InputDecoration(
                          hintText: 'Search recipes...',
                          hintStyle: GoogleFonts.inter(
                              fontSize: 13, color: AppColors.muted),
                          border: InputBorder.none,
                          isCollapsed: true,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 10),
            GestureDetector(
              onTap: _toggleSearch,
              child: Text('Cancel',
                  style: GoogleFonts.fredoka(
                      fontSize: 14, color: AppColors.teal)),
            ),
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Row(
        children: [
          Text('Recipes',
              style: GoogleFonts.fredoka(
                  fontSize: 26,
                  fontWeight: FontWeight.w600,
                  color: AppColors.dark)),
          const Spacer(),
          GestureDetector(
            onTap: _toggleSearch,
            child: Container(
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
                'With what you have · $matchCount possible recipes',
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
    final chips = [
      ('With what I have', _onlyWithFridge, () => setState(() => _onlyWithFridge = !_onlyWithFridge)),
      ('Quick', _quick, () => setState(() => _quick = !_quick)),
      ('Vegetarian', _vegetarian, () => setState(() => _vegetarian = !_vegetarian)),
      ('Under 30 min', _under30, () => setState(() => _under30 = !_under30)),
    ];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Row(
        children: chips.map((chip) {
          final (label, active, onTap) = chip;
          return GestureDetector(
            onTap: onTap,
            child: Container(
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
              decoration: BoxDecoration(
                color: active ? AppColors.teal : AppColors.white,
                borderRadius: BorderRadius.circular(18),
                border: active
                    ? null
                    : Border.all(
                        color: AppColors.dark.withValues(alpha: 0.08),
                        width: 2),
              ),
              child: Text(active ? '$label ✓' : label,
                  style: GoogleFonts.fredoka(
                      fontSize: 13,
                      fontWeight: active ? FontWeight.w600 : FontWeight.w500,
                      color: active ? AppColors.white : AppColors.dark)),
            ),
          );
        }).toList(),
      ),
    );
  }

  // Returns a sliver — either the grid or an empty-state placeholder.
  Widget _buildGrid() {
    final recipes = _recipes;
    if (recipes.isEmpty) {
      return SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.only(top: 60),
          child: Center(
            child: Column(
              children: [
                const Text('🔍', style: TextStyle(fontSize: 48)),
                const SizedBox(height: 12),
                Text('No recipes match',
                    style: GoogleFonts.fredoka(
                        fontSize: 16, color: AppColors.muted)),
              ],
            ),
          ),
        ),
      );
    }
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
