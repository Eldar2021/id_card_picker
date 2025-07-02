import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:id_card_picker/src/painting/overlay_painter.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';

const double _horizontalPaddingRatio = 0.125;
const double _verticalPaddingRatio = 0.05;

abstract class ImageCropperService {
  static Future<File?> cropImage({
    required String imagePath,
    required Size screenSize,
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
    final imageWidth = image.width.toDouble();
    final imageHeight = image.height.toDouble();

    final screenAspectRatio = screenSize.width / screenSize.height;
    final imageAspectRatio = imageWidth / imageHeight;

    double scale;
    double blankWidth = 0;
    double blankHeight = 0;

    if (imageAspectRatio > screenAspectRatio) {
      scale = imageHeight / screenSize.height;
      blankWidth = imageWidth - screenSize.width * scale;
    } else {
      scale = imageWidth / screenSize.width;
      blankHeight = imageHeight - screenSize.height * scale;
    }

    final frameWidthOnScreen = screenSize.width * 0.9;
    final frameHeightOnScreen = frameWidthOnScreen / OverlayPainter.ratio;
    final frameLeftOnScreen = (screenSize.width - frameWidthOnScreen) / 2;
    final frameTopOnScreen = (screenSize.height - frameHeightOnScreen) / 2;

    final cropX = (frameLeftOnScreen * scale) + (blankWidth / 2);
    final cropY = (frameTopOnScreen * scale) + (blankHeight / 2);
    final cropWidth = frameWidthOnScreen * scale;
    final cropHeight = frameHeightOnScreen * scale;

    final horizontalPadding = cropWidth * _horizontalPaddingRatio;
    final verticalPadding = cropHeight * _verticalPaddingRatio;

    final finalX = cropX - horizontalPadding;
    final finalY = cropY - verticalPadding;
    final finalWidth = cropWidth + (horizontalPadding * 2);
    final finalHeight = cropHeight + (verticalPadding * 2);

    final safeRect = Rect.fromLTWH(
      finalX < 0 ? 0 : finalX,
      finalY < 0 ? 0 : finalY,
      (finalX + finalWidth) > imageWidth ? imageWidth - finalX : finalWidth,
      (finalY + finalHeight) > imageHeight ? imageHeight - finalY : finalHeight,
    );

    return safeRect;
  }
}
