import 'package:flutter/material.dart';
import 'package:id_card_picker/src/painting/overlay_painter.dart';

class CameraOverlay extends StatelessWidget {
  const CameraOverlay({
    required this.borderColor,
    required this.backgroundColor,
    super.key,
  });

  final Color borderColor;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: OverlayPainter(
        borderColor: borderColor,
        backgroundColor: backgroundColor,
      ),
    );
  }
}
