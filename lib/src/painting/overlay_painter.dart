import 'package:flutter/material.dart';

class OverlayPainter extends CustomPainter {
  const OverlayPainter({
    required this.backgroundColor,
    required this.borderColor,
  });

  final Color backgroundColor;
  final Color borderColor;

  static const double ratio = 85.6 / 53.98;

  @override
  void paint(Canvas canvas, Size size) {
    final screenWidth = size.width;
    final screenHeight = size.height;

    final frameWidth = screenWidth * 0.9;
    final frameHeight = frameWidth / ratio;
    final frameLeft = (screenWidth - frameWidth) / 2;
    final frameTop = (screenHeight - frameHeight) / 2;

    final frameRect = Rect.fromLTWH(
      frameLeft,
      frameTop,
      frameWidth,
      frameHeight,
    );

    final frameRRect = RRect.fromRectAndRadius(
      frameRect,
      const Radius.circular(12),
    );

    final backgroundPaint = Paint()..color = backgroundColor;

    canvas.drawPath(
      Path.combine(
        PathOperation.difference,
        Path()..addRect(Rect.fromLTWH(0, 0, screenWidth, screenHeight)),
        Path()..addRRect(frameRRect),
      ),
      backgroundPaint,
    );

    final borderPaint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    canvas.drawRRect(frameRRect, borderPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
