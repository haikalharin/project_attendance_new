// lib/controllers/nav_controller.dart
import 'package:get/get.dart';

import '../../../data/app_preferences.dart';
import '../../../routes/app_routes.dart';

class BottomNavBarController extends GetxController {
  var currentIndex = 0.obs;
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
  }
  void changeTab(int index) {
    currentIndex.value = index;
  }
  void logout() async {
    await AppPreferences.clear(); // hapus status login
    Get.offAllNamed(Routes.LOGIN); // kembali ke login dan hapus semua halaman sebelumnya
  }

  void goToAttendance() {
    // Navigasi ke halaman absensi
    Get.toNamed(Routes.MAPS_PAGE);
  }
}