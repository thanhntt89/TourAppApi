import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stoneecho/shared/extensions/context_extensions.dart';
import 'package:stoneecho/shared/widgets/empty_state_widget.dart';

class SavedTab extends ConsumerWidget {
  const SavedTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    // TODO: Replace with real data from savedPlacesProvider.
    return EmptyStateWidget(
      icon: Icons.bookmark_border,
      title: l10n.noSavedPlaces,
      description: l10n.noSavedPlacesDescription,
    );
  }
}
