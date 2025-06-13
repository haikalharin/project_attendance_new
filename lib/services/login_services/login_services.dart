import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:project_attendance_new/repository/login_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/response_service_model.dart';

class LoginServices {
  LoginServices({required this.loginRepository});

  final LoginRepository loginRepository;

  Future<ResponseServiceModel> login(Map<dynamic, dynamic> body) async {
    ResponseServiceModel responseService =
    ResponseServiceModel(isSuccess: true, message: "", data: "");

    await loginRepository.login(body).then((res) {
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
