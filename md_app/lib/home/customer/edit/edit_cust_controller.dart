import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:md_app/database/db_helper.dart';
import 'package:md_app/home/customer/customer_controller.dart';
import 'package:md_app/home/customer/customer_model.dart';
import 'package:md_app/util/validation_popup.dart';

class EditCustController extends GetxController {
  final CustomerModel customer;
  final CustomerController customerController = Get.find();
  EditCustController(this.customer);
  var isEditActive = true.obs;

  @override
  void onInit() {
    super.onInit();
    prefillUserData();
  }

  var isActive = true.obs;

  final societyCustController = TextEditingController();
  final buildingCustController = TextEditingController();
  final flatCustController = TextEditingController();
  final custNameCustController = TextEditingController();
  final custMobileCustController = TextEditingController();
  final abbravationCustController = TextEditingController();

  FocusNode societyNameFocusNode = FocusNode();
  FocusNode buildingFocusNode = FocusNode();
  FocusNode flatFocusNode = FocusNode();
  FocusNode custNameFocusNode = FocusNode();
  FocusNode custMobileFocusNode = FocusNode();
  FocusNode abbravationFocusNode = FocusNode();

  /// Dispose all controllers and focus nodes
  @override
  void onClose() {
    societyCustController.dispose();
    buildingCustController.dispose();
    flatCustController.dispose();
    custNameCustController.dispose();
    custMobileCustController.dispose();
    abbravationCustController.dispose();

    super.onClose();
  }

  /// Reset the form fields and state
  void resetForm() {
    societyCustController.clear();
    buildingCustController.clear();
    flatCustController.clear();
    custNameCustController.clear();
    custMobileCustController.clear();
    abbravationCustController.clear();

    isActive.value = true;
  }

  void toggleIsActive(bool? value) {
    isActive.value = value ?? true;
    log("isActive toggled: ${isActive.value}");
  }

  void prefillUserData() {
    societyCustController.text = customer.societyName!;
    buildingCustController.text = customer.buildingName!;
    flatCustController.text = customer.flatNo!;
    custNameCustController.text = customer.customerName!;
    custMobileCustController.text = customer.customerMobile!;
    abbravationCustController.text = customer.abbreviation!;

    isEditActive.value = customer.isActive == 1;
  }

  Future<void> updateCustomer(BuildContext context, activeValue) async {
    final updatedCustomer = CustomerModel(
      id: customer.id,
      societyName: customerController.selectededitSociety.value.trim(),
      buildingName: buildingCustController.text.trim(),
      flatNo: flatCustController.text.trim(),
      customerName: custNameCustController.text.trim(),
      customerMobile: custMobileCustController.text.trim(),
      abbreviation: abbravationCustController.text.trim(),
      isActive: activeValue,
      createdAt: customer.createdAt, // Preserve original
      updatedAt: DateTime.now().toIso8601String(), // New update timestamp
    );
    print("Updating Customer with the following data:");
    print("ID: ${updatedCustomer.id}");
    print(
        "Society Name: ${customerController.selectededitSociety.value.trim()}");
    print("Building Name: ${updatedCustomer.buildingName}");
    print("Flat No: ${updatedCustomer.flatNo}");
    print("Customer Name: ${updatedCustomer.customerName}");
    print("Mobile: ${updatedCustomer.customerMobile}");
    print("Abbreviation: ${updatedCustomer.abbreviation}");
    print("Is Active: $isActive");
    print("Created At: ${updatedCustomer.createdAt}");
    print("Updated At: ${updatedCustomer.updatedAt}");
    try {
      final result = await DBHelper.updateCustomer(updatedCustomer);
      if (result > 0) {
        await showDialog(
          context: context,
          builder: (BuildContext context) {
            return CustomValidationPopup(
                message: "Customer updated successfully");
          },
        );
        //     Get.back(); // Go back to previous screen
      } else {
        Get.snackbar("Error", "Failed to update customer",
            snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e) {
      Get.snackbar("Error", e.toString(),
          snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red);
    }
  }
}
