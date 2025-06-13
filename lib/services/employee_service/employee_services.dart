import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:project_attendance_new/adapter/employee_adapter.dart';
import 'package:project_attendance_new/repository/employee_repository.dart';
import 'package:project_attendance_new/repository/login_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/response_service_model.dart';

class EmployeeServices {
  EmployeeServices({required this.employeeRepository});

  final EmployeeRepository employeeRepository;

  Future<ResponseServiceModel> getListEmployee() async {
    ResponseServiceModel responseService =
    ResponseServiceModel(isSuccess: true, message: "", data: "");

    await employeeRepository.getListEmployee().then((res) {
      try {

        if(res.statusCode == 200){
          responseService.isSuccess = true;
          responseService.data = res.data;
          responseService.message = " login Success";
        } else{
          responseService.isSuccess = false;
          responseService.message = "login Failed";
          responseService.data = "";
        }

      } catch (error) {
        responseService.isSuccess = false;
        responseService.message = error.toString();
        responseService.data = "";

      }
    });

    return responseService;
  }

  Future<ResponseServiceModel> updateEmployee(Map<String, dynamic> body) async {
    ResponseServiceModel responseService =
    ResponseServiceModel(isSuccess: true, message: "", data: "");

    await employeeRepository.updateEmployee(body).then((res) {
      try {
        if (res.statusCode == 200 || res.statusCode == 201) {
          responseService.isSuccess = true;
          responseService.data = res.data;
          responseService.message = "Update success";
        } else {
          responseService.isSuccess = false;
          responseService.message = "Update failed";
          responseService.data = "";
        }
      } catch (error) {
        responseService.isSuccess = false;
        responseService.message = error.toString();
        responseService.data = "";
      }
    });

    return responseService;
  }
  Future<ResponseServiceModel> deleteEmployee(String id) async {
    ResponseServiceModel responseService =
    ResponseServiceModel(isSuccess: true, message: "", data: "");

    await employeeRepository.deleteEmployee(id).then((res) {
      try {
        if (res.statusCode == 200 || res.statusCode == 204) {
          responseService.isSuccess = true;
          responseService.data = res.data;
          responseService.message = "Delete success";
        } else {
          responseService.isSuccess = false;
          responseService.message = "Delete failed";
          responseService.data = "";
        }
      } catch (error) {
        responseService.isSuccess = false;
        responseService.message = error.toString();
        responseService.data = "";
      }
    });

    return responseService;
  }

}

// class LoginServices {
//   final LoginRepository loginRepository;
//
//   LoginServices({required this.loginRepository});
//
//
//
//   Future<ResponseServiceModel> login(Map<dynamic,dynamic> body) async {
//     ResponseServiceModel responseService =
//     ResponseServiceModel(isSuccess: true, message: "", data: "");
//
//     // Map packageInfo = await getPackageInfo();
//     //
//     // Map body = rescheduleDisplayModel.toServiceJson();
//
//     await loginRepository.login(body).then((res) {
//       try {
//         if (res.statusCode == 200) {
//           var resData = res.data;
//           responseService.data = res.data;
//           responseService.message = " login Success";
//
//         } else {
//           responseService.isSuccess = false;
//           responseService.message = "login Failed";
//           responseService.data = "";
//         }
//       } catch (e, str) {
//         responseService.isSuccess = false;
//         responseService.message = "Failed";
//         responseService.data = "";
//       }
//     });
//
//     return responseService;
//   }
//
//
//
//
// }
