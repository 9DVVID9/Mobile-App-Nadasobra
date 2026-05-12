import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../theme/app_colors.dart';
import '../../models/fridge_item.dart';
import '../../models/recipe.dart';
import '../../services/fridge_service.dart';
import '../../services/recipe_service.dart';
import '../../services/impact_service.dart';
import '../save/recipe_detail_screen.dart';

class HomeScreen extends StatelessWidget {
  final VoidCallback? onGoToFridge;
  const HomeScreen({super.key, this.onGoToFridge});

  @override
  Widget build(BuildContext context) {
    final expiring = FridgeService().getExpiringSoon();
    final suggested = RecipeService().filterByFridgeIngredients();
    final topRecipe = suggested.isNotEmpty ? suggested.first : null;
    final now = DateTime.now();

    return Scaffold(
      backgroundColor: AppColors.cream,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: _buildHeader(now)),
            SliverToBoxAdapter(child: _buildExpiringSoon(expiring)),
            if (topRecipe != null)
              SliverToBoxAdapter(child: _buildRecipeBanner(context, topRecipe)),
            SliverToBoxAdapter(child: _buildWeekSummary()),
            const SliverToBoxAdapter(child: SizedBox(height: 100)),
          ],
        ),
      ),
    );
  }

  // Time-of-day greeting
  String _greeting() {
    final h = DateTime.now().hour;
    if (h < 12) return 'Good morning, David';
    if (h < 20) return 'Good afternoon, David';
    return 'Good evening, David';
  }

  Widget _buildHeader(DateTime now) {
    final dayFmt = DateFormat('EEEE, MMMM d');
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(dayFmt.format(now),
                    style: GoogleFonts.fredoka(fontSize: 13, color: AppColors.muted)),
                const SizedBox(height: 2),
                // Fix 3: use dynamic greeting
                Text(_greeting(),
                    style: GoogleFonts.fredoka(
                        fontSize: 26, fontWeight: FontWeight.w600, color: AppColors.dark)),
              ],
            ),
          ),
          Container(
            width: 40, height: 40,
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.dark.withValues(alpha: 0.08), width: 1.5),
              boxShadow: AppColors.cardShadow,
            ),
            child: const Center(
              child: Text('🔔', style: TextStyle(fontSize: 18)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExpiringSoon(List<FridgeItem> items) {
    final shown = items.take(3).toList();
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('Expiring soon',
                  style: GoogleFonts.fredoka(
                      fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.dark)),
              const SizedBox(width: 8),
              if (shown.isNotEmpty)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppColors.red, borderRadius: BorderRadius.circular(10)),
                  // Fix 4: badge shows total count, not capped count
                  child: Text('${items.length}',
                      style: GoogleFonts.fredoka(fontSize: 12, color: AppColors.white)),
                ),
              const Spacer(),
              GestureDetector(
                onTap: onGoToFridge,
                child: Text('View all →',
                    style: GoogleFonts.inter(fontSize: 12, color: AppColors.teal)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Fix 1: wrap chip row in horizontal scroll
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: shown.map((item) => _buildExpiryChip(item)).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExpiryChip(FridgeItem item) {
    final color = item.expiryStatus == ExpiryStatus.expiring
        ? AppColors.red
        : item.expiryStatus == ExpiryStatus.soonExpiring
            ? AppColors.amber
            : AppColors.green;

    return Container(
      margin: const EdgeInsets.only(right: 12),
      width: 104,
      height: 68,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        border:
            Border.all(color: AppColors.dark.withValues(alpha: 0.08), width: 2),
        boxShadow: AppColors.cardShadow,
      ),
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Container(
                width: 10,
                height: 10,
                decoration:
                    BoxDecoration(color: color, shape: BoxShape.circle),
              ),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  item.name,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      height: 1.2,
                      color: AppColors.dark),
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),
          Padding(
            padding: const EdgeInsets.only(left: 16),
            child: Text(
              item.expiryLabel,
              style: GoogleFonts.inter(
                  fontSize: 11, height: 1.2, color: AppColors.muted),
            ),
          ),
        ],
      ),
    );
  }

  // Recipe banner with caption/title/subtitle stacked + CTA pill on right
  Widget _buildRecipeBanner(BuildContext context, Recipe topRecipe) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 16, 16, 16),
        decoration: BoxDecoration(
          color: AppColors.teal,
          borderRadius: BorderRadius.circular(24),
          boxShadow: AppColors.elevatedShadow,
        ),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('What to cook today?',
                    style: GoogleFonts.inter(
                        fontSize: 12, color: AppColors.white)),
                const SizedBox(height: 6),
                Text(topRecipe.name,
                    style: GoogleFonts.fredoka(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: AppColors.white)),
                const SizedBox(height: 6),
                Text('With what you have at home',
                    style: GoogleFonts.inter(
                        fontSize: 13,
                        color: AppColors.white.withValues(alpha: 0.8))),
              ],
            ),
            Positioned(
              right: 0,
              bottom: 0,
              child: GestureDetector(
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => RecipeDetailScreen(recipe: topRecipe),
                  ),
                ),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 9),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(17),
                  ),
                  child: Text('View recipe →',
                      style: GoogleFonts.inter(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: AppColors.teal)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeekSummary() {
    final stats = ImpactService().getStats();
    final foodLabel = stats.foodSavedKg < 1
        ? '${(stats.foodSavedKg * 1000).round()}g saved'
        : '${stats.foodSavedKg}kg saved';

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
              color: AppColors.dark.withValues(alpha: 0.08), width: 2),
          boxShadow: AppColors.cardShadow,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Your week',
                style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.dark)),
            const SizedBox(height: 10),
            Container(
                height: 1, color: AppColors.dark.withValues(alpha: 0.06)),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                    child: _pill(
                        '${stats.recipesCooked} recipes cooked', AppColors.gold)),
                const SizedBox(width: 10),
                Expanded(child: _pill(foodLabel, AppColors.teal)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _pill(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(label,
          style: GoogleFonts.fredoka(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: AppColors.dark)),
    );
  }
}
