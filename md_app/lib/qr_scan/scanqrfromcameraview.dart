import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:md_app/qr_scan/qr_scanner_controller.dart';
import 'package:md_app/util/app_color.dart';
import 'package:md_app/util/app_textsize.dart';
import 'package:md_app/component/app_text_widget.dart';

class ScanQrFromCameraView extends StatelessWidget {
  final QrScanController controller = Get.find();

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
          padding: EdgeInsets.only(top: 16),
          child: AppTextWidget(
            text: "QR Scanner (Camera)",
            fontSize: AppTextSize.textSizeMediumL,
            fontWeight: FontWeight.w500,
            color: AppColors.primary,
          ),
        ),
        leading: Padding(
          padding: EdgeInsets.only(top: 16, left: 30),
          child: GestureDetector(
            onTap: () => Get.back(),
            child: Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          MobileScanner(
            controller: MobileScannerController(
              formats: [BarcodeFormat.qrCode],
              facing: CameraFacing.back,
            ),
            onDetect: (BarcodeCapture capture) async {
              final String? qrData = capture.barcodes.first.rawValue;
              if (qrData != null) {
                await controller.handleScanFromCamera();
                Get.back(); // Close scanner after successful scan
              }
            },
          ),
          Center(
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 2),
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          Obx(() {
            if (controller.errorMessage.isNotEmpty) {
              return Positioned(
                bottom: 20,
                left: 20,
                right: 20,
                child: Text(
                  controller.errorMessage.value,
                  style: TextStyle(color: Colors.red, fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              );
            }
            return SizedBox();
          }),
        ],
      ),
    );
  }
}
