import 'package:dio/dio.dart';
import 'package:project_attendance_new/adapter/employee_adapter.dart';
import 'package:project_attendance_new/adapter/login_adapter.dart';

import '../api_client/api_client.dart';
import '../exception/server_exception.dart';
import '../services/config.dart';
import '../utils/snackbar.dart';

class EmployeeRepository extends IEmployeeRepository {
  EmployeeRepository({required this.apiClient});

  final ApiClient apiClient;

  @override
  Future<Response> getListEmployee() async {
    try {
      final response = await apiClient.get(Config.getListEmployee);

      return response;
    } catch (error, stacktrace) {
      AppSnackBar.error(("Fail to connect with server, please try again"),
          title: "Error");

      throw ServerException(error.toString(), stacktrace);
    }
  }
  @override
  Future<Response> updateEmployee(Map<String, dynamic> body,) async {
    try {
      final response = await apiClient.update(Config.updateEmployee,body);

      return response;
    } catch (error, stacktrace) {
      AppSnackBar.error(("Fail to connect with server, please try again"),
          title: "Error");

      throw ServerException(error.toString(), stacktrace);
    }
  }

  @override
  Future<Response> deleteEmployee(String id) async {
    try {
      final response = await apiClient.delete(Config.deleteEmployee,id);

      return response;
    } catch (error, stacktrace) {
      AppSnackBar.error("Fail to connect with server, please try again", title: "Error");
      throw ServerException(error.toString(), stacktrace);
    }
  }
}

// class LoginRepository extends ILoginRepository {
//   LoginRepository({required this.apiClient});
//
//   final ApiClient apiClient;
//
//   @override
//   Future login(Map<dynamic, dynamic> body) async {
//     try {
//       final response = await apiClient.post(Config.login,body);
//
//       return response;
//     } catch (error, stacktrace) {
//       AppSnackBar.error("Fail to connect with server, please try again",
//           title: "Error");
//       throw ServerException(error.toString(), stacktrace);
//     }
//   }

// }
