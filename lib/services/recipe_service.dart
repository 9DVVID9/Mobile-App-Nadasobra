import '../models/recipe.dart';
import '../data/mock_data.dart';
import 'fridge_service.dart';

class RecipeService {
  static final RecipeService _instance = RecipeService._();
  factory RecipeService() => _instance;
  RecipeService._();

  final List<Recipe> _recipes = List.from(MockData.recipes);
  final _fridge = FridgeService();

  List<Recipe> getAll() => List.unmodifiable(_recipes);

  List<Recipe> filterByFridgeIngredients() {
    final fridgeNames = _fridge.getAll()
        .map((i) => i.name.toLowerCase())
        .toSet();
    return _recipes
        .where((r) => r.ingredientNames
            .any((ing) => fridgeNames.contains(ing.toLowerCase())))
        .toList();
  }
}
