import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:md_app/database/db_helper.dart';
import 'package:md_app/home/customer/customer_model.dart';
import 'package:md_app/util/validation_popup.dart';

class CustomerController extends GetxController {
  var isActive = true.obs;
  var societyNames = <String>[].obs;
  var showTextField = true.obs;
  var selectedSociety = ''.obs;
  var selectededitSociety = ''.obs;

  final societyNameController = TextEditingController();
  final buildingController = TextEditingController();
  final flatController = TextEditingController();
  final custNameController = TextEditingController();
  final custMobileController = TextEditingController();
  final abbravationController = TextEditingController();

  FocusNode societyNameFocusNode = FocusNode();
  FocusNode buildingFocusNode = FocusNode();
  FocusNode flatFocusNode = FocusNode();
  FocusNode custNameFocusNode = FocusNode();
  FocusNode custMobileFocusNode = FocusNode();
  FocusNode abbravationFocusNode = FocusNode();

  /// Dispose all controllers and focus nodes
  @override
  void onClose() {
    societyNameController.dispose();
    buildingController.dispose();
    flatController.dispose();
    custNameController.dispose();
    custMobileController.dispose();
    abbravationController.dispose();

    societyNameFocusNode.dispose();
    buildingFocusNode.dispose();
    flatFocusNode.dispose();
    custNameFocusNode.dispose();
    custMobileFocusNode.dispose();
    abbravationFocusNode.dispose();

    super.onClose();
  }

  @override
  void onInit() {
    super.onInit();
    fetchSocietyNames(); // Fetch society names when controller is initialized
  }

  /// Fetch unique society names from the database
  Future<void> fetchSocietyNames() async {
    try {
      final db = await DBHelper.database;
      final List<Map<String, dynamic>> result = await db.rawQuery(
        'SELECT DISTINCT societyName FROM customers WHERE societyName IS NOT NULL AND societyName != ""',
      );
      societyNames.value = result
          .map((row) => row['societyName'] as String)
          .toList()
          .toSet() // Ensure uniqueness
          .toList();
      // ignore: invalid_use_of_protected_member
      log('Fetched society names: ${societyNames.value}');
    } catch (e) {
      log('Error fetching society names: $e');
      Get.snackbar('Error', 'Failed to fetch society names: $e',
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  /// Reset the form fields and state
  void resetForm() {
    societyNameController.clear();
    buildingController.clear();
    flatController.clear();
    custNameController.clear();
    custMobileController.clear();
    abbravationController.clear();
    showTextField.value = true;
    selectedSociety.value = '';
    isActive.value = true;
  }

  void toggleIsActive(bool? value) {
    isActive.value = value ?? true;
    log("isActive toggled: ${isActive.value}");
  }

  ///------------------------------
  ///
  ///
  Future<void> saveCustomer(BuildContext context) async {
    final now = DateTime.now().toIso8601String();
    final customer = CustomerModel(
      societyName: selectedSociety.value,
      buildingName: buildingController.text,
      flatNo: flatController.text,
      customerName: custNameController.text,
      customerMobile: custMobileController.text,
      abbreviation: abbravationController.text,
      isActive: isActive.value ? 1 : 0,
      createdAt: now,
      updatedAt: now,
    );
    print('Saving Customer:');
    print('Society Name: ${customer.societyName}');
    print('Building Name: ${customer.buildingName}');
    print('Flat No: ${customer.flatNo}');
    print('Customer Name: ${customer.customerName}');
    print('Mobile: ${customer.customerMobile}');
    print('Abbreviation: ${customer.abbreviation}');
    print('isActive: ${customer.isActive}');
    print('qr code : ${customer.qrData}');

    print('CreatedAt: ${customer.createdAt}');
    print('UpdatedAt: ${customer.updatedAt}');

    try {
      await DBHelper.insertCustomer(customer);
      await showDialog(
        context: context,
        builder: (BuildContext context) {
          return CustomValidationPopup(
              message: "Customer Data Added successfully");
        },
      );
      await fetchSocietyNames(); // Refresh society names after adding a new customer

      resetForm();
    } catch (e) {
      Get.snackbar('Error', 'Failed to save customer: $e',
          snackPosition: SnackPosition.BOTTOM);
    }
  }
}
