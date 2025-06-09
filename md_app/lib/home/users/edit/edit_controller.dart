import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:md_app/database/db_helper.dart';
import 'package:md_app/model/usermodel.dart';
import 'package:md_app/util/validation_popup.dart';

class EditController extends GetxController {
  final nameEditController = TextEditingController();
  FocusNode nameEditFocusNode = FocusNode();
  FocusNode passwordEditFocusNode = FocusNode();
  final passwordEditController = TextEditingController();
  var isPasswordEditVisible = false.obs;
  var isEditActive = true.obs;
  var isEditAdmin = false.obs;
  final UserModel user;

  EditController(this.user);

  @override
  void onInit() {
    super.onInit();
    prefillUserData();
  }

  void prefillUserData() {
    nameEditController.text = user.username;
    passwordEditController.text = user.password;
    isEditActive.value = user.isActive == 1;
    isEditAdmin.value = user.isAdmin == 1;
  }

  @override
  void onClose() {
    nameEditController.dispose();
    passwordEditController.dispose();
    nameEditFocusNode.dispose();
    passwordEditFocusNode.dispose();
    super.onClose();
  }

  // Future<void> register(
  //     username, password, activeValue, adminValue, context) async {
  //   if (username.isEmpty || password.isEmpty) {
  //     Get.snackbar("Error", "Username and password are required");
  //     return;
  //   }

  //   if (password.length < 6) {
  //     Get.snackbar("Error", "Password must be at least 6 characters");
  //     return;
  //   }
  //   log("isActive.value------------${isActive.value}");
  //   log("isAdmin.value------------${isAdmin.value}");

  //   log("Registering with: isActive=${isActive.value}, isAdmin=${isAdmin.value}");

  //   try {
  //     await DBHelper.registerUserAdmin(
  //       username: username,
  //       password: password,
  //       activeValue: activeValue,
  //       adminValue: adminValue,
  //     );
  //     // Clear form after successful save

  //     // Show success message
  //     // Get.snackbar(
  //     //   'Success',
  //     //   'User created successfully',
  //     //   snackPosition: SnackPosition.BOTTOM,
  //     //   backgroundColor: Colors.green,
  //     //   colorText: Colors.white,
  //     // );

  //     await showDialog(
  //       context: context,
  //       builder: (BuildContext context) {
  //         return CustomValidationPopup(message: "User created successfully");
  //       },
  //     );
  //   } catch (e) {
  //     Get.snackbar(
  //       'Error',
  //       e.toString(),
  //       snackPosition: SnackPosition.BOTTOM,
  //       backgroundColor: Colors.red,
  //       colorText: Colors.white,
  //     );
  //   }
  // }

  Future<void> updateUser(
      username, password, isActive, isAdmin, BuildContext context) async {
    final updatedUser = UserModel(
      id: user.id,
      username: username.trim(),
      password: password.trim(),
      isActive: isActive,
      isAdmin: isAdmin,
      createdAt: user.createdAt,
      updatedAt: DateTime.now().toIso8601String(),
    );
// Print updated data before update
    print("Updating user with data:");
    print("ID: ${updatedUser.id}");
    print("Username: ${updatedUser.username}");
    print("Password: ${updatedUser.password}");
    print("isActive: ${updatedUser.isActive}");
    print("isAdmin: ${updatedUser.isAdmin}");
    print("CreatedAt: ${updatedUser.createdAt}");
    print("UpdatedAt: ${updatedUser.updatedAt}");
    try {
      final result = await DBHelper.updateUser(updatedUser);
      if (result > 0) {
        await showDialog(
          context: context,
          builder: (BuildContext context) {
            return CustomValidationPopup(message: "User Edited successfully");
          },
        );
        //     Get.back(); // Go back to previous screen
      } else {
        Get.snackbar("Error", "Failed to update user",
            snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e) {
      Get.snackbar("Error", e.toString(),
          snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red);
    }
  }

  void resetEditForm() {
    nameEditController.clear();
    passwordEditController.clear();
    isEditActive.value = true;
    isEditAdmin.value = false;
  }

  void toggleEditPasswordVisibility() {
    isPasswordEditVisible.value = !isPasswordEditVisible.value;
  }

  void toggleEditIsAdmin(bool? value) {
    isEditAdmin.value = value ?? false;
    log("isAdmin toggled: ${isEditAdmin.value}");
  }

  void toggleEditIsActive(bool? value) {
    isEditActive.value = value ?? true;
    log("isActive toggled: ${isEditActive.value}");
  }
}
