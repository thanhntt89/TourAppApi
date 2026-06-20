import 'package:flutter/material.dart';
import 'package:stoneecho/core/theme/app_colors.dart';

class ScanFrame extends StatelessWidget {
  const ScanFrame({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final frameSize = size.width * 0.7;

    return CustomPaint(
      size: size,
      painter: _ScanFramePainter(
        frameSize: frameSize,
        frameColor: AppColors.forestGreen,
      ),
    );
  }
}

class _ScanFramePainter extends CustomPainter {
  _ScanFramePainter({
    required this.frameSize,
    required this.frameColor,
  });

  final double frameSize;
  final Color frameColor;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2 - 40);
    final rect = Rect.fromCenter(
      center: center,
      width: frameSize,
      height: frameSize,
    );

    // Dark overlay outside frame
    final overlayPaint = Paint()..color = Colors.black.withValues(alpha: 0.5);
    canvas.drawPath(
      Path.combine(
        PathOperation.difference,
        Path()..addRect(Rect.fromLTWH(0, 0, size.width, size.height)),
        Path()
          ..addRRect(
            RRect.fromRectAndRadius(rect, const Radius.circular(20)),
          ),
      ),
      overlayPaint,
    );

    // Corner brackets
    final cornerPaint = Paint()
      ..color = frameColor
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    const cornerLength = 30.0;
    const radius = 20.0;

    // Top-left, top-right, bottom-left, bottom-right corners
    canvas
      ..drawPath(
        Path()
          ..moveTo(rect.left, rect.top + cornerLength)
          ..lineTo(rect.left, rect.top + radius)
          ..arcToPoint(
            Offset(rect.left + radius, rect.top),
            radius: const Radius.circular(radius),
          )
          ..lineTo(rect.left + cornerLength, rect.top),
        cornerPaint,
      )
      ..drawPath(
        Path()
          ..moveTo(rect.right - cornerLength, rect.top)
          ..lineTo(rect.right - radius, rect.top)
          ..arcToPoint(
            Offset(rect.right, rect.top + radius),
            radius: const Radius.circular(radius),
          )
          ..lineTo(rect.right, rect.top + cornerLength),
        cornerPaint,
      )
      ..drawPath(
        Path()
          ..moveTo(rect.left, rect.bottom - cornerLength)
          ..lineTo(rect.left, rect.bottom - radius)
          ..arcToPoint(
            Offset(rect.left + radius, rect.bottom),
            radius: const Radius.circular(radius),
          )
          ..lineTo(rect.left + cornerLength, rect.bottom),
        cornerPaint,
      )
      ..drawPath(
        Path()
          ..moveTo(rect.right - cornerLength, rect.bottom)
          ..lineTo(rect.right - radius, rect.bottom)
          ..arcToPoint(
            Offset(rect.right, rect.bottom - radius),
            radius: const Radius.circular(radius),
          )
          ..lineTo(rect.right, rect.bottom - cornerLength),
        cornerPaint,
      );
  }

  @override
  bool shouldRepaint(covariant _ScanFramePainter oldDelegate) => false;
}
