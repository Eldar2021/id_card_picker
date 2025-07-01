import 'package:flutter/material.dart';
import 'package:id_card_picker/src/widgets/centered_progressing_indicator.dart';

class CaptureControls extends StatelessWidget {
  const CaptureControls({
    required this.isProcessing,
    required this.onCapture,
    this.tooltip = 'Scan ID Card',
    this.icon = const Icon(
      Icons.camera_alt,
      color: Colors.white,
      size: 72,
    ),
    super.key,
  });

  final bool isProcessing;
  final VoidCallback onCapture;
  final String tooltip;
  final Widget icon;

  @override
  Widget build(BuildContext context) {
    if (isProcessing) return const CenteredProgressingIndicator();
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 50),
        child: IconButton(
          icon: icon,
          onPressed: onCapture,
          tooltip: tooltip,
        ),
      ),
    );
  }
}
