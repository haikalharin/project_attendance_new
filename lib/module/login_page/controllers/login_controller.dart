import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_attendance_new/module/login_page/models/login_model.dart';
import 'package:project_attendance_new/services/login_services/login_services.dart';
import '../../../data/app_preferences.dart';
import '../../../routes/app_routes.dart';
import '../../../services/models/response_service_model.dart';
import '../../../utils/dialog.dart';
import '../../employee_page/view/employee_list_page.dart';
import '../view/login_page.dart';

class LoginController extends GetxController {
  final LoginServices loginServices;

  LoginController({required this.loginServices});

  // Observables
  final username = ''.obs;
  final password = ''.obs;
  final isLoading = false.obs;

  // Controllers untuk form input
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void onInit() {
    super.onInit();

    // Bind observables ke TextEditingController
    usernameController.addListener(() {
      username.value = usernameController.text;
    });

    passwordController.addListener(() {
      password.value = passwordController.text;
    });
  }

  void handleLogin() async {
    final inputEmail = usernameController.text;
    final inputPassword = passwordController.text;

    isLoading.value = true;

    await Future.delayed(const Duration(milliseconds: 500)); // simulasi delay

    if (inputEmail == 'admin@example.com' && inputPassword == '123456') {
      await AppPreferences.setLoggedIn(true);
      Get.snackbar('Success', 'login_page Berhasil!',
          snackPosition: SnackPosition.BOTTOM);
      Get.offAllNamed(Routes.BOTTOM_NAV_BAR);
    } else {
      Get.snackbar('Error', 'Email atau password salah',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent,
          colorText: Colors.white);
    }

    isLoading.value = false;
  }

  void login() async {
    if (username.value.isNotEmpty && password.value.isNotEmpty) {
      isLoading.value = true;

      ResponseServiceModel response = await loginServices.login(
        <String, dynamic>{
          "username": username.value,
          "password": password.value,
        },
      );

      if (response.isSuccess) {
        var data = response.data;
        LoginModel loginModel =
            LoginModel.fromJson(data);

        if (loginModel.status == true) {
          await AppPreferences.setLoggedIn(true);

          await AppPreferences.setToken(loginModel.token??'');
          var token = await AppPreferences.getToken();
          print("###########${token}");
          Get.snackbar('Success', 'login_page Berhasil!',
              snackPosition: SnackPosition.BOTTOM);
          Get.offAllNamed(Routes.BOTTOM_NAV_BAR);
        } else {
          Get.snackbar('Error', 'Email atau password salah',
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.redAccent,
              colorText: Colors.white);
        }

        isLoading.value = false;
      } else {
        isLoading.value = false;
        AppDialog.DialogInfo(
          onBtnCenter: () {
            Get.back();
          },
          title: 'Info!',
          btnCenter: 'OK',
          desc: "Failed, Login",
        );
        return;
      }
    } else {
      isLoading.value = false;
      Get.snackbar('Error', 'Email atau password salah',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent,
          colorText: Colors.white);
    }
  }

  void logout() async {
    await AppPreferences.clear(); // hapus status login
    Get.offAll(() =>
        const LoginPage()); // kembali ke login dan hapus semua halaman sebelumnya
  }

  @override
  void onClose() {
    usernameController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
