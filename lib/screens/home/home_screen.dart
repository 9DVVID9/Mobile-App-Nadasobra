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
            SliverToBoxAdapter(child: _buildDailyTip(now)),
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

  // Hero recipe banner — uses the recipe's own photo as background with a
  // dark gradient so white copy reads. Falls back to teal if no image.
  Widget _buildRecipeBanner(BuildContext context, Recipe topRecipe) {
    final hasImage = topRecipe.imagePath != null;
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: GestureDetector(
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => RecipeDetailScreen(recipe: topRecipe),
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: Container(
            height: 190,
            decoration: BoxDecoration(
              color: AppColors.teal,
              image: hasImage
                  ? DecorationImage(
                      image: AssetImage(topRecipe.imagePath!),
                      fit: BoxFit.cover,
                    )
                  : null,
              boxShadow: AppColors.elevatedShadow,
            ),
            child: Stack(
              fit: StackFit.expand,
              children: [
                // Dark gradient overlay — stronger at the bottom for text legibility
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withValues(alpha: 0.0),
                        Colors.black.withValues(alpha: 0.55),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 16, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Caption pill at top — a small badge so it doesn't get lost
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: AppColors.white.withValues(alpha: 0.95),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text('What to cook today?',
                            style: GoogleFonts.fredoka(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: AppColors.dark)),
                      ),
                      const Spacer(),
                      Text(topRecipe.name,
                          style: GoogleFonts.fredoka(
                              fontSize: 24,
                              fontWeight: FontWeight.w600,
                              height: 1.1,
                              color: AppColors.white)),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                                '${topRecipe.durationMinutes} min · with what you have',
                                style: GoogleFonts.inter(
                                    fontSize: 12,
                                    color: AppColors.white
                                        .withValues(alpha: 0.9))),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 8),
                            decoration: BoxDecoration(
                              color: AppColors.white,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Text('View →',
                                style: GoogleFonts.fredoka(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.teal)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // 7 rotating sustainability / kitchen tips — one per weekday so the home
  // page changes flavour as the week goes on.
  static const _dailyTips = [
    'Store tomatoes outside the fridge — they keep more flavor.',
    'An egg that sinks in water is fresh. If it floats, throw it.',
    'Spain wastes 1.3 billion kg of food every year.',
    'Wilted greens revive after 10 min in a bowl of ice water.',
    'A third of all food produced globally is wasted.',
    'Freezing herbs in olive oil keeps them fresh for months.',
    'Households throw away around €600 of food per year on average.',
  ];

  Widget _buildDailyTip(DateTime now) {
    final tip = _dailyTips[(now.weekday - 1) % _dailyTips.length];
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
        decoration: BoxDecoration(
          color: AppColors.statGoldBg,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: const BoxDecoration(
                color: AppColors.gold,
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: const Text('💡', style: TextStyle(fontSize: 18)),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Did you know?',
                      style: GoogleFonts.fredoka(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.dark.withValues(alpha: 0.6))),
                  const SizedBox(height: 3),
                  Text(tip,
                      style: GoogleFonts.inter(
                          fontSize: 13,
                          height: 1.35,
                          color: AppColors.dark)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Hero "this week" card — big proud number with personality, instead of
  // the previous pair of small pills.
  Widget _buildWeekSummary() {
    final stats = ImpactService().getStats();
    final isKg = stats.foodSavedKg >= 1;
    final amount = isKg
        ? stats.foodSavedKg.toStringAsFixed(1)
        : (stats.foodSavedKg * 1000).round().toString();
    final unit = isKg ? 'kg' : 'g';

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 18, 20, 18),
        decoration: BoxDecoration(
          color: AppColors.statMintBg,
          borderRadius: BorderRadius.circular(24),
          boxShadow: AppColors.cardShadow,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text('🌱', style: TextStyle(fontSize: 18)),
                const SizedBox(width: 8),
                Text('This week',
                    style: GoogleFonts.fredoka(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.dark.withValues(alpha: 0.7))),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(amount,
                    style: GoogleFonts.fredoka(
                        fontSize: 52,
                        fontWeight: FontWeight.w600,
                        height: 1.0,
                        color: AppColors.dark)),
                const SizedBox(width: 4),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(unit,
                      style: GoogleFonts.fredoka(
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                          color: AppColors.teal)),
                ),
                const SizedBox(width: 8),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Text('of food saved',
                      style: GoogleFonts.inter(
                          fontSize: 13,
                          color: AppColors.dark.withValues(alpha: 0.7))),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Container(
                height: 1, color: AppColors.dark.withValues(alpha: 0.08)),
            const SizedBox(height: 12),
            Row(
              children: [
                _miniStat('🍳', '${stats.recipesCooked}', 'recipes'),
                const SizedBox(width: 24),
                _miniStat('💶',
                    '€${stats.moneySavedEuros.toStringAsFixed(0)}', 'saved'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _miniStat(String emoji, String value, String label) {
    return Row(
      children: [
        Text(emoji, style: const TextStyle(fontSize: 16)),
        const SizedBox(width: 6),
        Text(value,
            style: GoogleFonts.fredoka(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.dark)),
        const SizedBox(width: 4),
        Text(label,
            style: GoogleFonts.inter(
                fontSize: 12,
                color: AppColors.dark.withValues(alpha: 0.6))),
      ],
    );
  }
}
