import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:project_attendance_new/adapter/employee_adapter.dart';
import 'package:project_attendance_new/repository/employee_repository.dart';
import 'package:project_attendance_new/repository/login_repository.dart';
import 'package:project_attendance_new/repository/maps_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/response_service_model.dart';

class MapsServices {
  MapsServices({required this.mapsRepository});

  final MapsRepository mapsRepository;


  Future<ResponseServiceModel> getAddress({double? lat, double? long}) async {
    ResponseServiceModel responseService =
    ResponseServiceModel(isSuccess: true, message: "", data: "");

    await mapsRepository.getAddress(lat: lat,long: long).then((res) {
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

}

