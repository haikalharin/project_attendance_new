import 'package:dio/dio.dart';
import 'package:project_attendance_new/adapter/maps_adapter.dart';
import 'package:project_attendance_new/adapter/login_adapter.dart';

import '../api_client/api_client.dart';
import '../exception/server_exception.dart';
import '../services/config.dart';
import '../utils/snackbar.dart';

class MapsRepository extends IMapsRepository {
  MapsRepository({required this.apiClient});

  final ApiClient apiClient;

  @override
  Future<Response> getAddress({double? lat, double? long}) async {
    try {
      final response = await apiClient.getMaps("${Config.ApiMapsEndpoint}?lat=$lat&lon=$long&format=json");

      return response;
    } catch (error, stacktrace) {
      AppSnackBar.error(("Fail to connect with server, please try again"),
          title: "Error");

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
