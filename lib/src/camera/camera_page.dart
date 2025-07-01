import 'dart:async';
import 'dart:developer';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:id_card_picker/src/services/image_cropper_service.dart';
import 'package:id_card_picker/src/widgets/camera_view.dart';
import 'package:id_card_picker/src/widgets/centered_progressing_indicator.dart';
import 'package:id_card_picker/src/widgets/centered_text.dart';

class CameraPage extends StatefulWidget {
  const CameraPage({
    required this.title,
    required this.overlayBackgroundColor,
    required this.overlayBorderColor,
    super.key,
  });

  final String title;
  final Color overlayBackgroundColor;
  final Color overlayBorderColor;

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  CameraController? _cameraController;
  late Future<void> _initializeControllerFuture;
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    _initializeControllerFuture = _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) throw Exception('No cameras available.');

      _cameraController = CameraController(
        cameras[0],
        ResolutionPreset.high,
        enableAudio: false,
      );
      await _cameraController!.initialize();
    } on Exception catch (e) {
      log('Error initializing camera: $e');
      if (mounted) Navigator.pop(context);
    }
  }

  Future<void> _onCapturePressed() async {
    if (_isProcessing) return;

    final controller = _cameraController;
    if (controller == null || !controller.value.isInitialized) {
      log('Camera is not initialized.');
      return;
    }

    setState(() => _isProcessing = true);

    try {
      final screenSize = MediaQuery.of(context).size;
      final imageFile = await controller.takePicture();

      final croppedFile = await ImageCropperService.cropImage(
        imagePath: imageFile.path,
        screenSize: screenSize,
      );

      if (mounted) Navigator.pop(context, croppedFile);
    } on Exception catch (e) {
      log('Error capturing or cropping image: $e');
      if (mounted) {
        setState(() => _isProcessing = false);
      }
    }
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) return CenteredText(snapshot.error);
            return CameraView(
              controller: _cameraController!,
              isProcessing: _isProcessing,
              onCapture: _onCapturePressed,
              overlayBorderColor: widget.overlayBorderColor,
              overlayBackgroundColor: widget.overlayBackgroundColor,
            );
          } else {
            return const CenteredProgressingIndicator();
          }
        },
      ),
    );
  }
}
