import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_colors.dart';

class WeeklyBarChart extends StatelessWidget {
  final List<double> values; // 7 values Mon→Sun
  const WeeklyBarChart({super.key, required this.values});

  static const _days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];

  @override
  Widget build(BuildContext context) {
    final todayIndex = DateTime.now().weekday - 1; // Mon=0
    final maxVal = values.reduce((a, b) => a > b ? a : b);

    return SizedBox(
      height: 160,
      child: BarChart(
        BarChartData(
          maxY: (maxVal * 1.4).ceilToDouble(),
          gridData: const FlGridData(show: false),
          borderData: FlBorderData(show: false),
          titlesData: FlTitlesData(
            leftTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false)),
            rightTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false)),
            topTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (val, meta) => Text(
                  _days[val.toInt()],
                  style: GoogleFonts.fredoka(
                      fontSize: 12, color: AppColors.muted),
                ),
              ),
            ),
          ),
          barGroups: List.generate(
            7,
            (i) => BarChartGroupData(
              x: i,
              barRods: [
                BarChartRodData(
                  toY: values[i],
                  width: 28,
                  borderRadius: BorderRadius.circular(8),
                  color: i == todayIndex
                      ? AppColors.gold
                      : AppColors.teal.withValues(alpha: 0.6),
                ),
              ],
            ),
          ),
        ),
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOut,
      ),
    );
  }
}
