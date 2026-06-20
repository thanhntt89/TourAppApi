import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

/// Generic shimmer loading placeholder.
/// Wraps [child] in a shimmer effect. The child defines the shape
/// of the loading skeleton (e.g. a Container with specific dimensions).
///
/// Example:
/// ```dart
/// LoadingShimmer(
///   child: Container(
///     width: double.infinity,
///     height: 200,
///     decoration: BoxDecoration(
///       color: Colors.white,
///       borderRadius: BorderRadius.circular(16),
///     ),
///   ),
/// )
/// ```
class LoadingShimmer extends StatelessWidget {
  const LoadingShimmer({
    required this.child,
    this.baseColor,
    this.highlightColor,
    super.key,
  });

  final Widget child;
  final Color? baseColor;
  final Color? highlightColor;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Shimmer.fromColors(
      baseColor: baseColor ?? (isDark ? Colors.grey.shade800 : Colors.grey.shade300),
      highlightColor: highlightColor ?? (isDark ? Colors.grey.shade700 : Colors.grey.shade100),
      child: child,
    );
  }
}

/// Pre-built shimmer shapes for common use cases.
class ShimmerShapes {
  const ShimmerShapes._();

  /// Rectangular shimmer placeholder.
  static Widget rect({
    double? width,
    double height = 16,
    double borderRadius = 8,
  }) {
    return LoadingShimmer(
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }

  /// Circular shimmer placeholder (e.g. avatar).
  static Widget circle({double size = 40}) {
    return LoadingShimmer(
      child: Container(
        width: size,
        height: size,
        decoration: const BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
        ),
      ),
    );
  }

  /// Card-shaped shimmer placeholder.
  static Widget card({double? width, double height = 180}) {
    return LoadingShimmer(
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }
}
