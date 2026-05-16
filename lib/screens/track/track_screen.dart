import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_colors.dart';
import '../../models/fridge_item.dart';
import '../../services/fridge_service.dart';
import '../../widgets/fridge_item_card.dart';
import 'add_item_sheet.dart';

class TrackScreen extends StatefulWidget {
  const TrackScreen({super.key});

  @override
  State<TrackScreen> createState() => _TrackScreenState();
}

class _TrackScreenState extends State<TrackScreen> {
  final _service = FridgeService();
  final _searchController = TextEditingController();
  FoodCategory? _selectedCategory; // null = All
  String _searchQuery = '';

  List<FridgeItem> get _filteredItems {
    final base = _selectedCategory == null
        ? _service.getAll()
        : _service.getByCategory(_selectedCategory!);
    if (_searchQuery.isEmpty) return base;
    final q = _searchQuery.toLowerCase();
    return base.where((i) => i.name.toLowerCase().contains(q)).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _delete(String id) {
    setState(() => _service.remove(id));
  }

  Future<void> _openAddSheet() async {
    HapticFeedback.lightImpact();
    final added = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const AddItemSheet(),
    );
    if (added == true) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTopBar(),
            _buildSearchBar(),
            _buildFilterChips(),
            Expanded(child: _buildList()),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openAddSheet,
        backgroundColor: AppColors.teal,
        shape: const CircleBorder(),
        child: const Icon(Icons.add, color: Colors.white, size: 28),
      ),
    );
  }

  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: const Icon(Icons.arrow_back_ios_new_rounded,
                size: 20, color: AppColors.dark),
          ),
          const SizedBox(width: 12),
          Text('Your fridge',
              style: GoogleFonts.fredoka(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: AppColors.dark)),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
      child: Container(
        height: 44,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
              color: AppColors.dark.withValues(alpha: 0.08), width: 1.5),
          boxShadow: AppColors.cardShadow,
        ),
        child: Row(
          children: [
            const Icon(Icons.search_rounded, color: AppColors.muted, size: 18),
            const SizedBox(width: 8),
            Expanded(
              child: TextField(
                controller: _searchController,
                onChanged: (v) => setState(() => _searchQuery = v),
                style: GoogleFonts.inter(fontSize: 13, color: AppColors.dark),
                decoration: InputDecoration(
                  hintText: 'Search your fridge...',
                  hintStyle: GoogleFonts.inter(
                      fontSize: 13, color: AppColors.muted),
                  filled: false,
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  isCollapsed: true,
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ),
            if (_searchQuery.isNotEmpty)
              GestureDetector(
                onTap: () {
                  _searchController.clear();
                  setState(() => _searchQuery = '');
                },
                child: const Icon(Icons.close_rounded,
                    color: AppColors.muted, size: 18),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChips() {
    // Order per Figma: All / Dairy / Vegetables / Proteins / Other
    const categories = [
      null,
      FoodCategory.dairy,
      FoodCategory.vegetables,
      FoodCategory.proteins,
      FoodCategory.other,
    ];
    const labels = ['All', 'Dairy', 'Vegetables', 'Proteins', 'Other'];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Row(
        children: List.generate(categories.length, (i) {
          final cat = categories[i];
          final active = _selectedCategory == cat;
          return GestureDetector(
            onTap: () => setState(() => _selectedCategory = cat),
            child: Container(
              margin: const EdgeInsets.only(right: 8),
              padding:
                  const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
              decoration: BoxDecoration(
                color: active ? AppColors.teal : AppColors.white,
                borderRadius: BorderRadius.circular(18),
                border: active
                    ? null
                    : Border.all(
                        color: AppColors.dark.withValues(alpha: 0.08),
                        width: 2),
              ),
              child: Text(labels[i],
                  style: GoogleFonts.fredoka(
                      fontSize: 13,
                      fontWeight: active ? FontWeight.w600 : FontWeight.w500,
                      color: active ? AppColors.white : AppColors.dark)),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildList() {
    final items = _filteredItems;
    if (items.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('🌿', style: TextStyle(fontSize: 48)),
            const SizedBox(height: 12),
            Text('Nothing here yet!',
                style: GoogleFonts.fredoka(
                    fontSize: 18, color: AppColors.muted)),
          ],
        ),
      );
    }
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 100),
      itemCount: items.length,
      separatorBuilder: (context, i) => const SizedBox(height: 10),
      itemBuilder: (_, i) => FridgeItemCard(
        item: items[i],
        onDelete: () => _delete(items[i].id),
      ),
    );
  }
}
