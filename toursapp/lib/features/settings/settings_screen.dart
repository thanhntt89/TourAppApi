import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stoneecho/core/theme/app_colors.dart';
import 'package:stoneecho/core/theme/app_text_styles.dart';
import 'package:stoneecho/features/settings/widgets/language_selector.dart';
import 'package:stoneecho/features/settings/widgets/profile_card.dart';
import 'package:stoneecho/features/settings/widgets/storage_manager.dart';
import 'package:stoneecho/features/settings/widgets/theme_toggle.dart';
import 'package:stoneecho/shared/extensions/context_extensions.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.settings),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Profile card
          const ProfileCard(),
          const SizedBox(height: 20),

          // Language settings
          Text(l10n.language, style: AppTextStyles.titleMedium),
          const SizedBox(height: 8),
          const LanguageSelector(),
          const SizedBox(height: 20),

          // Theme
          Text(l10n.appearance, style: AppTextStyles.titleMedium),
          const SizedBox(height: 8),
          const ThemeToggle(),
          const SizedBox(height: 20),

          // Storage management
          Text(l10n.storage, style: AppTextStyles.titleMedium),
          const SizedBox(height: 8),
          const StorageManager(),
          const SizedBox(height: 20),

          // About section
          Text(l10n.about, style: AppTextStyles.titleMedium),
          const SizedBox(height: 8),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.info_outline),
                  title: Text(l10n.appVersion),
                  subtitle: const Text('1.0.0 (Phase 1)'),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.description_outlined),
                  title: Text(l10n.termsOfService),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    // TODO: Open terms
                  },
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.privacy_tip_outlined),
                  title: Text(l10n.privacyPolicy),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    // TODO: Open privacy policy
                  },
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.mail_outline),
                  title: Text(l10n.contactUs),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    // TODO: Open contact form
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Danger zone
          Center(
            child: TextButton(
              onPressed: () {
                showDialog<void>(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: Text(l10n.resetApp),
                    content: Text(l10n.resetAppConfirmation),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(ctx),
                        child: Text(l10n.cancel),
                      ),
                      TextButton(
                        onPressed: () {
                          // TODO: Clear all data
                          Navigator.pop(ctx);
                        },
                        style: TextButton.styleFrom(foregroundColor: AppColors.coral),
                        child: Text(l10n.reset),
                      ),
                    ],
                  ),
                );
              },
              style: TextButton.styleFrom(foregroundColor: AppColors.coral),
              child: Text(l10n.resetAllData),
            ),
          ),

          const SizedBox(height: 40),
        ],
      ),
    );
  }
}
