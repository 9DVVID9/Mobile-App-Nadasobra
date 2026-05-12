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
    FoodCategory.vegetables: 'Veggies',
    FoodCategory.dairy: 'Dairy',
    FoodCategory.proteins: 'Proteins',
    FoodCategory.other: 'Other',
  };

  @override
  void dispose() {
    _nameController.dispose();
    _quantityController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_nameController.text.trim().isEmpty) return;
    _service.add(FridgeItem(
      name: _nameController.text.trim(),
      emoji: _categoryEmojis[_category]!,
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
          _inputField(_nameController, 'Product name', '🥕 e.g. Carrots'),
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
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: FoodCategory.values.map((cat) {
        final active = _category == cat;
        return GestureDetector(
          onTap: () => setState(() => _category = cat),
          child: Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: active ? AppColors.teal : AppColors.cream,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: active
                    ? AppColors.teal
                    : AppColors.dark.withValues(alpha: 0.08),
                width: 1.5,
              ),
            ),
            child: Text(
              '${_categoryEmojis[cat]} ${_categoryLabels[cat]}',
              style: GoogleFonts.fredoka(
                  fontSize: 13,
                  color: active ? AppColors.white : AppColors.dark),
            ),
          ),
        );
      }).toList(),
    );
  }
}
