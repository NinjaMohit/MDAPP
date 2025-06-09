import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:md_app/component/app_elevated_button.dart';
import 'package:md_app/component/app_search_dropdown.dart';
import 'package:md_app/component/app_text_widget.dart';
import 'package:md_app/component/apptext_Formfeild_user.dart';
import 'package:md_app/home/customer/customer_controller.dart';
import 'package:md_app/home/customer/customer_screen.dart';
import 'package:md_app/home/home_screen.dart';
import 'package:md_app/util/app_color.dart';
import 'package:md_app/util/app_textsize.dart';
import 'package:md_app/util/size_config.dart';

class AddCustomer extends StatelessWidget {
  AddCustomer({super.key});
  final CustomerController customerController = Get.put(CustomerController());
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
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
            text: "Customers",
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
                      Container(
                        alignment: Alignment.center,
                        height: 44,
                        width: SizeConfig.widthMultiplier * 100,
                        decoration: BoxDecoration(
                            color: AppColors.searchfeildcolor,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: AppColors.searchfeild)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () {
                                customerController.selectedSociety.value = "";
                                customerController.showTextField.value = true;
                                customerController.societyNameController
                                    .clear();
                              },
                              child: Container(
                                alignment: Alignment.center,
                                height: 50,
                                width: SizeConfig.widthMultiplier * 42,
                                child: AppTextWidget(
                                    text: "Enter Society name",
                                    fontSize: AppTextSize.textSizeSmall,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.primaryText),
                              ),
                            ),
                            Container(
                              height: 50,
                              width: 2,
                              color: AppColors.searchfeild,
                            ),
                            GestureDetector(
                              onTap: () {
                                customerController.selectedSociety.value = "";
                                customerController.societyNameController
                                    .clear();
                                customerController.showTextField.value = false;
                              },
                              child: Container(
                                alignment: Alignment.center,
                                height: 50,
                                width: SizeConfig.widthMultiplier * 42,
                                child: AppTextWidget(
                                    text: "Select Society",
                                    fontSize: AppTextSize.textSizeSmall,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.primaryText),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // ApptextFormfeildUser(
                      //     controller: customerController.societyNameController,
                      //     hintText: "Society Name",
                      //     keyboardType: TextInputType.name,
                      //     textInputAction: TextInputAction.next,
                      //     focusNode: customerController.societyNameFocusNode,
                      //     onFieldSubmitted: (_) {
                      //       customerController.societyNameFocusNode.unfocus();
                      //     },
                      //     validator: (value) {
                      //       if (value == null || value.isEmpty) {
                      //         return 'Society Name is required';
                      //       }
                      //       return null;
                      //     }),
                      SizedBox(
                        height: SizeConfig.heightMultiplier * 3,
                      ),
                      Obx(
                        () => customerController.showTextField.value
                            ? ApptextFormfeildUser(
                                controller:
                                    customerController.societyNameController,
                                hintText: "Society Name",
                                keyboardType: TextInputType.name,
                                textInputAction: TextInputAction.next,
                                focusNode:
                                    customerController.societyNameFocusNode,
                                onFieldSubmitted: (_) {
                                  customerController.societyNameFocusNode
                                      .unfocus();
                                },
                                onChanged: (value) {
                                  customerController.selectedSociety.value =
                                      value;
                                  customerController
                                      .societyNameController.text = value;
                                },
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Society Name is required';
                                  }
                                  return null;
                                })
                            : Obx(
                                () => AppSearchDropdown(
                                  items: customerController.societyNames,
                                  selectedItem: customerController
                                          .selectedSociety.value.isEmpty
                                      ? null
                                      : customerController
                                          .selectedSociety.value,
                                  hintText: 'Select Society name',
                                  onChanged: (value) {
                                    if (value != null) {
                                      customerController.selectedSociety.value =
                                          value;
                                    }
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
                        // : Obx(() => DropdownButtonFormField<String>(
                        //       decoration: InputDecoration(
                        //         hintText: 'Select Society',
                        //         border: OutlineInputBorder(
                        //           borderRadius: BorderRadius.circular(16),
                        //           borderSide: const BorderSide(
                        //             color: AppColors.searchfeild,
                        //           ),
                        //         ),
                        //         enabledBorder: OutlineInputBorder(
                        //           borderRadius: BorderRadius.circular(16),
                        //           borderSide: const BorderSide(
                        //             color: AppColors.searchfeild,
                        //           ),
                        //         ),
                        //         focusedBorder: OutlineInputBorder(
                        //           borderRadius: BorderRadius.circular(16),
                        //           borderSide: const BorderSide(
                        //             color: AppColors.primary,
                        //           ),
                        //         ),
                        //       ),
                        //       value: customerController
                        //               .selectedSociety.value.isEmpty
                        //           ? null
                        //           : customerController.selectedSociety.value,
                        //       items: customerController.societyNames
                        //           .map((String society) {
                        //         return DropdownMenuItem<String>(
                        //           value: society,
                        //           child: Text(society),
                        //         );
                        //       }).toList(),
                        //       onChanged: (String? newValue) {
                        //         if (newValue != null) {
                        //           customerController.selectedSociety.value =
                        //               newValue;
                        //           customerController
                        //               .societyNameController.text = newValue;
                        //         }
                        //       },
                        //       validator: (value) {
                        //         if (value == null || value.isEmpty) {
                        //           return 'Please select a society';
                        //         }
                        //         return null;
                        //       },
                        //     ))
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
                          controller: customerController.buildingController,
                          hintText: "Enter Building Name",
                          focusNode: customerController.buildingFocusNode,
                          onFieldSubmitted: (_) {
                            customerController.buildingFocusNode.unfocus();
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
                          controller: customerController.flatController,
                          hintText: "Enter Flat No",
                          focusNode: customerController.flatFocusNode,
                          keyboardType: TextInputType.number,
                          onFieldSubmitted: (_) {
                            customerController.flatFocusNode.unfocus();
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
                          controller: customerController.custNameController,
                          hintText: "Enter Customer Name",
                          focusNode: customerController.custNameFocusNode,
                          onFieldSubmitted: (_) {
                            customerController.custMobileFocusNode.unfocus();
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
                        controller: customerController.custMobileController,
                        hintText: "Enter Customer Mobile No",
                        keyboardType: TextInputType.number,
                        focusNode: customerController.custMobileFocusNode,
                        onFieldSubmitted: (_) {
                          customerController.custMobileFocusNode.unfocus();
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
                      // AppTextWidget(
                      //     text: "Customer Code",
                      //     fontSize: AppTextSize.textSizeSmall,
                      //     fontWeight: FontWeight.w500,
                      //     color: AppColors.primaryText),
                      // SizedBox(
                      //   height: SizeConfig.heightMultiplier * 1,
                      // ),
                      // ApptextFormfeildUser(
                      //   controller: customerController.abbravationController,
                      //   hintText: "Enter Customer Code",
                      //   focusNode: customerController.abbravationFocusNode,
                      //   onFieldSubmitted: (_) {
                      //     customerController.abbravationFocusNode.unfocus();
                      //   },
                      //   // validator: (value) {
                      //   //   if (value == null || value.isEmpty) {
                      //   //     return 'Abbrevation is required';
                      //   //   }
                      //   //   return null;
                      //   // }
                      // ),

                      SizedBox(height: SizeConfig.heightMultiplier * 3),

                      // Active User Checkbox
                      Row(
                        children: [
                          Transform.scale(
                            scale: 1.2,
                            child: Obx(() => Checkbox(
                                  value: customerController.isActive.value,
                                  onChanged: customerController.toggleIsActive,
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
                          // int activeValue =
                          //     await userController.isActive.value ? 1 : 0;
                          // int adminValue =
                          //     await userController.isAdmin.value ? 1 : 0;
                          if (formKey.currentState!.validate()) {
                            await customerController.saveCustomer(context);

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
