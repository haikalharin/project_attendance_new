


import 'package:get/get.dart';
import 'package:project_attendance_new/data/app_preferences.dart';
import 'package:project_attendance_new/module/login_page/bindings/login_binding.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../routes/app_routes.dart';

class SplashScreenController extends GetxController {
  var nama = ''.obs;

  @override
  void onInit() {
    checkLoginStatus();
    super.onInit();
  }


  Future<void> checkLoginStatus() async {
    bool isLoggedIn = await AppPreferences.isLoggedIn();

    await Future.delayed(const Duration(seconds: 2)); // efek splash

    if (isLoggedIn) {
      /*** jika controller menggunakan Get.lazyPut maka saat akan menuju controller tersebut harus di hapus dulu ***/
      // Get.delete<LoginBinding>();

      Get.offAllNamed(Routes.BOTTOM_NAV_BAR);

    } else {
      /*** jika controller menggunakan Get.lazyPut maka saat akan menuju controller tersebut harus di hapus dulu ***/
      // Get.delete<LoginBinding>();

      Get.offAllNamed(Routes.BOTTOM_NAV_BAR);
    }
  }
}