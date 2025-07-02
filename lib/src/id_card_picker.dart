import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:id_card_picker/src/camera/camera_page.dart';
import 'package:permission_handler/permission_handler.dart';

abstract class IdCardPicker {
  static Future<File?> pick({
    required BuildContext context,
    String label = 'Scan ID Card',
    String onPermissionDenied = 'Camera permission denied',
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
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(onPermissionDenied)),
        );
      }
      log('Camera permission denied.');
      return null;
    }
  }
}
