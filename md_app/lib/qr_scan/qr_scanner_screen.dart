// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:md_app/component/app_elevated_button.dart';
// import 'package:md_app/component/app_text_widget.dart';
// import 'package:md_app/home/customer/customer_model.dart';

// import 'package:md_app/qr_scan/qr_scanner_controller.dart';
// import 'package:md_app/util/app_color.dart';
// import 'package:md_app/util/app_textsize.dart';
// import 'package:md_app/util/size_config.dart';

// class ScanQrFromGalleryView extends StatelessWidget {
//   final QrScanController controller = Get.find();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.vertical(
//             bottom: Radius.circular(20),
//           ),
//         ),
//         scrolledUnderElevation: 0.0,
//         elevation: 0,
//         toolbarHeight: 75,
//         backgroundColor: AppColors.buttoncolor,
//         foregroundColor: AppColors.buttoncolor,
//         centerTitle: true,
//         title: Padding(
//           padding: EdgeInsets.only(top: SizeConfig.heightMultiplier * 2),
//           child: AppTextWidget(
//             text: "QR Scanner Screen",
//             fontSize: AppTextSize.textSizeMediumL,
//             fontWeight: FontWeight.w500,
//             color: AppColors.primary,
//           ),
//         ),
//         leading: Padding(
//           padding:
//               EdgeInsets.only(top: SizeConfig.heightMultiplier * 2, left: 30),
//           child: GestureDetector(
//               onTap: () {
//                 Get.back();
//               },
//               child: Icon(
//                 Icons.arrow_back_ios,
//                 color: Colors.white,
//               )),
//         ),
//       ),
//       body: Column(
//         children: [
//           SizedBox(height: SizeConfig.heightMultiplier * 10),
//           Padding(
//             padding: const EdgeInsets.all(20.0),
//             child: AppElevatedButton(
//               text: "Scan Image with QR from Gallery",
//               onPressed: () {
//                 controller.handleScanFromGallery();
//               },
//             ),
//           ),
//           SizedBox(height: SizeConfig.heightMultiplier * 5),
//           Obx(() {
//             if (controller.errorMessage.isNotEmpty) {
//               return Text(controller.errorMessage.value,
//                   style: const TextStyle(color: Colors.red));
//             } else if (controller.scannedCustomer.value != null) {
//               final CustomerModel c = controller.scannedCustomer.value!;
//               return Container(
//                 width: SizeConfig.widthMultiplier * 100,
//                 padding: const EdgeInsets.all(16),
//                 child: Card(
//                   color: AppColors.buttoncolor,
//                   child: Padding(
//                     padding: const EdgeInsets.all(20),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         AppTextWidget(
//                             text: "Customer Name: ${c.customerName ?? ''}",
//                             fontSize: AppTextSize.textSizeSmall,
//                             fontWeight: FontWeight.w500,
//                             color: AppColors.primaryText),
//                         SizedBox(height: SizeConfig.heightMultiplier * 1),
//                         AppTextWidget(
//                             text:
//                                 "Customer Mobile No: ${c.customerMobile ?? ''}",
//                             fontSize: AppTextSize.textSizeSmall,
//                             fontWeight: FontWeight.w500,
//                             color: AppColors.primaryText),
//                         SizedBox(height: SizeConfig.heightMultiplier * 1),
//                         AppTextWidget(
//                             text: "Society Name: ${c.societyName ?? ''}",
//                             fontSize: AppTextSize.textSizeSmall,
//                             fontWeight: FontWeight.w500,
//                             color: AppColors.primaryText),
//                         SizedBox(height: SizeConfig.heightMultiplier * 1),
//                         AppTextWidget(
//                             text: "Building Name: ${c.buildingName ?? ''}",
//                             fontSize: AppTextSize.textSizeSmall,
//                             fontWeight: FontWeight.w500,
//                             color: AppColors.primaryText),
//                         SizedBox(height: SizeConfig.heightMultiplier * 1),
//                         AppTextWidget(
//                             text: "Flat No: ${c.flatNo ?? ''}",
//                             fontSize: AppTextSize.textSizeSmall,
//                             fontWeight: FontWeight.w500,
//                             color: AppColors.primaryText),
//                       ],
//                     ),
//                   ),
//                 ),
//               );
//             }
//             return const SizedBox();
//           }),
//         ],
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:md_app/home/customer/customer_model.dart';
import 'package:md_app/qr_scan/qr_scanner_controller.dart';
import 'package:md_app/util/app_color.dart';
import 'package:md_app/util/app_textsize.dart';
import 'package:mobile_scanner/mobile_scanner.dart' as mobile_scanner;
import 'package:md_app/component/app_text_widget.dart';

class QrScannerScreen extends StatelessWidget {
  final QrScanController qrScanController = Get.find<QrScanController>();

  QrScannerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AppTextWidget(
          text: 'Scan QR Code',
          fontSize: AppTextSize.textSizeMediumL,
          fontWeight: FontWeight.w500,
          color: AppColors.primary,
        ),
        backgroundColor: AppColors.buttoncolor,
        foregroundColor: AppColors.primary,
      ),
      body: Stack(
        children: [
          mobile_scanner.MobileScanner(
            controller: mobile_scanner.MobileScannerController(
              formats: [mobile_scanner.BarcodeFormat.qrCode],
              facing: mobile_scanner.CameraFacing.back,
              torchEnabled: false,
            ),
            onDetect: (mobile_scanner.BarcodeCapture capture) {
              final String? qrCode = capture.barcodes.isNotEmpty
                  ? capture.barcodes.first.rawValue
                  : null;
              if (qrCode != null) {
                qrScanController.scannedCustomer.value =
                    qrCode as CustomerModel?;
                qrScanController.errorMessage.value = '';
                Get.back(); // Navigate back after successful scan
              } else {
                qrScanController.errorMessage.value = 'No QR code detected';
              }
            },
          ),
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.buttoncolor.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Obx(() => AppTextWidget(
                      text: qrScanController.errorMessage.value.isEmpty
                          ? 'Scan a QR code'
                          : qrScanController.errorMessage.value,
                      fontSize: AppTextSize.textSizeMedium,
                      fontWeight: FontWeight.w500,
                      color: AppColors.primaryText,
                    )),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
