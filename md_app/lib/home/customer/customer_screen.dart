import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:md_app/component/app_elevated_button.dart';
import 'package:md_app/component/app_text_widget.dart';
import 'package:md_app/database/db_helper.dart';
import 'package:md_app/home/customer/add_customer.dart';
import 'package:md_app/home/customer/customer_controller.dart';
import 'package:md_app/home/customer/customer_model.dart';
import 'package:md_app/home/customer/edit/edit_cust_screen.dart';
import 'package:md_app/home/qrdata/qr_screen.dart';

import 'package:md_app/util/app_color.dart';
import 'package:md_app/util/app_textsize.dart';
import 'package:md_app/util/size_config.dart';

class CustomerScreen extends StatelessWidget {
  final CustomerController customerController = Get.put(CustomerController());

  CustomerScreen({super.key});
  Future<List<CustomerModel>> _fetchCustomer() async {
    return await DBHelper.getAllCustomers();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      bottom: true,
      child: Scaffold(
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
              text: "Customer Listing",
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
        body: FutureBuilder<List<CustomerModel>>(
          future: _fetchCustomer(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(children: [
                  SizedBox(
                    height: SizeConfig.heightMultiplier * 5,
                  ),
                  AppElevatedButton(
                    text: "Add Customer",
                    onPressed: () {
                      customerController.resetForm();
                      Get.to(AddCustomer());
                    },
                  ),
                  SizedBox(
                    height: SizeConfig.heightMultiplier * 5,
                  ),
                ]),
              );
            }

            final users = snapshot.data!;

            return Padding(
              padding: const EdgeInsets.only(left: 5, right: 5),
              child: Column(
                children: [
                  SizedBox(
                    height: SizeConfig.heightMultiplier * 5,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: AppElevatedButton(
                      text: "Add Customer",
                      onPressed: () {
                        customerController.resetForm();
                        Get.to(AddCustomer());
                      },
                    ),
                  ),
                  SizedBox(
                    height: SizeConfig.heightMultiplier * 5,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    color: AppColors.buttoncolor,
                    child: Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: AppTextWidget(
                              text: "Customer Name",
                              fontSize: AppTextSize.textSizeSmall,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primary),
                        ),
                        Expanded(
                          flex: 2,
                          child: AppTextWidget(
                              text: "Society Name",
                              fontSize: AppTextSize.textSizeSmall,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primary),
                        ),
                        Expanded(
                          flex: 2,
                          child: AppTextWidget(
                              text: "isActive",
                              fontSize: AppTextSize.textSizeSmall,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primary),
                        ),
                        Expanded(
                          flex: 1,
                          child: AppTextWidget(
                              text: "Edit",
                              fontSize: AppTextSize.textSizeSmall,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primary),
                        ),
                        Expanded(
                          flex: 1,
                          child: AppTextWidget(
                              text: "QR Code",
                              fontSize: AppTextSize.textSizeSmall,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primary),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: users.length,
                      itemBuilder: (context, index) {
                        final user = users[index];
                        return Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 16),
                          decoration: BoxDecoration(
                            color: index % 2 == 0
                                ? Colors.white
                                : const Color.fromARGB(255, 126, 173, 195)
                                    .withOpacity(0.1),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 2,
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 15),
                                  child: Text(
                                    user.customerName!,
                                    style: TextStyle(
                                        color: AppColors.primaryText,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 15),
                                  child: Text(
                                    user.societyName!,
                                    style:
                                        TextStyle(color: AppColors.primaryText),
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Text(
                                  user.isActive == 1 ? "Yes" : "No",
                                  style:
                                      TextStyle(color: AppColors.primaryText),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: IconButton(
                                  icon: Icon(Icons.edit,
                                      color: AppColors.buttoncolor),
                                  onPressed: () {
                                    Get.to(EditCustScreen(
                                      customer: user,
                                    ));
                                    print("Edit user: ${user.customerName}");
                                  },
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: IconButton(
                                  icon: Icon(Icons.qr_code_2,
                                      color: AppColors.buttoncolor),
                                  onPressed: () async {
                                    Get.to(QrScreen(
                                      customer: user,
                                    ));
                                  },
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
