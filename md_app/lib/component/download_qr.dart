import 'dart:io';
import 'dart:ui';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:get/get.dart';
import 'package:md_app/util/validation_popup.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

Future<void> saveQrToGallery(GlobalKey qrKey, context) async {
  try {
    final boundary =
        qrKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
    final image = await boundary.toImage(pixelRatio: 3.0);
    final byteData = await image.toByteData(format: ImageByteFormat.png);
    final pngBytes = byteData!.buffer.asUint8List();

    final androidVersion = Platform.isAndroid
        ? (await DeviceInfoPlugin().androidInfo).version.sdkInt
        : 0;

    PermissionStatus status;
    if (androidVersion >= 33) {
      status = await Permission.photos.request();
    } else {
      status = await Permission.storage.request();
    }

    if (status.isGranted) {
      final directory = await getTemporaryDirectory();
      final path =
          '${directory.path}/qr_${DateTime.now().millisecondsSinceEpoch}.png';
      final file = File(path);
      await file.writeAsBytes(pngBytes);

      await GallerySaver.saveImage(file.path);
      await showDialog(
        context: context,
        builder: (BuildContext context) {
          return CustomValidationPopup(
              message: "QR Code Downloaded Successfully");
        },
      );
      Get.back();
    } else {
      Get.snackbar(
          'Permission Denied', 'Storage or media permission not granted');
    }
  } catch (e) {
    Get.snackbar('Error', 'Failed to save QR Code: $e');
  }
}
