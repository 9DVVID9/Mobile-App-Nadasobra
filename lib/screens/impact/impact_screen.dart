import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_colors.dart';
import '../../services/impact_service.dart';
import '../../widgets/stat_card.dart';
import '../../widgets/weekly_bar_chart.dart';
import '../../widgets/achievement_badge.dart';

class ImpactScreen extends StatelessWidget {
  const ImpactScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final stats = ImpactService().getStats();

    return Scaffold(
      backgroundColor: AppColors.cream,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: _buildHeader()),
            SliverToBoxAdapter(
              child: _buildStatCards(
                  stats.recipesCooked, stats.foodSavedKg, stats.moneySavedEuros),
            ),
            SliverToBoxAdapter(child: _buildChartCard(stats.weeklyFoodSaved)),
            SliverToBoxAdapter(child: _buildStreakCard(stats.streakDays)),
            SliverToBoxAdapter(
              child: _buildBadges(stats.badges
                  .map((b) => AchievementBadge(badge: b))
                  .toList()),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 100)),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Your impact',
              style: GoogleFonts.fredoka(
                  fontSize: 26,
                  fontWeight: FontWeight.w600,
                  color: AppColors.dark)),
          Text('This week',
              style: GoogleFonts.inter(fontSize: 13, color: AppColors.muted)),
        ],
      ),
    );
  }

  Widget _buildStatCards(int recipes, double food, double money) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: StatCard(
                  value: '$recipes',
                  label: 'Recipes cooked',
                  emoji: '🍳',
                  tint: AppColors.gold),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: StatCard(
                  value: '${food}kg',
                  label: 'Food saved',
                  emoji: '🌱',
                  tint: AppColors.teal),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: StatCard(
                  value: '€${money.toStringAsFixed(0)}',
                  label: 'Money saved',
                  emoji: '💶',
                  tint: AppColors.coral),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChartCard(List<double> weekly) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
              color: AppColors.dark.withValues(alpha: 0.08), width: 1.5),
          boxShadow: AppColors.cardShadow,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Food saved (kg)',
                style: GoogleFonts.fredoka(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.dark)),
            const SizedBox(height: 16),
            WeeklyBarChart(values: weekly),
          ],
        ),
      ),
    );
  }

  Widget _buildStreakCard(int streak) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.gold,
          borderRadius: BorderRadius.circular(20),
          boxShadow: AppColors.cardShadow,
        ),
        child: Row(
          children: [
            const Text('🔥', style: TextStyle(fontSize: 40)),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('$streak day streak',
                    style: GoogleFonts.fredoka(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: AppColors.dark)),
                const SizedBox(height: 4),
                Text('Cook tomorrow to keep going!',
                    style: GoogleFonts.inter(
                        fontSize: 12, color: AppColors.dark)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBadges(List<AchievementBadge> badges) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Achievements',
              style: GoogleFonts.fredoka(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.dark)),
          const SizedBox(height: 16),
          GridView.count(
            crossAxisCount: 4,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 0.75,
            children: badges,
          ),
        ],
      ),
    );
  }
}
