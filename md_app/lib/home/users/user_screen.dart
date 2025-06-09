import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:md_app/component/app_elevated_button.dart';
import 'package:md_app/component/app_text_widget.dart';
import 'package:md_app/database/db_helper.dart';
import 'package:md_app/home/users/add_userscreen.dart';
import 'package:md_app/home/users/edit/edit_screen.dart';
import 'package:md_app/home/users/user_controller.dart';
import 'package:md_app/login/login_controller.dart';
import 'package:md_app/model/usermodel.dart';
import 'package:md_app/util/app_color.dart';
import 'package:md_app/util/app_textsize.dart';
import 'package:md_app/util/size_config.dart';

class UserScreen extends StatelessWidget {
  final UserController userController = Get.find();
  final LoginController loginController = Get.find();

  UserScreen({super.key});
  Future<List<UserModel>> _fetchUsers() async {
    return await DBHelper.getAllUsers();
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
              text: "Users Listing",
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
        body: FutureBuilder<List<UserModel>>(
          future: _fetchUsers(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('No users found.'));
            }

            final users = snapshot.data!;

            return Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: [
                  SizedBox(
                    height: SizeConfig.heightMultiplier * 5,
                  ),
                  AppElevatedButton(
                    text: "Add User",
                    onPressed: () {
                      // if (formKey.currentState!.validate()) {
                      //   // userController.register(
                      //   //     userController.nameController.text,
                      //   //     userController.passwordUserController.text,
                      //   //     context);
                      // }
                      userController.resetForm();
                      Get.to(AddUserscreen());
                    },
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
                          flex: 3,
                          child: AppTextWidget(
                              text: "Username",
                              fontSize: AppTextSize.textSizeSmall,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primary),
                        ),
                        Expanded(
                          flex: 2,
                          child: AppTextWidget(
                              text: "Admin",
                              fontSize: AppTextSize.textSizeSmall,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primary),
                        ),
                        Expanded(
                          flex: 2,
                          child: AppTextWidget(
                              text: "Active",
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
                            children: [
                              Expanded(
                                flex: 3,
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 20),
                                  child: Text(
                                    user.username,
                                    style: TextStyle(
                                        color: AppColors.primaryText,
                                        fontWeight: FontWeight.w500),
                                    maxLines: 2,
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Text(
                                  user.isAdmin == 1 ? "Yes" : "No",
                                  style:
                                      TextStyle(color: AppColors.primaryText),
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
                                    Get.to(EditScreen(
                                      user: user,
                                    ));
                                    print("Edit user: ${user.username}");
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
