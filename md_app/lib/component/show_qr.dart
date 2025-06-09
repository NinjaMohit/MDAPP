import 'package:flutter/material.dart';
import 'package:md_app/component/app_text_widget.dart';
import 'package:md_app/component/download_qr.dart';
import 'package:md_app/database/db_helper.dart';
import 'package:md_app/home/customer/customer_model.dart';
import 'package:md_app/util/app_color.dart';
import 'package:md_app/util/app_textsize.dart';
import 'package:md_app/util/validation_popup.dart';
import 'package:qr_flutter/qr_flutter.dart';

Future<void> showQRDialog(BuildContext context, CustomerModel user) async {
  final qrKey = GlobalKey();
  final db = await DBHelper.database;
  // 🔄 Fetch latest data for this user
  final updatedUserData = await db.query(
    'customers',
    where: 'id = ?',
    whereArgs: [user.id],
  );
  if (updatedUserData.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Customer not found.")),
    );
    return;
  }
  final updatedUser = CustomerModel.fromJson(updatedUserData.first);

  final List<Map<String, dynamic>> result12 = await db.query('customers');
  if (updatedUser.qrData == null || updatedUser.qrData!.isEmpty) {
    // ScaffoldMessenger.of(context).showSnackBar(
    //   SnackBar(content: Text("Please generate QR code first.")),
    // );
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomValidationPopup(
            message: "Please Generate QR Code First then Download");
      },
    );
    return;
  }
  for (var row in result12) {
    print('--- Customer Record ---');
    print('ID: ${row['id']}');
    print('Society Name: ${row['societyName']}');
    print('Building Name: ${row['buildingName']}');
    print('Flat No: ${row['flatNo']}');
    print('Customer Name: ${row['customerName']}');
    print('Mobile: ${row['customerMobile']}');
    print('Abbreviation: ${row['abbreviation']}');
    print('isActive: ${row['isActive']}');
    print('QR Data: ${row['qrData']}');
    print('Created At: ${row['createdAt']}');
    print('Updated At: ${row['updatedAt']}');
    print('-----------------------');
  }
  showDialog(
    context: context,
    builder: (_) {
      return AlertDialog(
        alignment: Alignment.center,
        backgroundColor: Colors.white,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RepaintBoundary(
              key: qrKey,
              child: Container(
                color: Colors.white,
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Text(
                      updatedUser.customerName ?? '',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    QrImageView(
                      data: updatedUser.qrData!,
                      version: QrVersions.auto,
                      size: 200.0,
                      backgroundColor: Colors.white,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      updatedUser.customerMobile ?? '',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                      ),
                    )
                  ],
                ),
              ),
            ),
            SizedBox(height: 10),
            GestureDetector(
              onTap: () async {
                await saveQrToGallery(qrKey, context);
              },
              child: Container(
                height: 45,
                width: 210,
                decoration: BoxDecoration(
                  color: AppColors.buttoncolor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.download),
                    SizedBox(
                      width: 10,
                    ),
                    AppTextWidget(
                      text: "Download QR Code",
                      fontSize: AppTextSize.textSizeSmall,
                      fontWeight: FontWeight.w500,
                      color: AppColors.primaryText,
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      );
    },
  );
}
