import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stoneecho/features/library/widgets/articles_tab.dart';
import 'package:stoneecho/features/library/widgets/audio_guides_tab.dart';
import 'package:stoneecho/features/library/widgets/downloads_tab.dart';
import 'package:stoneecho/features/library/widgets/saved_tab.dart';
import 'package:stoneecho/features/library/widgets/stories_tab.dart';
import 'package:stoneecho/shared/extensions/context_extensions.dart';

class LibraryScreen extends ConsumerWidget {
  const LibraryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;

    return DefaultTabController(
      length: 5,
      child: Scaffold(
        appBar: AppBar(
          title: Text(l10n.library),
          bottom: TabBar(
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            tabs: [
              Tab(text: l10n.audioGuides),
              Tab(text: l10n.articles),
              Tab(text: l10n.stories),
              Tab(text: l10n.saved),
              Tab(text: l10n.downloads),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            AudioGuidesTab(),
            ArticlesTab(),
            StoriesTab(),
            SavedTab(),
            DownloadsTab(),
          ],
        ),
      ),
    );
  }
}
