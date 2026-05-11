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

  int get daysUntilExpiry =>
      expiryDate.difference(DateTime.now()).inDays;

  ExpiryStatus get expiryStatus {
    if (daysUntilExpiry <= 1) return ExpiryStatus.expiring;
    if (daysUntilExpiry <= 3) return ExpiryStatus.soonExpiring;
    return ExpiryStatus.fresh;
  }

  String get expiryLabel {
    if (daysUntilExpiry <= 0) return 'Today!';
    if (daysUntilExpiry == 1) return '1 day';
    return '${daysUntilExpiry}d';
  }
}
