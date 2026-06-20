import 'package:flutter/material.dart';

class ServiceFilterBar extends StatelessWidget {
  const ServiceFilterBar({
    required this.selected,
    required this.onChanged,
    super.key,
  });

  final String selected;
  final ValueChanged<String> onChanged;

  static const _categories = [
    ('all', 'All', Icons.apps),
    ('homestay', 'Homestay', Icons.hotel),
    ('restaurant', 'Food', Icons.restaurant),
    ('transport', 'Transport', Icons.two_wheeler),
    ('guide', 'Guide', Icons.person),
    ('medical', 'Medical', Icons.medical_services),
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final (key, label, icon) = _categories[index];
          final isSelected = selected == key;
          return FilterChip(
            selected: isSelected,
            label: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, size: 16),
                const SizedBox(width: 4),
                Text(label),
              ],
            ),
            onSelected: (_) => onChanged(key),
          );
        },
      ),
    );
  }
}
