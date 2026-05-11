import '../models/fridge_item.dart';
import '../models/recipe.dart';
import '../models/impact_stats.dart';
import '../models/badge_model.dart';

class MockData {
  static final List<FridgeItem> fridgeItems = [
    FridgeItem(
      id: 'f1', name: 'Huevos', emoji: '🥚',
      category: FoodCategory.proteins, quantity: '6 units',
      expiryDate: DateTime.now().add(const Duration(days: 1)),
    ),
    FridgeItem(
      id: 'f2', name: 'Brócoli', emoji: '🥦',
      category: FoodCategory.vegetables, quantity: '1 head',
      expiryDate: DateTime.now().add(const Duration(days: 2)),
    ),
    FridgeItem(
      id: 'f3', name: 'Queso', emoji: '🧀',
      category: FoodCategory.dairy, quantity: '200g',
      expiryDate: DateTime.now().add(const Duration(days: 3)),
    ),
    FridgeItem(
      id: 'f4', name: 'Pollo', emoji: '🍗',
      category: FoodCategory.proteins, quantity: '500g',
      expiryDate: DateTime.now().add(const Duration(days: 5)),
    ),
    FridgeItem(
      id: 'f5', name: 'Tomates', emoji: '🍅',
      category: FoodCategory.vegetables, quantity: '4 units',
      expiryDate: DateTime.now().add(const Duration(days: 7)),
    ),
    FridgeItem(
      id: 'f6', name: 'Leche', emoji: '🥛',
      category: FoodCategory.dairy, quantity: '1L',
      expiryDate: DateTime.now().add(const Duration(days: 4)),
    ),
  ];

  static final List<Recipe> recipes = [
    const Recipe(
      id: 'r1', name: 'Tortilla de Brócoli', emoji: '🍳',
      ingredientNames: ['Huevos', 'Brócoli', 'Cebolla', 'Sal'],
      steps: [
        'Bate 4 huevos con sal y pimienta.',
        'Saltea el brócoli en trozos pequeños durante 4 min.',
        'Mezcla con los huevos y cocina a fuego medio 6 min.',
      ],
      durationMinutes: 15, difficulty: 'Easy', co2SavedKg: 0.4,
      tag: RecipeTag.usesExpiring,
    ),
    const Recipe(
      id: 'r2', name: 'Pasta con Tomate', emoji: '🍝',
      ingredientNames: ['Tomates', 'Pasta', 'Ajo', 'Albahaca'],
      steps: [
        'Cuece la pasta según el paquete.',
        'Sofríe ajo picado 2 min y añade tomates troceados.',
        'Cocina 10 min, mezcla con pasta y añade albahaca.',
      ],
      durationMinutes: 20, difficulty: 'Easy', co2SavedKg: 0.3,
      tag: RecipeTag.usesExpiring,
    ),
    const Recipe(
      id: 'r3', name: 'Pollo a la Plancha', emoji: '🍗',
      ingredientNames: ['Pollo', 'Limón', 'Romero', 'Aceite'],
      steps: [
        'Marina el pollo con limón y romero 15 min.',
        'Cocina en plancha caliente 6 min por lado.',
        'Reposa 3 min antes de servir.',
      ],
      durationMinutes: 25, difficulty: 'Medium', co2SavedKg: 0.6,
      tag: RecipeTag.protein,
    ),
    const Recipe(
      id: 'r4', name: 'Queso Gratinado', emoji: '🧀',
      ingredientNames: ['Queso', 'Pan', 'Tomates', 'Orégano'],
      steps: [
        'Corta el pan en rebanadas y cúbrelas de tomate.',
        'Añade queso rallado y orégano.',
        'Gratina 5 min hasta dorar.',
      ],
      durationMinutes: 10, difficulty: 'Easy', co2SavedKg: 0.2,
      tag: RecipeTag.usesExpiring,
    ),
    const Recipe(
      id: 'r5', name: 'Arroz con Verduras', emoji: '🍚',
      ingredientNames: ['Arroz', 'Brócoli', 'Zanahoria', 'Soja'],
      steps: [
        'Cuece el arroz 18 min con el doble de agua.',
        'Saltea las verduras 5 min con salsa de soja.',
        'Mezcla arroz con verduras y sirve caliente.',
      ],
      durationMinutes: 25, difficulty: 'Easy', co2SavedKg: 0.5,
      tag: RecipeTag.pantry,
    ),
    const Recipe(
      id: 'r6', name: 'Revuelto de Huevos', emoji: '🥗',
      ingredientNames: ['Huevos', 'Tomates', 'Queso', 'Espinacas'],
      steps: [
        'Saltea espinacas y tomate 2 min.',
        'Añade huevos batidos y remueve constantemente.',
        'Retira del fuego antes de cuajar del todo y añade queso.',
      ],
      durationMinutes: 10, difficulty: 'Easy', co2SavedKg: 0.35,
      tag: RecipeTag.usesExpiring,
    ),
  ];

  static ImpactStats get impactStats => ImpactStats(
    recipesCooked: 12,
    foodSavedKg: 3.4,
    moneySavedEuros: 18.5,
    streakDays: 5,
    weeklyFoodSaved: List.unmodifiable([0.2, 0.5, 0.3, 0.8, 0.6, 0.7, 0.3]),
    badges: const [
      BadgeModel(emoji: '🌱', name: 'Primera vez', earned: true),
      BadgeModel(emoji: '🔥', name: 'Racha de 5 días', earned: true),
      BadgeModel(emoji: '♻️', name: 'Semana sin residuos', earned: true),
      BadgeModel(emoji: '⭐', name: 'Maestro cocinero', earned: false),
    ],
  );
}
