import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:md_app/component/app_text_widget.dart';
import 'package:md_app/global_var.dart';
import 'package:md_app/home/customer/customer_screen.dart';
import 'package:md_app/home/home_controller.dart';
import 'package:md_app/home/users/user_controller.dart';
import 'package:md_app/home/users/user_screen.dart';
import 'package:md_app/login/login_controller.dart';
import 'package:md_app/qr_scan/qr_scanner_controller.dart';
import 'package:md_app/qr_scan/scanqrfromgalleyview.dart';
import 'package:md_app/util/app_color.dart';
import 'package:md_app/util/app_textsize.dart';
import 'package:md_app/util/size_config.dart';

// ignore: must_be_immutable
class HomeScreen extends StatelessWidget {
  final LoginController loginController = Get.put(LoginController());
  final UserController userController = Get.put(UserController());
  final QrScanController qrScanController = Get.put(QrScanController());
  final ExportController exportController = Get.put(ExportController());

  HomeScreen({super.key});

  final List<String> listName = ["Users", "Customers", "Scan Users"];
  final List<String> listisNotAdmin = ["Scan Users"];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      bottom: true,
      child: Scaffold(
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
              text: "Home Screen",
              fontSize: AppTextSize.textSizeMediumL,
              fontWeight: FontWeight.w500,
              color: AppColors.primary,
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(
                top: 15,
              ),
              child: IconButton(
                icon: Icon(
                  Icons.person,
                  color: Colors.white,
                  size: 26,
                ),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return Dialog(
                        backgroundColor: Colors
                            .transparent, // transparent for full container control
                        child: Container(
                          padding: EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              AppTextWidget(
                                text: 'Login User',
                                fontSize: AppTextSize.textSizeMediumL,
                                fontWeight: FontWeight.w600,
                                color: AppColors.primaryText,
                              ),
                              SizedBox(height: SizeConfig.heightMultiplier * 2),
                              Container(
                                height: 1,
                                decoration:
                                    BoxDecoration(color: AppColors.buttoncolor),
                              ),
                              SizedBox(height: SizeConfig.heightMultiplier * 2),
                              AppTextWidget(
                                text: userName,
                                fontSize: AppTextSize.textSizeMedium,
                                fontWeight: FontWeight.w500,
                                color: AppColors.primaryText,
                              ),
                              SizedBox(height: 20),
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Container(
                                  alignment: Alignment.center,
                                  height: 40,
                                  width: 100,
                                  decoration: BoxDecoration(
                                      color: AppColors.buttoncolor,
                                      borderRadius: BorderRadius.circular(10)),
                                  child: AppTextWidget(
                                    text: "ok",
                                    fontSize: AppTextSize.textSizeMedium,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.primaryText,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 15, right: 10),
              child: IconButton(
                icon: Icon(
                  Icons.logout,
                  color: Colors.white,
                  size: 26,
                ),
                onPressed: () {
                  loginController.logout();
                },
              ),
            ),
          ],
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: SizeConfig.heightMultiplier * 3,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () async {
                    try {
                      await exportController.exportDataBySociety(context);
                    } catch (e) {
                      print('Failed to export history: $e');
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.all(3),
                    alignment: Alignment.center,
                    height: 50,
                    width: 160,
                    decoration: BoxDecoration(
                        color: AppColors.buttoncolor,
                        borderRadius: BorderRadius.circular(16)),
                    child: AppTextWidget(
                      text: "Export Society Data",
                      fontSize: AppTextSize.textSizeSmallm,
                      fontWeight: FontWeight.w500,
                      color: AppColors.primary,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                // GestureDetector(
                //   onTap: () async {
                //     try {
                //       await exportHistoryToExcel(
                //         context,
                //       );
                //     } catch (e) {
                //       print('Failed to export history: $e');
                //     }
                //   },
                //   child: Container(
                //     padding: EdgeInsets.all(3),
                //     alignment: Alignment.center,
                //     height: 70,
                //     width: 96,
                //     decoration: BoxDecoration(
                //         color: AppColors.buttoncolor,
                //         borderRadius: BorderRadius.circular(16)),
                //     child: AppTextWidget(
                //       text: "Export Histroy Data",
                //       fontSize: AppTextSize.textSizeSmallm,
                //       fontWeight: FontWeight.w500,
                //       color: AppColors.primary,
                //       textAlign: TextAlign.center,
                //     ),
                //   ),
                // ),
                GestureDetector(
                  onTap: () async {
                    try {
                      await exportController.deleteScanDataByDateRange(context);
                    } catch (e) {
                      print('Failed to export history: $e');
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.all(3),
                    alignment: Alignment.center,
                    height: 50,
                    width: 160,
                    decoration: BoxDecoration(
                        color: AppColors.buttoncolor,
                        borderRadius: BorderRadius.circular(16)),
                    child: AppTextWidget(
                      text: "Delete Histroy Data",
                      fontSize: AppTextSize.textSizeSmallm,
                      fontWeight: FontWeight.w500,
                      color: AppColors.primary,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: SizeConfig.heightMultiplier * 5,
            ),
            Expanded(
              child: GridView.builder(
                padding: EdgeInsets.all(16),
                itemCount: isAdmin ? listName.length : listisNotAdmin.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 24,
                  mainAxisSpacing: 30,
                  childAspectRatio: 1,
                ),
                itemBuilder: (context, index) {
                  return isAdmin
                      ? GestureDetector(
                          onTap: () {
                            if (index == 0) {
                              userController.resetForm();
                              Get.to(UserScreen());
                            }
                            if (index == 1) {
                              Get.to(CustomerScreen());
                            }
                            if (index == 2) {
                              qrScanController.scannedCustomer.value = null;
                              qrScanController.errorMessage.value = '';

                              Get.to(() => ScanQrFromGalleryView());
                            }
                          },
                          child: Container(
                            alignment: Alignment.center,
                            height: SizeConfig.imageSizeMultiplier * 30,
                            width: SizeConfig.imageSizeMultiplier * 32,
                            decoration: BoxDecoration(
                              color: AppColors.buttoncolor,
                              borderRadius: BorderRadius.circular(10),
                              // border: Border.all(
                              //   color: const Color.fromARGB(255, 105, 105, 105),
                              //   width: 1,
                              // ),
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
                              text: listName[index],
                              fontSize: AppTextSize.textSizeMediumm,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primary,
                            ),
                          ),
                        )
                      : GestureDetector(
                          onTap: () {
                            // if (index == 0) {
                            //   userController.resetForm();
                            //   Get.to(UserScreen());
                            // }
                          },
                          child: Container(
                            alignment: Alignment.center,
                            height: SizeConfig.imageSizeMultiplier * 30,
                            width: SizeConfig.imageSizeMultiplier * 32,
                            decoration: BoxDecoration(
                              color: AppColors.buttoncolor,
                              borderRadius: BorderRadius.circular(10),
                              // border: Border.all(
                              //   color: const Color.fromARGB(255, 105, 105, 105),
                              //   width: 1,
                              // ),
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
                              text: listisNotAdmin[index],
                              fontSize: AppTextSize.textSizeMediumm,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primary,
                            ),
                          ),
                        );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
