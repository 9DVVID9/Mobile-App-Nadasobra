import '../models/fridge_item.dart';
import '../models/recipe.dart';
import '../models/impact_stats.dart';
import '../models/badge_model.dart';

class MockData {
  static final List<FridgeItem> fridgeItems = [
    FridgeItem(
      id: 'f1', name: 'Eggs', emoji: '🥚',
      category: FoodCategory.proteins, quantity: '6 units',
      expiryDate: DateTime.now().add(const Duration(days: 1)),
    ),
    FridgeItem(
      id: 'f2', name: 'Broccoli', emoji: '🥦',
      category: FoodCategory.vegetables, quantity: '1 head',
      expiryDate: DateTime.now().add(const Duration(days: 2)),
    ),
    FridgeItem(
      id: 'f3', name: 'Cheese', emoji: '🧀',
      category: FoodCategory.dairy, quantity: '200g',
      expiryDate: DateTime.now().add(const Duration(days: 3)),
    ),
    FridgeItem(
      id: 'f4', name: 'Chicken', emoji: '🍗',
      category: FoodCategory.proteins, quantity: '500g',
      expiryDate: DateTime.now().add(const Duration(days: 5)),
    ),
    FridgeItem(
      id: 'f5', name: 'Tomatoes', emoji: '🍅',
      category: FoodCategory.vegetables, quantity: '4 units',
      expiryDate: DateTime.now().add(const Duration(days: 7)),
    ),
    FridgeItem(
      id: 'f6', name: 'Milk', emoji: '🥛',
      category: FoodCategory.dairy, quantity: '1L',
      expiryDate: DateTime.now().add(const Duration(days: 4)),
    ),
  ];

  static final List<Recipe> recipes = [
    const Recipe(
      id: 'r1', name: 'Tortilla de Brócoli', emoji: '🍳',
      ingredientNames: ['Eggs', 'Broccoli', 'Onion', 'Salt'],
      steps: [
        'Beat 4 eggs with salt and pepper.',
        'Sauté broccoli florets for 4 min.',
        'Mix with eggs and cook on medium heat for 6 min.',
      ],
      durationMinutes: 15, difficulty: 'Easy', co2SavedKg: 0.4,
      tag: RecipeTag.usesExpiring,
      vegetarian: true,
      imagePath: 'assets/recipes/tortilla-de-brocoli.jpg',
    ),
    const Recipe(
      id: 'r2', name: 'Pasta con Tomate', emoji: '🍝',
      ingredientNames: ['Tomatoes', 'Pasta', 'Garlic', 'Basil'],
      steps: [
        'Cook the pasta according to package directions.',
        'Sauté chopped garlic for 2 min and add diced tomatoes.',
        'Cook 10 min, toss with pasta and add basil.',
      ],
      durationMinutes: 20, difficulty: 'Easy', co2SavedKg: 0.3,
      tag: RecipeTag.usesExpiring,
      vegetarian: true,
      imagePath: 'assets/recipes/pasta-con-tomate.jpeg',
    ),
    const Recipe(
      id: 'r3', name: 'Pollo a la Plancha', emoji: '🍗',
      ingredientNames: ['Chicken', 'Lemon', 'Rosemary', 'Oil'],
      steps: [
        'Marinate the chicken with lemon and rosemary for 15 min.',
        'Cook on a hot griddle for 6 min per side.',
        'Rest 3 min before serving.',
      ],
      durationMinutes: 35, difficulty: 'Medium', co2SavedKg: 0.6,
      tag: RecipeTag.protein,
      imagePath: 'assets/recipes/pollo.jpg',
    ),
    const Recipe(
      id: 'r4', name: 'Queso Gratinado', emoji: '🧀',
      ingredientNames: ['Cheese', 'Bread', 'Tomatoes', 'Oregano'],
      steps: [
        'Slice the bread and top each slice with tomato.',
        'Add grated cheese and oregano.',
        'Broil 5 min until golden.',
      ],
      durationMinutes: 10, difficulty: 'Easy', co2SavedKg: 0.2,
      tag: RecipeTag.usesExpiring,
      vegetarian: true,
      imagePath: 'assets/recipes/gratinado.jpg',
    ),
    const Recipe(
      id: 'r5', name: 'Arroz con Verduras', emoji: '🍚',
      ingredientNames: ['Rice', 'Broccoli', 'Carrot', 'Soy sauce'],
      steps: [
        'Cook the rice for 18 min in twice its volume of water.',
        'Stir-fry the vegetables for 5 min with soy sauce.',
        'Mix rice with vegetables and serve hot.',
      ],
      durationMinutes: 25, difficulty: 'Easy', co2SavedKg: 0.5,
      tag: RecipeTag.pantry,
      vegetarian: true,
      imagePath: 'assets/recipes/apetitoso-arroz.jpg',
    ),
    const Recipe(
      id: 'r6', name: 'Revuelto de Huevos', emoji: '🥗',
      ingredientNames: ['Eggs', 'Tomatoes', 'Cheese', 'Spinach'],
      steps: [
        'Sauté spinach and tomato for 2 min.',
        'Add beaten eggs and stir constantly.',
        'Remove from heat before fully set and top with cheese.',
      ],
      durationMinutes: 10, difficulty: 'Easy', co2SavedKg: 0.35,
      tag: RecipeTag.usesExpiring,
      vegetarian: true,
      imagePath: 'assets/recipes/revuelto-de-huevo.jpg',
    ),
    const Recipe(
      id: 'r7', name: 'Sopa de Lentejas', emoji: '🍲',
      ingredientNames: ['Lentils', 'Onion', 'Carrot', 'Tomato', 'Bay leaf'],
      steps: [
        'Sauté chopped onion and diced carrot for 5 min.',
        'Add lentils, chopped tomato, bay leaf and 1L water.',
        'Simmer 30 min, season with salt and serve hot.',
      ],
      durationMinutes: 40, difficulty: 'Easy', co2SavedKg: 0.55,
      tag: RecipeTag.pantry,
      vegetarian: true,
      imagePath: 'assets/recipes/sopa-de-lentejas.jpg',
    ),
    const Recipe(
      id: 'r8', name: 'Hamburguesa Casera', emoji: '🍔',
      ingredientNames: ['Beef', 'Bread', 'Cheese', 'Lettuce', 'Tomato'],
      steps: [
        'Shape the beef into patties and season with salt and pepper.',
        'Cook on a hot pan 4 min per side until juicy.',
        'Toast the bread and layer with lettuce, tomato, patty and cheese.',
      ],
      durationMinutes: 20, difficulty: 'Medium', co2SavedKg: 0.35,
      tag: RecipeTag.protein,
      imagePath: 'assets/recipes/hamburguesa-casera.jpg',
    ),
    const Recipe(
      id: 'r9', name: 'Crema de Calabaza', emoji: '🎃',
      ingredientNames: ['Pumpkin', 'Onion', 'Garlic', 'Milk', 'Salt'],
      steps: [
        'Sauté chopped onion and garlic for 3 min, then add cubed pumpkin.',
        'Cover with water and simmer 20 min until tender.',
        'Blend with milk and salt to a creamy texture.',
      ],
      durationMinutes: 30, difficulty: 'Easy', co2SavedKg: 0.4,
      tag: RecipeTag.usesExpiring,
      vegetarian: true,
      imagePath: 'assets/recipes/crema-de-calabaza.jpg',
    ),
    const Recipe(
      id: 'r10', name: 'Salmón al Horno', emoji: '🐟',
      ingredientNames: ['Salmon', 'Lemon', 'Garlic', 'Olive oil', 'Parsley'],
      steps: [
        'Preheat the oven to 200°C and place the salmon on a tray.',
        'Drizzle with oil, lemon juice, chopped garlic and parsley.',
        'Bake 15 min until flaky and golden.',
      ],
      durationMinutes: 25, difficulty: 'Medium', co2SavedKg: 0.45,
      tag: RecipeTag.protein,
      imagePath: 'assets/recipes/salmon-al-horno.jpg',
    ),
  ];

  static ImpactStats get impactStats => ImpactStats(
    recipesCooked: 12,
    foodSavedKg: 3.4,
    moneySavedEuros: 18.5,
    streakDays: 5,
    weeklyFoodSaved: List.unmodifiable([0.2, 0.5, 0.3, 0.8, 0.6, 0.7, 0.3]),
    badges: const [
      BadgeModel(emoji: '🌱', name: 'First time', earned: true),
      BadgeModel(emoji: '🔥', name: '5-day streak', earned: true),
      BadgeModel(emoji: '♻️', name: 'Zero-waste week', earned: true),
      BadgeModel(emoji: '⭐', name: 'Master chef', earned: false),
    ],
  );
}
