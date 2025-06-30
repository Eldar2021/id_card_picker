import 'dart:developer';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:id_card_picker/src/painting/overlay_painter.dart';
import 'package:id_card_picker/src/services/image_cropper_service.dart';

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
  List<CameraDescription>? _cameras;
  bool _isInitializing = true;
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    try {
      _cameras = await availableCameras();
      if (_cameras != null && _cameras!.isNotEmpty) {
        _cameraController = CameraController(
          _cameras![0],
          ResolutionPreset.high,
          enableAudio: false,
        );
        await _cameraController!.initialize();
        if (!mounted) return;
        setState(() {
          _isInitializing = false;
        });
      }
    } on Exception catch (e) {
      log('Error initializing camera: $e');
      if (mounted) Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  Future<void> _onCapturePressed() async {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return;
    }

    setState(() {
      _isProcessing = true;
    });

    try {
      final screenSize = MediaQuery.of(context).size;
      final imageFile = await _cameraController!.takePicture();

      final previewSize = _cameraController!.value.previewSize!;

      final croppedFile = await ImageCropperService.cropImage(
        imagePath: imageFile.path,
        screenSize: screenSize,
        cameraPreviewSize: previewSize,
      );

      if (mounted) {
        Navigator.pop(context, croppedFile);
      }
    } on Exception catch (e) {
      log('Error capturing or cropping image: $e');
      setState(() {
        _isProcessing = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isInitializing) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Positioned.fill(
            child: CameraPreview(_cameraController!),
          ),
          Positioned.fill(
            child: CustomPaint(
              painter: OverlayPainter(
                backgroundColor: widget.overlayBackgroundColor,
                borderColor: widget.overlayBorderColor,
              ),
            ),
          ),
          if (_isProcessing)
            const Center(
              child: CircularProgressIndicator(color: Colors.white),
            )
          else
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 50),
                child: IconButton(
                  icon: const Icon(
                    Icons.camera_alt,
                    color: Colors.white,
                    size: 72,
                  ),
                  onPressed: _onCapturePressed,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
