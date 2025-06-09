import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:md_app/component/app_elevated_button.dart';
import 'package:md_app/component/app_text_widget.dart';
import 'package:md_app/component/apptext_formfeild_login.dart';
import 'package:md_app/login/login_controller.dart';
import 'package:md_app/util/app_color.dart';
import 'package:md_app/util/app_textsize.dart';
import 'package:md_app/util/size_config.dart';

class LoginScreen extends StatelessWidget {
  final LoginController loginController = Get.put(LoginController());
  final formKey = GlobalKey<FormState>();

  LoginScreen({super.key});

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
              text: "Login",
              fontSize: AppTextSize.textSizeMediumL,
              fontWeight: FontWeight.w500,
              color: AppColors.primary,
            ),
          ),
        ),
        body: Padding(
          padding: EdgeInsets.all(20),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: SizeConfig.heightMultiplier * 10,
                ),
                Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                      color: AppColors.buttoncolor,
                      borderRadius: BorderRadius.circular(16)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppTextWidget(
                          text: "UserName",
                          fontSize: AppTextSize.textSizeSmall,
                          fontWeight: FontWeight.w500,
                          color: AppColors.primary),
                      SizedBox(
                        height: SizeConfig.heightMultiplier * 1,
                      ),
                      AppTextFormfeildLogin(
                        controller: loginController.usernameController,
                        hintText: "Enter Username",
                        keyboardType: TextInputType.name,
                        textInputAction: TextInputAction.next,
                        prefixIcon: Icon(
                          Icons.person,
                          color: AppColors.secondaryText,
                        ),
                        focusNode: loginController.usernameFocusNode,
                        onFieldSubmitted: (_) {
                          loginController.usernameFocusNode.unfocus();
                        },
                        validator: loginController.usernameValidator,
                      ),
                      SizedBox(
                        height: SizeConfig.heightMultiplier * 3,
                      ),
                      AppTextWidget(
                          text: "Password",
                          fontSize: AppTextSize.textSizeSmall,
                          fontWeight: FontWeight.w500,
                          color: AppColors.primary),
                      SizedBox(
                        height: SizeConfig.heightMultiplier * 1,
                      ),
                      Obx(
                        () => AppTextFormfeildLogin(
                          controller: loginController.passwordController,
                          hintText: "Enter Password",
                          obscureText: !loginController.isPasswordVisible.value,
                          prefixIcon: Icon(
                            Icons.password,
                            color: AppColors.secondaryText,
                          ),
                          focusNode: loginController.passwordFocusNode,
                          suffixIcon: IconButton(
                            icon: Icon(
                              loginController.isPasswordVisible.value
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: AppColors.secondaryText,
                            ),
                            onPressed: () {
                              loginController.isPasswordVisible.value =
                                  !loginController.isPasswordVisible.value;
                            },
                          ),
                          onFieldSubmitted: (_) {
                            loginController.passwordFocusNode.unfocus();
                          },
                          validator: loginController.passwordValidator,
                        ),
                      ),
                      SizedBox(height: SizeConfig.heightMultiplier * 8),
                      // TextButton(
                      //   onPressed: () {
                      //     loginController.register(
                      //         loginController.usernameController.text,
                      //         loginController.passwordController.text);
                      //   },
                      //   child: Text("Register"),
                      // ),
                    ],
                  ),
                ),
                SizedBox(
                  height: SizeConfig.heightMultiplier * 5,
                ),
                AppElevatedButton(
                  text: "Login",
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      loginController.login(context);
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
