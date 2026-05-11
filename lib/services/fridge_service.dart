import '../models/fridge_item.dart';
import '../data/mock_data.dart';

class FridgeService {
  static final FridgeService _instance = FridgeService._();
  factory FridgeService() => _instance;
  FridgeService._();

  final List<FridgeItem> _items = List.from(MockData.fridgeItems);

  List<FridgeItem> getAll() => List.unmodifiable(_items);

  List<FridgeItem> getByCategory(FoodCategory category) =>
      _items.where((i) => i.category == category).toList();

  List<FridgeItem> getExpiringSoon() =>
      _items.where((i) => i.daysUntilExpiry <= 3).toList();

  void add(FridgeItem item) => _items.add(item);

  void remove(String id) => _items.removeWhere((i) => i.id == id);
}
