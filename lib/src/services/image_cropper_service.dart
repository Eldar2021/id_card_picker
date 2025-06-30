import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:id_card_picker/src/painting/overlay_painter.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';

class ImageCropperService {
  static Future<File?> cropImage({
    required String imagePath,
    required Size screenSize,
    required Size cameraPreviewSize,
  }) async {
    try {
      final imageBytes = await File(imagePath).readAsBytes();
      final originalImage = img.decodeImage(imageBytes);

      if (originalImage == null) return null;

      final roi = _calculateCropRect(screenSize, originalImage);

      final croppedImage = img.copyCrop(
        originalImage,
        x: roi.left.toInt(),
        y: roi.top.toInt(),
        width: roi.width.toInt(),
        height: roi.height.toInt(),
      );

      final tempDir = await getTemporaryDirectory();
      final targetPath = '${tempDir.path}/cropped_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final croppedFile = File(targetPath);
      await croppedFile.writeAsBytes(img.encodeJpg(croppedImage, quality: 95));

      return croppedFile;
    } on Exception catch (e) {
      log('Error in cropImage service: $e');
      return null;
    }
  }

  static Rect _calculateCropRect(Size screenSize, img.Image image) {
    final imageWidth = image.width;
    final imageHeight = image.height;

    final frameWidthOnScreen = screenSize.width * 0.9;
    final frameHeightOnScreen = frameWidthOnScreen / OverlayPainter.ratio;
    final frameLeftOnScreen = (screenSize.width - frameWidthOnScreen) / 2;
    final frameTopOnScreen = (screenSize.height - frameHeightOnScreen) / 2;

    final scaleX = imageWidth / screenSize.width;
    final scaleY = imageHeight / screenSize.height;
    final scale = scaleX < scaleY ? scaleX : scaleY;

    final cropX = (frameLeftOnScreen * scale).toInt();
    final cropY = (frameTopOnScreen * scale).toInt();
    final cropWidth = (frameWidthOnScreen * scale).toInt();
    final cropHeight = (frameHeightOnScreen * scale).toInt();

    final safeCropX = cropX.clamp(0, imageWidth - cropWidth);
    final safeCropY = cropY.clamp(0, imageHeight - cropHeight);

    return Rect.fromLTWH(
      safeCropX.toDouble(),
      safeCropY.toDouble(),
      cropWidth.toDouble(),
      cropHeight.toDouble(),
    );
  }
}
