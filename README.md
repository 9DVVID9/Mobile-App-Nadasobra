# NadaSobra

**Tu cocina, sin desperdicio.** *(Your kitchen, zero waste.)*

A Flutter mobile app for reducing household food waste. NadaSobra helps you track
what's in your fridge before it expires, find recipes for the ingredients you
already have, and see the real impact of cooking instead of throwing food away.

Developed for the **User Interfaces / HCI** course (3rd-year Computer
Engineering) as part of the **II Sustainability Challenge** at the European
University of Madrid (Universidad Europea de Madrid).

---

## Team

- **Iancu David**
- **Ali Kaan**
- **Omer Oz**

---

## Description

A third of all food produced in the world is wasted (FAO). A large share of that
happens at home — food bought, forgotten, and binned. NadaSobra targets that
everyday gap with three core ideas:

- **TRACK** — Keep tabs on what's in your fridge before it expires.
- **SAVE** — Get recipes built around the ingredients you already have.
- **IMPACT** — Visualise your weekly savings in food, money and CO₂.

The interface is in **Spanish** and follows a warm, playful visual system (cream
background, teal accents) designed to make sustainable habits feel approachable
rather than guilt-inducing.

---

## Features

### Home
- Hero card with a snapshot of your impact: CO₂ avoided, items rescued, current streak.
- Weekly summary card and a rotating food-saving tip.
- Quick jump into the fridge from the home screen.

### TRACK — Fridge
- Fridge inventory grouped by food category.
- **Color-coded expiry badges** (red / amber / green) showing days until expiry.
- Functional search bar with clear button.
- Add-item bottom sheet with a **live emoji preview** that picks an icon from the
  product name as you type (e.g. *leche* → 🥛).

### SAVE — Recipes
- 10 recipes with photos, duration and difficulty.
- Functional filter chips: **Quick** (≤15 min), **Vegetarian**, **Under 30** (<30 min) — combinable.
- "With what you have" banner toggle to surface recipes matching your fridge.
- Recipe detail screen with ingredients and steps.

### IMPACT
- Stat cards: recipes cooked, food saved (kg), money saved (€), CO₂ avoided.
- **Weekly bar chart** of food saved (Mon→Sun) via `fl_chart`.
- Streak card and **achievement badges** (gamification).

### Sustainability & usability angles (course criteria)
- **Tracking, recommendations, impact visualisation, gamification** all present.
- **Visibility of system status** — color-coded expiry badges (Nielsen #1).
- **Consistency** — shared theme tokens, reusable card/badge widgets.
- **Meaningful labels & feedback** — clear Spanish labels, search clear buttons,
  live emoji preview.

---

## Tech Stack

- **Flutter** (Dart SDK `^3.11.5`)
- State management: `setState` + singleton service classes
- Packages:
  - `google_fonts` — Fredoka (headings) + Inter (body) typography
  - `fl_chart` — weekly impact bar chart
  - `intl` — number/date formatting
  - `uuid` — fridge item IDs

### Project structure
```
lib/
├── app.dart                 # MaterialApp + theme wiring
├── main.dart                # entry point
├── models/                  # FridgeItem, Recipe, ImpactStats, BadgeModel
├── data/mock_data.dart      # seed fridge items, recipes, impact stats
├── services/                # FridgeService, RecipeService, ImpactService (singletons)
├── screens/                 # home / track / save / impact + main_screen (tab shell)
├── widgets/                 # ExpiryBadge, StatCard, RecipeCard, WeeklyBarChart, ...
└── theme/                   # AppColors, AppTheme
```

Navigation is a 4-tab bottom bar: **Home / Track / Save / Impact**, each tab being
its own navigator root.

---

## Running the app

Requires the Flutter SDK installed (`flutter doctor` should pass) and an Android
device or emulator.

```bash
# from the project root: flutter/nadasobra/
flutter pub get
flutter run
```

### Building a release APK
```bash
flutter build apk --release
# output: build/app/outputs/flutter-apk/app-release.apk
```

For smaller per-architecture builds (arm64-v8a covers modern phones):
```bash
flutter build apk --release --split-per-abi
```

> Tested on Android (Xiaomi 12T Pro). iOS has not been verified.

---

## Known limitations

- **No persistence.** All data lives in memory via singleton services seeded from
  `mock_data.dart`. Items added to the fridge are lost when the app restarts —
  there is no local database or backend.
- **Impact stats are static.** The figures on the Impact screen (CO₂, kg saved,
  money, streak, badges) are mock values, not computed from cooking history.
  Cooking a recipe does not yet update them.
- **No backend or accounts.** Single hard-coded user; no authentication or sync.
- **Recipes are hardcoded.** 10 local recipes, no external recipe API.
- **Spanish only.** No localization framework; UI strings are not translated.
- **Recommendations are simple.** The "with what you have" matching is a basic
  ingredient overlap, not a ranked recommendation engine.

These trade-offs were intentional for a course prototype focused on **interface
design and usability** rather than production data infrastructure.
