import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_colors.dart';
import '../../models/fridge_item.dart';
import '../../services/fridge_service.dart';

class AddItemSheet extends StatefulWidget {
  const AddItemSheet({super.key});

  @override
  State<AddItemSheet> createState() => _AddItemSheetState();
}

class _AddItemSheetState extends State<AddItemSheet> {
  final _nameController = TextEditingController();
  final _quantityController = TextEditingController();
  DateTime _expiryDate = DateTime.now().add(const Duration(days: 3));
  FoodCategory _category = FoodCategory.vegetables;
  final _service = FridgeService();

  static const _categoryEmojis = {
    FoodCategory.vegetables: '🥦',
    FoodCategory.dairy: '🧀',
    FoodCategory.proteins: '🍗',
    FoodCategory.other: '🥫',
  };

  static const _categoryLabels = {
    FoodCategory.vegetables: 'Vegetables',
    FoodCategory.dairy: 'Dairy',
    FoodCategory.proteins: 'Proteins',
    FoodCategory.other: 'Other',
  };

  // Keyword → emoji lookup. Checked longest-first so "eggplant" beats "egg".
  static const Map<String, String> _emojiMap = {
    // Dairy
    'milk': '🥛', 'leche': '🥛',
    'cheese': '🧀', 'queso': '🧀',
    'butter': '🧈', 'mantequilla': '🧈',
    'yogurt': '🥛', 'yoghurt': '🥛', 'yogur': '🥛',
    // Proteins
    'eggplant': '🍆', 'berenjena': '🍆',
    'egg': '🥚', 'huevo': '🥚',
    'chicken': '🍗', 'pollo': '🍗',
    'beef': '🥩', 'steak': '🥩', 'carne': '🥩',
    'fish': '🐟', 'pescado': '🐟',
    'salmon': '🐟', 'salmón': '🐟',
    'tuna': '🐟', 'atún': '🐟',
    'shrimp': '🦐', 'gamba': '🦐',
    'bacon': '🥓',
    'sausage': '🌭', 'salchicha': '🌭',
    'ham': '🍖', 'jamón': '🍖',
    // Vegetables
    'broccoli': '🥦', 'brócoli': '🥦',
    'tomato': '🍅', 'tomate': '🍅',
    'carrot': '🥕', 'zanahoria': '🥕',
    'onion': '🧅', 'cebolla': '🧅',
    'potato': '🥔', 'patata': '🥔', 'papa': '🥔',
    'garlic': '🧄', 'ajo': '🧄',
    'pepper': '🫑', 'pimiento': '🫑',
    'cucumber': '🥒', 'pepino': '🥒',
    'lettuce': '🥬', 'lechuga': '🥬',
    'spinach': '🥬', 'espinaca': '🥬',
    'mushroom': '🍄', 'champiñón': '🍄',
    'corn': '🌽', 'maíz': '🌽',
    'avocado': '🥑', 'aguacate': '🥑',
    // Fruits
    'lemon': '🍋', 'limón': '🍋',
    'apple': '🍎', 'manzana': '🍎',
    'banana': '🍌', 'plátano': '🍌',
    'orange': '🍊', 'naranja': '🍊',
    'strawberry': '🍓', 'fresa': '🍓',
    'grape': '🍇', 'uva': '🍇',
    'watermelon': '🍉', 'sandía': '🍉',
    'pineapple': '🍍', 'piña': '🍍',
    'peach': '🍑', 'melocotón': '🍑',
    // Pantry
    'bread': '🍞', 'pan': '🍞',
    'rice': '🍚', 'arroz': '🍚',
    'pasta': '🍝',
    'noodle': '🍜', 'fideo': '🍜',
    'olive': '🫒', 'aceituna': '🫒',
    'honey': '🍯', 'miel': '🍯',
    'coffee': '☕', 'café': '☕',
    'tea': '🍵', 'té': '🍵',
    'salt': '🧂', 'sal': '🧂',
    'water': '💧', 'agua': '💧',
  };

  // Resolves the best emoji for a typed name, falling back to the category default.
  // Longest keyword wins so "eggplant" matches before "egg".
  String _emojiForName(String name, FoodCategory fallback) {
    final lower = name.toLowerCase();
    final entries = _emojiMap.entries.toList()
      ..sort((a, b) => b.key.length.compareTo(a.key.length));
    for (final entry in entries) {
      if (lower.contains(entry.key)) return entry.value;
    }
    return _categoryEmojis[fallback]!;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _quantityController.dispose();
    super.dispose();
  }

  void _submit() {
    final name = _nameController.text.trim();
    if (name.isEmpty) return;
    _service.add(FridgeItem(
      name: name,
      emoji: _emojiForName(name, _category),
      category: _category,
      quantity: _quantityController.text.trim().isEmpty
          ? '1 unit'
          : _quantityController.text.trim(),
      expiryDate: _expiryDate,
    ));
    Navigator.of(context).pop(true);
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _expiryDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(
          colorScheme: const ColorScheme.light(primary: AppColors.teal),
        ),
        child: child!,
      ),
    );
    if (picked != null) setState(() => _expiryDate = picked);
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: EdgeInsets.fromLTRB(24, 16, 24, 24 + bottomInset),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.muted.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text('Add to fridge',
              style: GoogleFonts.fredoka(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: AppColors.dark)),
          const SizedBox(height: 20),
          _nameInputWithPreview(),
          const SizedBox(height: 12),
          _inputField(_quantityController, 'Quantity', 'e.g. 3 units, 500g'),
          const SizedBox(height: 12),
          _datePicker(),
          const SizedBox(height: 16),
          _categoryRow(),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _submit,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.teal,
                foregroundColor: AppColors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                elevation: 0,
              ),
              child: Text('Add to fridge',
                  style: GoogleFonts.fredoka(
                      fontSize: 16, fontWeight: FontWeight.w600)),
            ),
          ),
        ],
      ),
    );
  }

  Color _categoryTint(FoodCategory c) {
    switch (c) {
      case FoodCategory.vegetables: return AppColors.tintVegetable;
      case FoodCategory.dairy: return AppColors.tintDairy;
      case FoodCategory.proteins: return AppColors.tintProtein;
      case FoodCategory.other: return AppColors.tintOther;
    }
  }

  Widget _nameInputWithPreview() {
    final preview = _emojiForName(_nameController.text, _category);
    return Row(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: _categoryTint(_category),
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: Text(preview, style: const TextStyle(fontSize: 24)),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: TextField(
            controller: _nameController,
            onChanged: (_) => setState(() {}),
            style: GoogleFonts.inter(fontSize: 14, color: AppColors.dark),
            decoration: InputDecoration(
              labelText: 'Product name',
              hintText: 'e.g. Carrots',
              labelStyle:
                  GoogleFonts.inter(fontSize: 13, color: AppColors.muted),
            ),
          ),
        ),
      ],
    );
  }

  Widget _inputField(
      TextEditingController ctrl, String label, String hint) {
    return TextField(
      controller: ctrl,
      style: GoogleFonts.inter(fontSize: 14, color: AppColors.dark),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        labelStyle: GoogleFonts.inter(fontSize: 13, color: AppColors.muted),
      ),
    );
  }

  Widget _datePicker() {
    return GestureDetector(
      onTap: _pickDate,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
              color: AppColors.dark.withValues(alpha: 0.08), width: 1.5),
        ),
        child: Row(
          children: [
            const Text('📅', style: TextStyle(fontSize: 18)),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Expires on',
                    style: GoogleFonts.inter(
                        fontSize: 11, color: AppColors.muted)),
                Text(
                  '${_expiryDate.day}/${_expiryDate.month}/${_expiryDate.year}',
                  style: GoogleFonts.fredoka(
                      fontSize: 14, color: AppColors.dark),
                ),
              ],
            ),
            const Spacer(),
            const Icon(Icons.chevron_right_rounded, color: AppColors.muted),
          ],
        ),
      ),
    );
  }

  Widget _categoryRow() {
    // Order per Figma: Dairy / Vegetables / Proteins / Other
    const order = [
      FoodCategory.dairy,
      FoodCategory.vegetables,
      FoodCategory.proteins,
      FoodCategory.other,
    ];
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: order.map((cat) {
        final active = _category == cat;
        return GestureDetector(
          onTap: () => setState(() => _category = cat),
          child: Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
            decoration: BoxDecoration(
              color: active ? AppColors.teal : AppColors.white,
              borderRadius: BorderRadius.circular(18),
              border: active
                  ? null
                  : Border.all(
                      color: AppColors.dark.withValues(alpha: 0.08),
                      width: 2,
                    ),
            ),
            child: Text(
              _categoryLabels[cat]!,
              style: GoogleFonts.fredoka(
                  fontSize: 13,
                  fontWeight: active ? FontWeight.w600 : FontWeight.w500,
                  color: active ? AppColors.white : AppColors.dark),
            ),
          ),
        );
      }).toList(),
    );
  }
}
