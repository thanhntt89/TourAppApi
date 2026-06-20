import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stoneecho/core/theme/app_colors.dart';
import 'package:stoneecho/core/theme/app_text_styles.dart';
import 'package:stoneecho/core/utils/formatters.dart';
import 'package:stoneecho/shared/widgets/language_flag.dart';

class AudioPlayerCard extends ConsumerWidget {
  const AudioPlayerCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO: Watch audioPlayerProvider for real state
    const position = Duration(minutes: 2, seconds: 35);
    const duration = Duration(minutes: 8, seconds: 12);

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Track title + language selector
          Row(
            children: [
              const Expanded(
                child: Text(
                  'History of Ha Giang',
                  style: AppTextStyles.titleMedium,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              // Language selector
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.creamDark,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    LanguageFlag(languageCode: 'en'),
                    SizedBox(width: 4),
                    Text('English', style: TextStyle(fontSize: 12)),
                    Icon(Icons.arrow_drop_down, size: 16),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Progress bar
          SliderTheme(
              data: SliderThemeData(
                trackHeight: 4,
                thumbShape:
                    const RoundSliderThumbShape(enabledThumbRadius: 6),
                activeTrackColor: AppColors.forestGreen,
                inactiveTrackColor: AppColors.creamDark,
                thumbColor: AppColors.forestGreen,
                overlayShape: SliderComponentShape.noOverlay,
              ),
              child: Slider(
                value: position.inSeconds.toDouble(),
                max: duration.inSeconds.toDouble(),
                onChanged: (value) {
                  // TODO: Seek audio
                },
              ),
            ),

            // Time labels
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    Formatters.audioDuration(position),
                    style: AppTextStyles.caption,
                  ),
                  Text(
                    Formatters.audioDuration(duration),
                    style: AppTextStyles.caption,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),

            // Controls
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Speed control
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.creamDark,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    '1x',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                // Skip back
                IconButton(
                  icon: const Icon(Icons.replay_10),
                  color: AppColors.deepBrown,
                  onPressed: () {},
                ),
                const SizedBox(width: 8),
                // Play/Pause
                Container(
                  width: 56,
                  height: 56,
                  decoration: const BoxDecoration(
                    color: AppColors.forestGreen,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const Icon(
                      Icons.play_arrow,
                      color: Colors.white,
                      size: 28,
                    ),
                    onPressed: () {
                      // TODO: Toggle play/pause via audioPlayerProvider
                    },
                  ),
                ),
                const SizedBox(width: 8),
                // Skip forward
                IconButton(
                  icon: const Icon(Icons.forward_10),
                  color: AppColors.deepBrown,
                  onPressed: () {},
                ),
                const SizedBox(width: 16),
                // Download
                IconButton(
                  icon: const Icon(Icons.download),
                  color: AppColors.textLight,
                  onPressed: () {},
                ),
              ],
            ),
        ],
      ),
    );
  }
}
