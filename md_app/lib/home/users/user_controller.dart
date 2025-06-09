import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:md_app/database/db_helper.dart';
import 'package:md_app/util/validation_popup.dart';

class UserController extends GetxController {
  final nameController = TextEditingController();
  FocusNode nameFocusNode = FocusNode();
  FocusNode passwordUserFocusNode = FocusNode();
  final passwordUserController = TextEditingController();
  var isPasswordVisible = false.obs;
  var isActive = true.obs;
  var isAdmin = false.obs;

  @override
  void onClose() {
    nameController.dispose();
    passwordUserController.dispose();
    nameFocusNode.dispose();
    passwordUserFocusNode.dispose();
    super.onClose();
  }

  Future<void> register(
      username, password, activeValue, adminValue, context) async {
    if (username.isEmpty || password.isEmpty) {
      Get.snackbar("Error", "Username and password are required");
      return;
    }

    if (password.length < 6) {
      Get.snackbar("Error", "Password must be at least 6 characters");
      return;
    }
    log("isActive.value------------${isActive.value}");
    log("isAdmin.value------------${isAdmin.value}");

    log("Registering with: isActive=${isActive.value}, isAdmin=${isAdmin.value}");

    try {
      await DBHelper.registerUserAdmin(
        username: username,
        password: password,
        activeValue: activeValue,
        adminValue: adminValue,
      );
      // Clear form after successful save

      // Show success message
      // Get.snackbar(
      //   'Success',
      //   'User created successfully',
      //   snackPosition: SnackPosition.BOTTOM,
      //   backgroundColor: Colors.green,
      //   colorText: Colors.white,
      // );

      await showDialog(
        context: context,
        builder: (BuildContext context) {
          return CustomValidationPopup(message: "User created successfully");
        },
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  void resetForm() {
    nameController.clear();
    passwordUserController.clear();
    isActive.value = true;
    isAdmin.value = false;
  }

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  void toggleIsAdmin(bool? value) {
    isAdmin.value = value ?? false;
    log("isAdmin toggled: ${isAdmin.value}");
  }

  void toggleIsActive(bool? value) {
    isActive.value = value ?? true;
    log("isActive toggled: ${isActive.value}");
  }

  //---------------------------------
}
