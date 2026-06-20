import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stoneecho/core/theme/app_colors.dart';
import 'package:stoneecho/features/journeys/widgets/route_map_widget.dart';
import 'package:stoneecho/features/journeys/widgets/stop_timeline.dart';

class JourneyDetailScreen extends ConsumerWidget {
  const JourneyDetailScreen({required this.journeyId, super.key});

  final int journeyId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO: Watch journeyDetailProvider(journeyId)

    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(
        title: Text('Journey #$journeyId'),
      ),
      body: const Column(
        children: [
          // Route map (top half)
          Expanded(
            flex: 2,
            child: RouteMapWidget(),
          ),

          // Stop timeline (bottom half)
          Expanded(
            flex: 3,
            child: StopTimeline(),
          ),
        ],
      ),
    );
  }
}
