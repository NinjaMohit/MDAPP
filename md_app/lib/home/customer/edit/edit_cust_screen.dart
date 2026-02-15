import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:md_app/component/app_elevated_button.dart';
import 'package:md_app/component/app_search_dropdown.dart';
import 'package:md_app/component/app_text_widget.dart';
import 'package:md_app/component/apptext_Formfeild_user.dart';
import 'package:md_app/home/customer/customer_controller.dart';
import 'package:md_app/home/customer/customer_model.dart';
import 'package:md_app/home/customer/customer_screen.dart';
import 'package:md_app/home/customer/edit/edit_cust_controller.dart';
import 'package:md_app/home/home_screen.dart';

import 'package:md_app/login/login_controller.dart';
import 'package:md_app/util/app_color.dart';
import 'package:md_app/util/app_textsize.dart';
import 'package:md_app/util/size_config.dart';

// ignore: must_be_immutable
class EditCustScreen extends StatelessWidget {
  final CustomerModel customer;
  EditCustScreen({super.key, required this.customer});
  final LoginController loginController = Get.find();
  final CustomerController customerController = Get.find();
  final formKey = GlobalKey<FormState>();
  int count = 0;
  @override
  Widget build(BuildContext context) {
    customerController.selectededitSociety.value = customer.societyName!;
    final EditCustController editCustController =
        Get.put(EditCustController(customer));
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
            text: "Edit Users",
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
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: SizeConfig.heightMultiplier * 6,
                ),
                Container(
                  //  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                      //      color: AppColors.buttoncolor,
                      borderRadius: BorderRadius.circular(16)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppTextWidget(
                          text: "Society Name",
                          fontSize: AppTextSize.textSizeSmall,
                          fontWeight: FontWeight.w500,
                          color: AppColors.primaryText),
                      SizedBox(
                        height: SizeConfig.heightMultiplier * 1,
                      ),
                      // ApptextFormfeildUser(
                      //     controller: editCustController.societyCustController,
                      //     hintText: "Society Name",
                      //     keyboardType: TextInputType.name,
                      //     textInputAction: TextInputAction.next,
                      //     focusNode: editCustController.societyNameFocusNode,
                      //     onFieldSubmitted: (_) {
                      //       editCustController.societyNameFocusNode.unfocus();
                      //     },
                      //     validator: (value) {
                      //       if (value == null || value.isEmpty) {
                      //         return 'Society Name is required';
                      //       }
                      //       return null;
                      //     }),
                      Obx(
                        () => AppSearchDropdown(
                          items: customerController.societyNames,
                          selectedItem: customerController
                                  .selectededitSociety.value.isEmpty
                              ? null
                              : customerController.selectededitSociety.value,
                          hintText: 'Select Society name',
                          onChanged: (value) {
                            customerController.selectededitSociety.value =
                                value ?? '';
                          },
                          validator: (value) {
                            if (value == null ||
                                value.toString().trim().isEmpty) {
                              return 'Please select a society name';
                            }
                            return null;
                          },
                        ),
                      ),
                      SizedBox(
                        height: SizeConfig.heightMultiplier * 2,
                      ),
                      AppTextWidget(
                          text: "Building Name",
                          fontSize: AppTextSize.textSizeSmall,
                          fontWeight: FontWeight.w500,
                          color: AppColors.primaryText),
                      SizedBox(
                        height: SizeConfig.heightMultiplier * 1,
                      ),
                      ApptextFormfeildUser(
                          controller: editCustController.buildingCustController,
                          hintText: "Enter Building Name",
                          focusNode: editCustController.buildingFocusNode,
                          onFieldSubmitted: (_) {
                            editCustController.buildingFocusNode.unfocus();
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Building Name is required';
                            }
                            return null;
                          }),
                      SizedBox(
                        height: SizeConfig.heightMultiplier * 2,
                      ),
                      AppTextWidget(
                          text: "Flat No",
                          fontSize: AppTextSize.textSizeSmall,
                          fontWeight: FontWeight.w500,
                          color: AppColors.primaryText),
                      SizedBox(
                        height: SizeConfig.heightMultiplier * 1,
                      ),
                      ApptextFormfeildUser(
                          controller: editCustController.flatCustController,
                          hintText: "Enter Flat No",
                          focusNode: editCustController.flatFocusNode,
                          onFieldSubmitted: (_) {
                            editCustController.flatFocusNode.unfocus();
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Flat No is required';
                            }
                            return null;
                          }),
                      SizedBox(
                        height: SizeConfig.heightMultiplier * 2,
                      ),
                      AppTextWidget(
                          text: "Customer Name",
                          fontSize: AppTextSize.textSizeSmall,
                          fontWeight: FontWeight.w500,
                          color: AppColors.primaryText),
                      SizedBox(
                        height: SizeConfig.heightMultiplier * 1,
                      ),
                      ApptextFormfeildUser(
                          controller: editCustController.custNameCustController,
                          hintText: "Enter Customer Name",
                          focusNode: editCustController.custNameFocusNode,
                          onFieldSubmitted: (_) {
                            editCustController.custMobileFocusNode.unfocus();
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Customer Name is required';
                            }
                            return null;
                          }),
                      SizedBox(
                        height: SizeConfig.heightMultiplier * 2,
                      ),
                      AppTextWidget(
                          text: "Customer Mobile No",
                          fontSize: AppTextSize.textSizeSmall,
                          fontWeight: FontWeight.w500,
                          color: AppColors.primaryText),
                      SizedBox(
                        height: SizeConfig.heightMultiplier * 1,
                      ),
                      ApptextFormfeildUser(
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(10),
                        ],

                        controller: editCustController.custMobileCustController,
                        hintText: "Enter Customer Mobile No",
                        keyboardType: TextInputType.number,
                        focusNode: editCustController.custMobileFocusNode,
                        onFieldSubmitted: (_) {
                          editCustController.custMobileFocusNode.unfocus();
                        },
                        // validator: (value) {
                        //   if (value == null || value.isEmpty) {
                        //     return 'Customer Mobile No is required';
                        //   } else if (!RegExp(r'^\d{10}$').hasMatch(value)) {
                        //     return 'Enter a valid 10-digit mobile number';
                        //   }
                        //   return null;
                        // },
                      ),
                      SizedBox(
                        height: SizeConfig.heightMultiplier * 2,
                      ),
                      //

                      SizedBox(height: SizeConfig.heightMultiplier * 3),

                      // Active User Checkbox
                      Row(
                        children: [
                          Transform.scale(
                            scale: 1.2,
                            child: Obx(() => Checkbox(
                                  value: editCustController.isActive.value,
                                  onChanged: editCustController.toggleIsActive,
                                  activeColor: AppColors.buttoncolor,
                                  materialTapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                  side: BorderSide(
                                    width: 1.5,
                                    color: AppColors.searchfeild,
                                  ),
                                )),
                          ),
                          SizedBox(width: SizeConfig.widthMultiplier * 3),
                          AppTextWidget(
                              text: "Active User",
                              fontSize: AppTextSize.textSizeSmall,
                              fontWeight: FontWeight.w500,
                              color: AppColors.primaryText),
                        ],
                      ),

                      SizedBox(height: SizeConfig.heightMultiplier * 8),
                      AppElevatedButton(
                        text: "Register User",
                        onPressed: () async {
                          int activeValue =
                              editCustController.isActive.value ? 1 : 0;

                          if (formKey.currentState!.validate()) {
                            await editCustController.updateCustomer(
                                context, activeValue);

                            Get.offUntil(
                              GetPageRoute(page: () => CustomerScreen()),
                              (route) {
                                if (route is GetPageRoute) {
                                  return route.page!().runtimeType ==
                                      HomeScreen;
                                }
                                return false;
                              },
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: SizeConfig.heightMultiplier * 5,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
