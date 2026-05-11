import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../theme/app_colors.dart';
import '../../models/fridge_item.dart';
import '../../models/recipe.dart';
import '../../services/fridge_service.dart';
import '../../services/recipe_service.dart';
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

  // Fix 3: dynamic time-of-day greeting
  String _greeting() {
    final h = DateTime.now().hour;
    if (h < 12) return 'Buenos días, David';
    if (h < 20) return 'Buenas tardes, David';
    return 'Buenas noches, David';
  }

  Widget _buildHeader(DateTime now) {
    // Fix 5: Spanish locale and format
    final dayFmt = DateFormat("EEEE, d 'de' MMMM", 'es');
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
              Text('Por caducar',
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
                child: Text('Ver todo →',
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
      margin: const EdgeInsets.only(right: 8),
      width: 104, height: 60,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.dark.withValues(alpha: 0.08), width: 1.5),
        boxShadow: AppColors.cardShadow,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(item.emoji, style: const TextStyle(fontSize: 18)),
          const SizedBox(height: 2),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 6, height: 6,
                decoration: BoxDecoration(color: color, shape: BoxShape.circle),
              ),
              const SizedBox(width: 4),
              Text(item.expiryLabel,
                  style: GoogleFonts.inter(fontSize: 11, color: AppColors.muted)),
            ],
          ),
        ],
      ),
    );
  }

  // Fix 2: accept full Recipe object, wire "Ver →" navigation
  Widget _buildRecipeBanner(BuildContext context, Recipe topRecipe) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.teal,
          borderRadius: BorderRadius.circular(24),
          boxShadow: AppColors.elevatedShadow,
        ),
        child: Row(
          children: [
            Text(topRecipe.emoji, style: const TextStyle(fontSize: 36)),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Receta para ti',
                      style: GoogleFonts.inter(fontSize: 11, color: AppColors.white.withValues(alpha: 0.8))),
                  Text(topRecipe.name,
                      style: GoogleFonts.fredoka(
                          fontSize: 17, fontWeight: FontWeight.w600, color: AppColors.white)),
                ],
              ),
            ),
            GestureDetector(
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => RecipeDetailScreen(recipe: topRecipe),
                ),
              ),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                decoration: BoxDecoration(
                  color: AppColors.white, borderRadius: BorderRadius.circular(17)),
                child: Text('Ver →',
                    style: GoogleFonts.fredoka(fontSize: 13, color: AppColors.teal)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeekSummary() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: AppColors.dark.withValues(alpha: 0.08), width: 1.5),
          boxShadow: AppColors.cardShadow,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Tu semana',
                style: GoogleFonts.fredoka(
                    fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.dark)),
            const SizedBox(height: 14),
            Row(
              children: [
                _pill('🌱 3.4 kg salvados', AppColors.gold),
                const SizedBox(width: 10),
                _pill('♻️ 1.2 kg CO₂', AppColors.teal),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _pill(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(label,
          style: GoogleFonts.fredoka(fontSize: 13, color: AppColors.dark)),
    );
  }
}
