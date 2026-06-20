import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:stoneecho/features/articles/widgets/article_card.dart';
import 'package:stoneecho/shared/extensions/context_extensions.dart';

class ArticleListScreen extends ConsumerWidget {
  const ArticleListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.articles),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: 10,
        separatorBuilder: (_, __) => const SizedBox(height: 16),
        itemBuilder: (context, index) => ArticleCard(
          index: index,
          onTap: () => context.push('/article/article-$index'),
        ),
      ),
    );
  }
}
