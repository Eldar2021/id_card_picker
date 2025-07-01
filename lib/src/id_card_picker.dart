import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:id_card_picker/src/camera/camera_page.dart';
import 'package:permission_handler/permission_handler.dart';

abstract class IdCardPicker {
  static Future<File?> pick({
    required BuildContext context,
    String label = 'Scan ID Card',
    Color overlayBackgroundColor = Colors.black54,
    Color overlayBorderColor = Colors.white,
  }) async {
    final status = await Permission.camera.request();
    if (status.isGranted && context.mounted) {
      final result = await Navigator.push<File>(
        context,
        MaterialPageRoute(
          builder: (context) => CameraPage(
            title: label,
            overlayBackgroundColor: overlayBackgroundColor,
            overlayBorderColor: overlayBorderColor,
          ),
        ),
      );
      return result;
    } else {
      log('Camera permission denied.');
      return null;
    }
  }
}
