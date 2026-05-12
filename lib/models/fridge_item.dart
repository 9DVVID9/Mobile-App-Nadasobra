import 'package:uuid/uuid.dart';

enum ExpiryStatus { expiring, soonExpiring, fresh }
enum FoodCategory { vegetables, dairy, proteins, other }

class FridgeItem {
  final String id;
  final String name;
  final String emoji;
  final FoodCategory category;
  final String quantity;
  final DateTime expiryDate;

  FridgeItem({
    String? id,
    required this.name,
    required this.emoji,
    required this.category,
    required this.quantity,
    required this.expiryDate,
  }) : id = id ?? const Uuid().v4();

  int get daysUntilExpiry {
    final today = DateTime.now();
    final todayDate = DateTime(today.year, today.month, today.day);
    final expiryDateOnly = DateTime(expiryDate.year, expiryDate.month, expiryDate.day);
    return expiryDateOnly.difference(todayDate).inDays;
  }

  ExpiryStatus get expiryStatus {
    if (daysUntilExpiry <= 1) return ExpiryStatus.expiring;
    if (daysUntilExpiry <= 3) return ExpiryStatus.soonExpiring;
    return ExpiryStatus.fresh;
  }

  String get expiryLabel {
    final d = daysUntilExpiry;
    if (d < 0) return 'Expired';
    if (d == 0) return 'Today';
    if (d == 1) return 'Tomorrow';
    if (d < 7) return '$d days';
    if (d == 7) return '1 week';
    if (d < 14) return '$d days';
    final weeks = (d / 7).floor();
    return '$weeks weeks';
  }
}
