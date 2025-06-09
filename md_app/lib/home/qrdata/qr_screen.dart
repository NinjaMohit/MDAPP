import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:md_app/component/app_text_widget.dart';
import 'package:md_app/component/show_qr.dart';
import 'package:md_app/database/db_helper.dart';
import 'package:md_app/home/customer/customer_model.dart';

import 'package:md_app/util/app_color.dart';
import 'package:md_app/util/app_textsize.dart';
import 'package:md_app/util/size_config.dart';
import 'package:md_app/util/validation_popup.dart';

class QrScreen extends StatelessWidget {
  final CustomerModel customer;
  QrScreen({super.key, required this.customer});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
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
            text: "QR Screen",
            fontSize: AppTextSize.textSizeMediumL,
            fontWeight: FontWeight.w500,
            color: AppColors.primary,
          ),
        ),
        leading: Padding(
          padding:
              EdgeInsets.only(top: SizeConfig.heightMultiplier * 2, left: 30),
          child: GestureDetector(
              onTap: () {
                Get.back();
              },
              child: Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
              )),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.only(bottom: 30, top: 30, left: 5, right: 5),
        child: Column(
          children: [
            SizedBox(
              height: SizeConfig.heightMultiplier * 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: () async {
                    try {
                      await DBHelper.generateAndSaveQrForCustomer(customer.id!);
                      await showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return CustomValidationPopup(
                              message: "QR Code Generated Successfully");
                        },
                      );
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Error: ${e.toString()}')),
                      );
                    }
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
                      text: "Generate QR Code for ${customer.customerName} ",
                      fontSize: AppTextSize.textSizeMedium,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                SizedBox(
                  width: SizeConfig.widthMultiplier * 2,
                ),
                GestureDetector(
                  onTap: () async {
                    await showQRDialog(context, customer);
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
                      text: "Download QR Code for ${customer.customerName} ",
                      fontSize: AppTextSize.textSizeMedium,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
