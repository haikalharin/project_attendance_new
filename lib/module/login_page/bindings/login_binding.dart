import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:project_attendance_new/repository/login_repository.dart';
import 'package:project_attendance_new/services/login_services/login_services.dart';

import '../../../api_client/api_client.dart';
import '../controllers/login_controller.dart';

class LoginBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ApiClient(Dio()));
    Get.lazyPut<LoginRepository>(() => LoginRepository(apiClient: Get.find()));
    Get.lazyPut<LoginServices>(
        () => LoginServices(loginRepository: Get.find()));

    // Get.lazyPut<LoginController>(
    //         () => LoginController());
    Get.put<LoginController>(LoginController(loginServices: Get.find()));
  }
}
