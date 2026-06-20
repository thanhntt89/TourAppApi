import 'package:flutter/material.dart';
import 'package:stoneecho/core/theme/app_colors.dart';

class CategoryChips extends StatefulWidget {
  const CategoryChips({super.key});

  @override
  State<CategoryChips> createState() => _CategoryChipsState();
}

class _CategoryChipsState extends State<CategoryChips> {
  int _selectedIndex = 0;

  static const _categories = [
    ('All', Icons.explore),
    ('Attractions', Icons.landscape),
    ('Food', Icons.restaurant),
    ('Culture', Icons.museum),
    ('Nature', Icons.park),
    ('Adventure', Icons.hiking),
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final (label, icon) = _categories[index];
          final isSelected = index == _selectedIndex;

          return FilterChip(
            selected: isSelected,
            label: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  icon,
                  size: 16,
                  color: isSelected ? Colors.white : AppColors.forestGreen,
                ),
                const SizedBox(width: 6),
                Text(label),
              ],
            ),
            selectedColor: AppColors.forestGreen,
            backgroundColor: Colors.white,
            labelStyle: TextStyle(
              color: isSelected ? Colors.white : AppColors.deepBrown,
              fontSize: 13,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            onSelected: (selected) {
              setState(() => _selectedIndex = index);
            },
          );
        },
      ),
    );
  }
}
