import 'package:flutter/material.dart';
import '../../data/models/category.dart';

class CategoryFilterBar extends StatelessWidget {
  final List<Category> categories;
  final String? selectedCategory;
  final ValueChanged<String?> onSelected;

  const CategoryFilterBar({
    super.key,
    required this.categories,
    required this.selectedCategory,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    if (categories.isEmpty) return const SizedBox.shrink();

    return SizedBox(
      height: 44,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: const Text('All'),
              selected: selectedCategory == null,
              onSelected: (_) => onSelected(null),
            ),
          ),
          for (final category in categories)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: ChoiceChip(
                label: Text(category.name),
                selected: selectedCategory == category.slug,
                onSelected: (_) => onSelected(category.slug),
              ),
            ),
        ],
      ),
    );
  }
}