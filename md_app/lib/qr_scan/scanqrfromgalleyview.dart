import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_gallery_saver_plus/image_gallery_saver_plus.dart';
import 'package:md_app/component/app_text_widget.dart';
import 'package:md_app/global_var.dart';
import 'package:md_app/home/customer/customer_model.dart';
import 'package:md_app/qr_scan/qr_scanner_controller.dart';
import 'package:md_app/qr_scan/scanqrfromcameraview.dart';
import 'package:md_app/util/app_color.dart';
import 'package:md_app/util/app_textsize.dart';
import 'package:md_app/util/size_config.dart';
import 'dart:async';
import 'dart:io';

import 'package:flutter/rendering.dart';
import 'package:md_app/database/db_helper.dart';
import 'dart:ui' as ui;

import 'package:md_app/util/validation_popup.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_flutter/qr_flutter.dart';

class ScanQrFromGalleryView extends StatelessWidget {
  final QrScanController controller = Get.find();

  ScanQrFromGalleryView({super.key});

  Future<void> generateAllQRCodes(BuildContext context) async {
    try {showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
      final db = await DBHelper.database;
      final List<Map<String, dynamic>> customers = await db.query('customers');

      if (customers.isEmpty) {
        Navigator.of(context).pop(); // Close loader

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No customers found.')),
        );
        return;
      }

      for (var customerData in customers) {
        final customer = CustomerModel.fromJson(customerData);
        await DBHelper.generateAndSaveQrForCustomer(customer.id!);
      }
      
      Navigator.of(context).pop(); // Close loader

      await showDialog(
        context: context,
        builder: (BuildContext context) {
          return CustomValidationPopup(
            message: "All QR Codes Generated Successfully",
          );
        },
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error generating QR codes: $e')),
      );
    }
  }

//   // Function to download all QR codes
//   Future<void> downloadAllQRCodes(BuildContext context) async {
//     try {
//       showDialog(
//         context: context,
//         barrierDismissible: false,
//         builder: (BuildContext context) {
//           return const Center(
//             child: CircularProgressIndicator(),
//           );
//         },
//       );

//       final db = await DBHelper.database;
//       final List<Map<String, dynamic>> customers = await db.query('customers');

//       if (customers.isEmpty) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('No customers found.')),
//         );
//         return;
//       }

//       bool hasValidQr = false;

//       for (var customerData in customers) {
//         final customer = CustomerModel.fromJson(customerData);

//         if (customer.qrData == null || customer.qrData!.isEmpty) {
//           continue;
//         }

//         hasValidQr = true;

//         final qrKey = GlobalKey();
//         final qrWidget = RepaintBoundary(
//           key: qrKey,
//           child: Container(
//             color: Colors.white,
//             padding: const EdgeInsets.all(16),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Text(
//                   customer.customerName ?? '',
//                   style: const TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 const SizedBox(height: 10),
//                 QrImageView(
//                   data: customer.qrData!,
//                   version: QrVersions.auto,
//                   size: 200.0,
//                   backgroundColor: Colors.white,
//                 ),
//                 const SizedBox(height: 10),
//                 Text(
//                   customer.customerMobile ?? '',
//                   style: const TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.normal,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         );

//         final entry = OverlayEntry(
//           builder: (context) => Positioned(
//             top: 10000, // Offscreen render
//             child: Material(child: qrWidget),
//           ),
//         );

//         Overlay.of(context).insert(entry);
//         await Future.delayed(Duration(milliseconds: 300));

//         try {
//           final boundary =
//               qrKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
//           final image = await boundary.toImage(pixelRatio: 3.0);
//           final byteData =
//               await image.toByteData(format: ui.ImageByteFormat.png);
//           final pngBytes = byteData!.buffer.asUint8List();

//           final baseDir = await getApplicationDocumentsDirectory();
//           final qrFolder = Directory('${baseDir.path}/All_QR_Codes');

// // Create folder if it doesn't exist
//           if (!qrFolder.existsSync()) {
//             qrFolder.createSync(recursive: true);
//           }
//           final today = DateTime.now();
//           final formattedDate =
//               "${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}";
// // Build full file path
// // Sanitize customer name for filename
//           final safeName = (customer.customerName ?? 'unknown')
//               .replaceAll(RegExp(r'[\/\\:*?"<>|]'), '_');

//           // Build full file path
//           final filePath = '${qrFolder.path}/qr_${safeName}_$formattedDate.png';

//           // Save the image file
//           final file = File(filePath);
//           await file.writeAsBytes(pngBytes);

//           await ImageGallerySaverPlus.saveImage(
//             pngBytes,
//             name: "qr_${customer.customerName}_$formattedDate",
//             quality: 100,
//             isReturnImagePathOfIOS: true,
//           );
//         } catch (e) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(
//                 content:
//                     Text('Error saving QR for ${customer.customerName}: $e')),
//           );
//         } finally {
//           entry.remove();
//         }
//       }
//       Navigator.of(context).pop(); // Close loader

//       if (!hasValidQr) {
//         await showDialog(
//           context: context,
//           builder: (BuildContext context) {
//             return CustomValidationPopup(
//               message: "QR Code not generated. Please generate it first.",
//             );
//           },
//         );
//         return;
//       }

//       await showDialog(
//         context: context,
//         builder: (BuildContext context) {
//           return CustomValidationPopup(
//             message: "All QR Codes Downloaded Successfully",
//           );
//         },
//       );
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Error downloading QR codes: $e')),
//       );
//     }
//   }

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

Future<void> downloadAllQRCodes(BuildContext context) async {
  try {
    // Show loader
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    // Request permission first
    final hasPermission = await _requestGalleryPermission();
    if (!hasPermission) {
      Navigator.of(context).pop(); // Close loader
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

    final db = await DBHelper.database;
    final List<Map<String, dynamic>> customers = await db.query('customers');

    if (customers.isEmpty) {
      Navigator.of(context).pop(); // Close loader
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No customers found.')),
      );
      return;
    }

    bool hasValidQr = false;

    for (var customerData in customers) {
      final customer = CustomerModel.fromJson(customerData);

      if (customer.qrData == null || customer.qrData!.isEmpty) continue;
      hasValidQr = true;

      final qrKey = GlobalKey();
      final qrWidget = RepaintBoundary(
        key: qrKey,
        child: Container(
          color: Colors.white,
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                customer.customerName ?? '',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              QrImageView(
                data: customer.qrData!,
                version: QrVersions.auto,
                size: 200.0,
                backgroundColor: Colors.white,
              ),
              const SizedBox(height: 10),
              Text(
                customer.customerMobile ?? '',
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      );

      final overlay = Overlay.of(context);
      // ignore: unnecessary_null_comparison
      if (overlay == null) continue;

      final entry = OverlayEntry(
        builder: (context) => Positioned(
          top: 10000,
          left: 10000,
          child: Material(child: qrWidget),
        ),
      );

      overlay.insert(entry);
      await Future.delayed(const Duration(milliseconds: 300));

      try {
        final boundary =
            qrKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
        final image = await boundary.toImage(pixelRatio: 3.0);
        final byteData =
            await image.toByteData(format: ui.ImageByteFormat.png);
        final pngBytes = byteData!.buffer.asUint8List();

        final baseDir = await getApplicationDocumentsDirectory();
        final qrFolder = Directory('${baseDir.path}/All_QR_Codes');

        if (!qrFolder.existsSync()) {
          qrFolder.createSync(recursive: true);
        }

        final today = DateTime.now();
        final formattedDate =
            "${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}";

        // Sanitize file name
        final safeName = (customer.customerName ?? 'unknown')
            .replaceAll(RegExp(r'[\/\\:*?"<>|]'), '_');

        final filePath = '${qrFolder.path}/qr_${safeName}_$formattedDate.png';
        final file = File(filePath);
        await file.writeAsBytes(pngBytes);

        await ImageGallerySaverPlus.saveImage(
          pngBytes,
          name: "qr_${safeName}_$formattedDate",
          quality: 100,
          isReturnImagePathOfIOS: true,
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
                  Text('Error saving QR for ${customer.customerName}: $e')),
        );
      } finally {
        entry.remove();
      }
    }

    Navigator.of(context).pop(); // Close loader

    if (!hasValidQr) {
      await showDialog(
        context: context,
        builder: (_) =>
            CustomValidationPopup(message: "QR Code not generated."),
      );
      return;
    }

    await showDialog(
      context: context,
      builder: (_) => CustomValidationPopup(
        message: "All QR Codes Downloaded Successfully",
      ),
    );
  } catch (e) {
    Navigator.of(context).pop(); // Ensure loader closes on error
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error downloading QR codes: $e')),
    );
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20),
          ),
        ),
        scrolledUnderElevation: 0.0,
        elevation: 0,
        toolbarHeight: 75,
        backgroundColor: AppColors.buttoncolor,
        foregroundColor: AppColors.buttoncolor,
        centerTitle: true,
        title: Padding(
          padding: EdgeInsets.only(top: SizeConfig.heightMultiplier * 2),
          child: AppTextWidget(
            text: "QR Scanner Screen",
            fontSize: AppTextSize.textSizeMediumL,
            fontWeight: FontWeight.w500,
            color: AppColors.primary,
          ),
        ),
        leading: Padding(
          padding:
              EdgeInsets.only(top: SizeConfig.heightMultiplier * 2, left: 30),
          child: GestureDetector(
              onTap: () => Get.back(),
              child: Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
              )),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            userAdmin.value
                ? SizedBox(height: SizeConfig.heightMultiplier * 10)
                : const SizedBox(),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Obx(() {
                    return userAdmin.value
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: () async {
                                  await generateAllQRCodes(context);
                                },
                                child: Container(
                                  padding: EdgeInsets.all(4),
                                  alignment: Alignment.center,
                                  height: SizeConfig.imageSizeMultiplier * 36,
                                  width: SizeConfig.imageSizeMultiplier * 38,
                                  decoration: BoxDecoration(
                                    color: AppColors.buttoncolor,
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      color: const Color.fromARGB(
                                          255, 105, 105, 105),
                                      width: 1,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color.fromARGB(
                                                255, 61, 59, 59)
                                            .withOpacity(0.2),
                                        blurRadius: 6,
                                        offset: Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: AppTextWidget(
                                    text: "Generate All QR Codes",
                                    fontSize: AppTextSize.textSizeMedium,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.primary,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: SizeConfig.widthMultiplier * 7,
                              ),
                              GestureDetector(
                                onTap: () async {
                                  await downloadAllQRCodes(context);
                                },
                                child: Container(
                                  padding: EdgeInsets.all(4),
                                  alignment: Alignment.center,
                                  height: SizeConfig.imageSizeMultiplier * 36,
                                  width: SizeConfig.imageSizeMultiplier * 38,
                                  decoration: BoxDecoration(
                                    color: AppColors.buttoncolor,
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      color: const Color.fromARGB(
                                          255, 105, 105, 105),
                                      width: 1,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color.fromARGB(
                                                255, 61, 59, 59)
                                            .withOpacity(0.2),
                                        blurRadius: 6,
                                        offset: Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: AppTextWidget(
                                    text: "Download All QR Codes",
                                    fontSize: AppTextSize.textSizeMedium,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.primary,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ],
                          )
                        : SizedBox();
                  }),
                  // AppElevatedButton(
                  //   text: "Scan Image with QR from Gallery",
                  //   onPressed: () {
                  //     controller.handleScanFromGallery();
                  //   },
                  // ),
                  SizedBox(height: SizeConfig.heightMultiplier * 4),
                  GestureDetector(
                    onTap: () async {
                      Get.to(() => ScanQrFromCameraView());
                    },
                    child: Container(
                      padding: EdgeInsets.all(4),
                      alignment: Alignment.center,
                      height: SizeConfig.imageSizeMultiplier * 36,
                      width: SizeConfig.imageSizeMultiplier * 38,
                      decoration: BoxDecoration(
                        color: AppColors.buttoncolor,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: const Color.fromARGB(255, 105, 105, 105),
                          width: 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color.fromARGB(255, 61, 59, 59)
                                .withOpacity(0.2),
                            blurRadius: 6,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: AppTextWidget(
                        text: "Scan QR with Camera",
                        fontSize: AppTextSize.textSizeMedium,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: SizeConfig.heightMultiplier * 5),
            Obx(() {
              if (controller.errorMessage.isNotEmpty) {
                return Text(
                  controller.errorMessage.value,
                  style: const TextStyle(color: Colors.red),
                );
              } else if (controller.scannedCustomer.value != null) {
                final CustomerModel c = controller.scannedCustomer.value!;
                return Container(
                  width: SizeConfig.widthMultiplier * 100,
                  padding: const EdgeInsets.all(16),
                  child: Card(
                    color: AppColors.buttoncolor,
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppTextWidget(
                              text: "Customer Name: ${c.customerName ?? ''}",
                              fontSize: AppTextSize.textSizeSmall,
                              fontWeight: FontWeight.w500,
                              color: AppColors.primaryText),
                          SizedBox(height: SizeConfig.heightMultiplier * 1),
                          AppTextWidget(
                              text:
                                  "Customer Mobile No: ${c.customerMobile ?? ''}",
                              fontSize: AppTextSize.textSizeSmall,
                              fontWeight: FontWeight.w500,
                              color: AppColors.primaryText),
                          SizedBox(height: SizeConfig.heightMultiplier * 1),
                          AppTextWidget(
                              text: "Society Name: ${c.societyName ?? ''}",
                              fontSize: AppTextSize.textSizeSmall,
                              fontWeight: FontWeight.w500,
                              color: AppColors.primaryText),
                          SizedBox(height: SizeConfig.heightMultiplier * 1),
                          AppTextWidget(
                              text: "Building Name: ${c.buildingName ?? ''}",
                              fontSize: AppTextSize.textSizeSmall,
                              fontWeight: FontWeight.w500,
                              color: AppColors.primaryText),
                          SizedBox(height: SizeConfig.heightMultiplier * 1),
                          AppTextWidget(
                              text: "Flat No: ${c.flatNo ?? ''}",
                              fontSize: AppTextSize.textSizeSmall,
                              fontWeight: FontWeight.w500,
                              color: AppColors.primaryText),
                        ],
                      ),
                    ),
                  ),
                );
              }
              return const SizedBox();
            }),
          ],
        ),
      ),
    );
  }
}
