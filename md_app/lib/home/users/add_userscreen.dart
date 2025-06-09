import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:md_app/component/app_elevated_button.dart';
import 'package:md_app/component/app_text_widget.dart';
import 'package:md_app/component/apptext_Formfeild_user.dart';
import 'package:md_app/home/home_screen.dart';
import 'package:md_app/home/users/user_controller.dart';
import 'package:md_app/home/users/user_screen.dart';
import 'package:md_app/login/login_controller.dart';
import 'package:md_app/util/app_color.dart';
import 'package:md_app/util/app_textsize.dart';
import 'package:md_app/util/size_config.dart';

class AddUserscreen extends StatelessWidget {
  AddUserscreen({super.key});
  final UserController userController = Get.find();
  final LoginController loginController = Get.find();
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
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
            text: "Add Users",
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
      body: Padding(
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
                        text: "Username",
                        fontSize: AppTextSize.textSizeSmall,
                        fontWeight: FontWeight.w500,
                        color: AppColors.primaryText),
                    SizedBox(
                      height: SizeConfig.heightMultiplier * 1,
                    ),
                    ApptextFormfeildUser(
                      controller: userController.nameController,
                      hintText: "Enter Username",
                      keyboardType: TextInputType.name,
                      textInputAction: TextInputAction.next,
                      prefixIcon: Icon(
                        Icons.person,
                        color: AppColors.primaryText,
                      ),
                      focusNode: userController.nameFocusNode,
                      onFieldSubmitted: (_) {
                        userController.nameFocusNode.unfocus();
                      },
                      validator: loginController.usernameValidator,
                    ),
                    SizedBox(
                      height: SizeConfig.heightMultiplier * 2,
                    ),
                    AppTextWidget(
                        text: "Password",
                        fontSize: AppTextSize.textSizeSmall,
                        fontWeight: FontWeight.w500,
                        color: AppColors.primaryText),
                    SizedBox(
                      height: SizeConfig.heightMultiplier * 1,
                    ),
                    Obx(
                      () => ApptextFormfeildUser(
                        controller: userController.passwordUserController,
                        hintText: "Enter Password",
                        obscureText: !userController.isPasswordVisible.value,
                        prefixIcon: Icon(
                          Icons.password,
                          color: AppColors.primaryText,
                        ),
                        focusNode: userController.passwordUserFocusNode,
                        suffixIcon: IconButton(
                          icon: Icon(
                            userController.isPasswordVisible.value
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: AppColors.primaryText,
                          ),
                          onPressed: () {
                            userController.isPasswordVisible.value =
                                !userController.isPasswordVisible.value;
                          },
                        ),
                        onFieldSubmitted: (_) {
                          userController.passwordUserFocusNode.unfocus();
                        },
                        validator: loginController.passwordValidator,
                      ),
                    ),
                    SizedBox(height: SizeConfig.heightMultiplier * 3),

                    // Active User Checkbox
                    Row(
                      children: [
                        Transform.scale(
                          scale: 1.2,
                          child: Obx(() => Checkbox(
                                value: userController.isActive.value,
                                onChanged: userController.toggleIsActive,
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

                    Row(
                      children: [
                        Transform.scale(
                          scale: 1.2,
                          child: Obx(() => Checkbox(
                                value: userController.isAdmin.value,
                                onChanged: userController.toggleIsAdmin,
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
                            text: "Admin User",
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
                            await userController.isActive.value ? 1 : 0;
                        int adminValue =
                            await userController.isAdmin.value ? 1 : 0;
                        if (formKey.currentState!.validate()) {
                          await userController.register(
                              userController.nameController.text,
                              userController.passwordUserController.text,
                              activeValue,
                              adminValue,
                              context);

                          Get.offUntil(
                            GetPageRoute(page: () => UserScreen()),
                            (route) {
                              if (route is GetPageRoute) {
                                return route.page!().runtimeType == HomeScreen;
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
    );
  }
}
