import 'badge_model.dart';

class ImpactStats {
  final int recipesCooked;
  final double foodSavedKg;
  final double moneySavedEuros;
  final int streakDays;
  final List<double> weeklyFoodSaved; // 7 values Mon→Sun
  final List<BadgeModel> badges;

  ImpactStats({
    required this.recipesCooked,
    required this.foodSavedKg,
    required this.moneySavedEuros,
    required this.streakDays,
    required this.weeklyFoodSaved,
    required this.badges,
  }) : assert(weeklyFoodSaved.length == 7, 'weeklyFoodSaved must have exactly 7 values');
}
