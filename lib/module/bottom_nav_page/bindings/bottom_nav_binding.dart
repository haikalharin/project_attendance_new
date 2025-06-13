import 'package:dio/dio.dart';
import 'package:get/get.dart';


import '../../../api_client/api_client.dart';
import '../../../repository/employee_repository.dart';
import '../../../repository/login_repository.dart';
import '../../../services/employee_service/employee_services.dart';
import '../../../services/login_services/login_services.dart';
import '../../employee_page/controllers/employee_controller.dart';
import '../controllers/bottom_nav_controller.dart';

class BottomNavBarBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ApiClient(Dio()));
    Get.lazyPut<EmployeeRepository>(() => EmployeeRepository(apiClient: Get.find()));
    Get.lazyPut<EmployeeServices>(
            () => EmployeeServices(employeeRepository: Get.find()));

    Get.put<EmployeeController>(EmployeeController(employeeServices: Get.find()));

    Get.lazyPut<LoginRepository>(() => LoginRepository(apiClient: Get.find()));
    Get.lazyPut<LoginServices>(
        () => LoginServices(loginRepository: Get.find()));

    // Get.lazyPut<LoginController>(
    //         () => LoginController());
    Get.put<BottomNavBarController>(BottomNavBarController());
  }
}
