import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stoneecho/shared/extensions/context_extensions.dart';
import 'package:stoneecho/shared/widgets/language_flag.dart';

class LanguageSelector extends ConsumerWidget {
  const LanguageSelector({super.key});

  static const _languages = [
    ('vi', 'Tiếng Việt'),
    ('en', 'English'),
    ('ko', '한국어'),
    ('zh', '中文'),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;

    return Card(
      child: Column(
        children: [
          // UI Language
          ListTile(
            leading: const Icon(Icons.translate),
            title: Text(l10n.uiLanguage),
            subtitle: Text(l10n.uiLanguageDescription),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: Row(
              children: _languages.map((lang) {
                final (code, name) = lang;
                final isSelected = code == 'vi'; // TODO: Read from provider
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: ChoiceChip(
                      selected: isSelected,
                      label: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          LanguageFlag(languageCode: code),
                          const SizedBox(height: 2),
                          Text(code.toUpperCase(), style: const TextStyle(fontSize: 10)),
                        ],
                      ),
                      onSelected: (_) {
                        // TODO: Update UI locale
                      },
                    ),
                  ),
                );
              }).toList(),
            ),
          ),

          const Divider(height: 1),

          // Content Language
          ListTile(
            leading: const Icon(Icons.headphones),
            title: Text(l10n.contentLanguage),
            subtitle: Text(l10n.contentLanguageDescription),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Row(
              children: _languages.map((lang) {
                final (code, name) = lang;
                final isSelected = code == 'vi'; // TODO: Read from provider
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: ChoiceChip(
                      selected: isSelected,
                      label: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          LanguageFlag(languageCode: code),
                          const SizedBox(height: 2),
                          Text(code.toUpperCase(), style: const TextStyle(fontSize: 10)),
                        ],
                      ),
                      onSelected: (_) {
                        // TODO: Update content language
                      },
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
