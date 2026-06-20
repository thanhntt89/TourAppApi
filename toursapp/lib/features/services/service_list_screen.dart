import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:stoneecho/features/services/widgets/service_card.dart';
import 'package:stoneecho/features/services/widgets/service_filter_bar.dart';
import 'package:stoneecho/shared/extensions/context_extensions.dart';

class ServiceListScreen extends ConsumerStatefulWidget {
  const ServiceListScreen({super.key});

  @override
  ConsumerState<ServiceListScreen> createState() => _ServiceListScreenState();
}

class _ServiceListScreenState extends ConsumerState<ServiceListScreen> {
  String _selectedCategory = 'all';

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.localServices),
      ),
      body: Column(
        children: [
          ServiceFilterBar(
            selected: _selectedCategory,
            onChanged: (category) => setState(() => _selectedCategory = category),
          ),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: 8,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) => ServiceCard(
                index: index,
                onTap: () => context.push('/service/$index'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
