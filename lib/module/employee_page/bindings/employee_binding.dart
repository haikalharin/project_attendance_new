import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/bindings_interface.dart';


import '../../../api_client/api_client.dart';
import '../../../repository/employee_repository.dart';
import '../../../services/employee_service/employee_services.dart';
import '../controllers/employee_controller.dart';


class EmployeeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ApiClient(Dio()));
    Get.lazyPut<EmployeeRepository>(() => EmployeeRepository(apiClient: Get.find()));
    Get.lazyPut<EmployeeServices>(
            () => EmployeeServices(employeeRepository: Get.find()));

    Get.put<EmployeeController>(EmployeeController(employeeServices: Get.find()));
  }
}