import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:md_app/global_var.dart';
import 'package:md_app/home/home_screen.dart';
import 'package:md_app/login/login_screen.dart';

class SplashController extends GetxController {
  static GetStorage storage = GetStorage();

  @override
  void onInit() {
    super.onInit();
    _navigateToNext();
  }

  void _navigateToNext() async {
    await Future.delayed(Duration(seconds: 2));
    bool isLoggedIn = storage.read('isLoggedIn') ?? false;

    if (isLoggedIn) {
      final loginname = await storage.read('username');
      if (loginname == "admin") {
        userAdmin.value = true;
      } else {
        userAdmin.value = false;
      }
      userName = await storage.read('username');
      isAdmin = await storage.read('isAdmin') == 1;
      userId.value = await storage.read('userId');

      Get.offAll(() => HomeScreen());
    } else {
      Get.offAll(() => LoginScreen());
    }
  }
}
