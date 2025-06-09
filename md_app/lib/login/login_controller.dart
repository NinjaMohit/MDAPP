import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:md_app/database/db_helper.dart';
import 'package:md_app/global_var.dart';
import 'package:md_app/home/home_screen.dart';
import 'package:md_app/login/login_screen.dart';
import 'package:md_app/util/validation_popup.dart';

class LoginController extends GetxController {
  final GetStorage storage = GetStorage();
  bool isLoggedIn = false;
  @override
  void onInit() {
    isLoggedIn = storage.read('isLoggedIn') ?? false;

    // TODO: implement onInit
    super.onInit();
  }

  final usernameController = TextEditingController();
  FocusNode usernameFocusNode = FocusNode();
  FocusNode passwordFocusNode = FocusNode();
  final passwordController = TextEditingController();
  var isPasswordVisible = false.obs;

  Future<void> login(context) async {
    final username = usernameController.text.trim();
    final password = passwordController.text.trim();

    if (username.isEmpty || password.isEmpty) {
      Get.snackbar("Error", "Username and password are required");
      return;
    }

    try {
      final user = await DBHelper.loginUser(username, password);
      if (user != null) {
        storage.write('isLoggedIn', true);
        storage.write('username', username);
        storage.write('isAdmin', user.isAdmin);
        storage.write('isActive', user.isActive);
        storage.write('userId', user.id);

        log("isAdmin ------------${user.isAdmin}");
        log("isActive------------${user.isActive}");

        isAdmin = await storage.read('isAdmin') == 1;
        userId.value = await storage.read('userId');
        if (user.isActive == 1) {
          Get.offAll(() => HomeScreen());
        } else {
          await showDialog(
            context: context,
            builder: (BuildContext context) {
              return CustomValidationPopup(message: "User is Not Active");
            },
          );
        }
      } else {
        Get.snackbar("Login Failed", "Invalid credentials");
      }
    } finally {}
  }

  /// Logout function
  void logout() {
    storage.erase();
    usernameController.clear();
    passwordController.clear();
    Get.offAll(() => LoginScreen());
  }

  // In LoginController
  String? usernameValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Username is required';
    }
    if (value.length < 4) {
      return 'Username must be at least 4 characters';
    }
    if (!RegExp(r'^[a-zA-Z0-9]+$').hasMatch(value)) {
      return 'Only letters and numbers are allowed';
    }
    return null;
  }

  // In LoginController
  String? passwordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 6) {
      return 'Username must be at least 6 characters';
    }
    if (!RegExp(r'^[a-zA-Z0-9]+$').hasMatch(value)) {
      return 'Only letters and numbers are allowed';
    }
    return null;
  }
}
