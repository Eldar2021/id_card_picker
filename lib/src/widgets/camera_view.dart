import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:id_card_picker/src/widgets/camera_overlay.dart';
import 'package:id_card_picker/src/widgets/capture_controls.dart';

class CameraView extends StatelessWidget {
  const CameraView({
    required this.controller,
    required this.isProcessing,
    required this.onCapture,
    required this.overlayBorderColor,
    required this.overlayBackgroundColor,
    super.key,
  });

  final CameraController controller;
  final bool isProcessing;
  final VoidCallback onCapture;
  final Color overlayBorderColor;
  final Color overlayBackgroundColor;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        CameraPreview(controller),
        CameraOverlay(
          borderColor: overlayBorderColor,
          backgroundColor: overlayBackgroundColor,
        ),
        CaptureControls(
          isProcessing: isProcessing,
          onCapture: onCapture,
        ),
      ],
    );
  }
}
