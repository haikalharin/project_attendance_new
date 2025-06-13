import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../data/app_preferences.dart';
import '../exception/exceptions.dart';
import '../utils/connection_utils.dart';
import '../utils/logger_utils.dart';
import '../utils/snackbar.dart';

class ApiClient {
  final Dio dio;

  bool valResponseBody = true;

  ApiClient(this.dio);

  /// handle response
  Future<Object> _handleResponse(Response response) async {
    try {
      if (response.statusCode == 401 ||
          response.statusCode == 402 ||
          response.statusCode == 403) {
        // await Helpers.clearToken();
        try {
          AppSnackBar.info(response.data['message']);
        } catch (e) {
          AppSnackBar.info(response.data['error']);
        }
      }
      return response;
    } catch (error) {
      //Logger.printLog('$error');
      return response;
    }
  }

  Future post(
    String path,
    dynamic data,
  ) async {
    if (await ConnectionUtils.isNetworkConnected()) {
      try {
        Dio dioPost = new Dio();

        if (!path.contains("login")) {
          String bearerToken = "Bearer ${AppPreferences.getToken()}";

          dioPost.options.headers["Authorization"] = bearerToken;
          dioPost.options.connectTimeout = const Duration(minutes: 3);
          dioPost.options.receiveTimeout = const Duration(minutes: 3);
        }

        dioPost.interceptors.addAll([
          PrettyDioLogger(
            requestHeader: true,
            requestBody: true,
            responseHeader: true,
            responseBody: valResponseBody,
            error: true,
            compact: true,
          ),
        ]);

        final response = await dioPost.post(
          path,
          data: data,
          options: Options(
            contentType: Headers.formUrlEncodedContentType,
            followRedirects: false,
            validateStatus: (status) {
              return status! < 500;
            },
          ),
        );
        // return _handleResponse(response);

        Logger.printLog("status code : " + response.statusCode.toString());

        if (response.statusCode == 401 || response.statusCode == 403) {
          Logger.printLog("refresh token -- from post");

          RequestOptions requestOptions = response.requestOptions;
          final options = Options(method: requestOptions.method);

          // dioPost.options.headers['Authorization'] =
          // 'Bearer ${AuthPrefs.getTokenWso()}';

          return await dioPost.request<dynamic>(path,
              options: options, data: requestOptions.data);
        } else {
          return _handleResponse(response);
        }
      } catch (e) {
        Logger.printLog(e);
      }
    } else {
      Logger.printLog('no_internet');
      throw BadNetworkException();
    }
  }

  Future get(
    String path,
  ) async {
    if (await ConnectionUtils.isNetworkConnected()) {
      try {
        Dio dioGet = new Dio();
       var token = await AppPreferences.getToken();
        String bearerToken = "Bearer $token";

        dioGet.options.headers["Authorization"] = bearerToken;
        dioGet.options.connectTimeout = const Duration(minutes: 3);
        dioGet.options.receiveTimeout = const Duration(minutes: 3);

        dioGet.interceptors.addAll([
          PrettyDioLogger(
            requestHeader: true,
            requestBody: true,
            responseHeader: true,
            responseBody: valResponseBody,
            error: true,
            compact: true,
          ),
        ]);

        final response = await dioGet.get(
          path,
          options: Options(
            followRedirects: false,
            validateStatus: (status) {
              return status! < 500;
            },
          ),
        );
        // return _handleResponse(response);

        Logger.printLog("status code : " + response.statusCode.toString());

        if (response.statusCode == 401 || response.statusCode == 403) {
          Logger.printLog("refresh token -- from post");

          RequestOptions requestOptions = response.requestOptions;
          final options = Options(method: requestOptions.method);

          // dioPost.options.headers['Authorization'] =
          // 'Bearer ${AuthPrefs.getTokenWso()}';

          return await dioGet.request<dynamic>(path, options: options);
        } else {
          return _handleResponse(response);
        }
      } catch (e) {
        Logger.printLog(e);
      }
    } else {
      Logger.printLog('no_internet');
      throw BadNetworkException();
    }
  }

  Future delete(String path, String id) async {
    if (await ConnectionUtils.isNetworkConnected()) {
      try {
        Dio dioDelete = Dio();
        var token = await AppPreferences.getToken();
        String bearerToken = "Bearer $token";

        dioDelete.options.headers["Authorization"] = bearerToken;
        dioDelete.options.connectTimeout = const Duration(minutes: 3);
        dioDelete.options.receiveTimeout = const Duration(minutes: 3);

        dioDelete.interceptors.addAll([
          PrettyDioLogger(
            requestHeader: true,
            requestBody: true,
            responseHeader: true,
            responseBody: valResponseBody,
            error: true,
            compact: true,
          ),
        ]);

        final fullPath = "$path/$id"; // 🧠 penting: tambahkan id ke path

        final response = await dioDelete.delete(
          fullPath,
          options: Options(
            followRedirects: false,
            validateStatus: (status) => status! < 500,
          ),
        );

        Logger.printLog("status code : ${response.statusCode}");

        if (response.statusCode == 401 || response.statusCode == 403) {
          Logger.printLog("refresh token -- from delete by id");

          RequestOptions requestOptions = response.requestOptions;
          final options = Options(method: requestOptions.method);

          return await dioDelete.request<dynamic>(fullPath, options: options);
        } else {
          return _handleResponse(response);
        }
      } catch (e) {
        Logger.printLog(e);
        rethrow;
      }
    } else {
      Logger.printLog('no_internet');
      throw BadNetworkException();
    }
  }

  Future update(String path, Map<String, dynamic> data) async {
    if (await ConnectionUtils.isNetworkConnected()) {
      try {
        Dio dioUpdate = Dio();
        var token = await AppPreferences.getToken();
        String bearerToken = "Bearer $token";

        dioUpdate.options.headers["Authorization"] = bearerToken;
        dioUpdate.options.connectTimeout = const Duration(minutes: 3);
        dioUpdate.options.receiveTimeout = const Duration(minutes: 3);

        dioUpdate.interceptors.addAll([
          PrettyDioLogger(
            requestHeader: true,
            requestBody: true,
            responseHeader: true,
            responseBody: valResponseBody,
            error: true,
            compact: true,
          ),
        ]);

        final fullPath = "$path"; // Contoh: https://api.example.com/items/123

        final response = await dioUpdate.put(
          fullPath,
          data: data,
          options: Options(
            followRedirects: false,
            validateStatus: (status) => status! < 500,
          ),
        );

        Logger.printLog("status code : ${response.statusCode}");

        if (response.statusCode == 401 || response.statusCode == 403) {
          Logger.printLog("refresh token -- from update by id");

          RequestOptions requestOptions = response.requestOptions;
          final options = Options(method: requestOptions.method);

          return await dioUpdate.request<dynamic>(
            fullPath,
            data: data,
            options: options,
          );
        } else {
          return _handleResponse(response);
        }
      } catch (e) {
        Logger.printLog(e);
        rethrow;
      }
    } else {
      Logger.printLog('no_internet');
      throw BadNetworkException();
    }
  }

  Future getMaps(
      String path,
      ) async {
    if (await ConnectionUtils.isNetworkConnected()) {
      try {
        Dio dioGet = new Dio();

        dioGet.options.connectTimeout = const Duration(minutes: 3);
        dioGet.options.receiveTimeout = const Duration(minutes: 3);
        dioGet.options.headers = {
          'Content-Type': 'application/json',
          'User-Agent': 'project_attendance_flutter/1.0 (haikalharin1998@gmail.com)',
        };
        dioGet.options.responseType = ResponseType.json;

        dioGet.interceptors.addAll([
          PrettyDioLogger(
            requestHeader: true,
            requestBody: true,
            responseHeader: true,
            responseBody: valResponseBody,
            error: true,
            compact: true,
          ),
        ]);

        final response = await dioGet.get(
          path,
          options: Options(
            followRedirects: false,
            validateStatus: (status) {
              return status! < 500;
            },
          ),
        );
        // return _handleResponse(response);

        Logger.printLog("status code : " + response.statusCode.toString());

        if (response.statusCode == 401 || response.statusCode == 403) {
          Logger.printLog("refresh token -- from post");

          RequestOptions requestOptions = response.requestOptions;
          final options = Options(method: requestOptions.method);

          // dioPost.options.headers['Authorization'] =
          // 'Bearer ${AuthPrefs.getTokenWso()}';

          return await dioGet.request<dynamic>(path, options: options);
        } else {
          return _handleResponse(response);
        }
      } catch (e) {
        Logger.printLog(e);
      }
    } else {
      Logger.printLog('no_internet');
      throw BadNetworkException();
    }
  }

}
