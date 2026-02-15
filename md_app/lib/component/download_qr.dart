import 'dart:typed_data';
import 'dart:ui';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_gallery_saver_plus/image_gallery_saver_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:get/get.dart';
import 'package:md_app/util/validation_popup.dart';

Future<void> saveQrToGallery(GlobalKey qrKey, BuildContext context) async {
  try {
    // Convert widget to image
    RenderRepaintBoundary boundary =
        qrKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
    var image = await boundary.toImage(pixelRatio: 3.0);
    ByteData? byteData = await image.toByteData(format: ImageByteFormat.png);
    Uint8List pngBytes = byteData!.buffer.asUint8List();

    // Request permission
    bool hasPermission = await _requestGalleryPermission();
    if (!hasPermission) {
      Get.snackbar(
        'Permission Required',
        'Please grant media/storage permission to save QR.',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 5),
        mainButton: TextButton(
          onPressed: () => openAppSettings(),
          child: const Text('Open Settings'),
        ),
      );
      return;
    }
    final today = DateTime.now();
    final formattedDate =
        "${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}";
// Build full file path

    // Save to gallery
    final result = await ImageGallerySaverPlus.saveImage(
      pngBytes,
      quality: 100,
      name: "qr_$formattedDate",
    );

    if (result['isSuccess'] == true || result['isSuccess'] == 'true') {
      await showDialog(
        context: context,
        builder: (_) => CustomValidationPopup(
          message: "QR Code Downloaded Successfully",
        ),
      );
      Get.back(); // Close popup if needed
    } else {
      Get.snackbar(
          'Error', 'Failed to save QR: ${result['error'] ?? 'Unknown error'}');
    }
  } catch (e) {
    Get.snackbar('Error', 'Exception: $e');
  }
}

Future<bool> _requestGalleryPermission() async {
  if (Platform.isAndroid) {
    final androidInfo = await DeviceInfoPlugin().androidInfo;
    final sdkInt = androidInfo.version.sdkInt;

    if (sdkInt >= 33) {
      var status = await Permission.photos.request(); // Android 13+
      return status.isGranted;
    } else {
      var status = await Permission.storage.request(); // Android 12 and below
      return status.isGranted;
    }
  } else if (Platform.isIOS) {
    var status = await Permission.photosAddOnly.request();
    return status.isGranted;
  }
  return true;
}
