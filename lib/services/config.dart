// ignore_for_file: non_constant_identifier_names

import 'dart:io';


// const IMAGE_PATH = "assets/images/";
// const ICON_PATH = "assets/icons/";

abstract class Config {
  static String ApiEndpoint = "http://10.10.10.6/restapi/api";
  static String ApiMapsEndpoint = "https://nominatim.openstreetmap.org/reverse";
  static String login = "$ApiEndpoint/auth/login";
  static String getListEmployee = "$ApiEndpoint/listkaryawan";
  static String updateEmployee = "$ApiEndpoint/karyawan/updatekaryawan";
  static String deleteEmployee = "$ApiEndpoint/karyawan/deletekaryawan";

}

// Future<String?> getDeviceId() async {
//   final FlutterSecureStorage storage = FlutterSecureStorage();
//   var deviceInfo = DeviceInfoPlugin();
//
//   if (Platform.isIOS) {
//     // unique ID on iOS
//     print('Storage instance: ${storage.iOptions.hashCode}');
//     final options =
//         IOSOptions(accessibility: KeychainAccessibility.first_unlock);
//     String? storedId = await storage.read(key: 'device_id', iOptions: options);
//     var iosDeviceInfo = await deviceInfo.iosInfo;
//     if (storedId != iosDeviceInfo.identifierForVendor) {
//       await storage.delete(key: 'device_id');
//       storedId = await storage.read(key: 'device_id', iOptions: options);
//     }
//
//     if (storedId == null) {
//       await storage.write(
//           key: 'device_id',
//           value: iosDeviceInfo.identifierForVendor,
//           iOptions: options);
//       return iosDeviceInfo.identifierForVendor;
//     }
//     return storedId;
//   } else {
//     const androidId = AndroidId();
//     return await androidId.getId(); // unique ID on Android
//   }
// }
//
// bool isSetupLanguage() {
//   var isSetup = false;
//   String languageCode = AuthPrefs.getLanguage() ?? "";
//
//   if (AuthPrefs.getLanguage() != null) {
//     languageCode = AuthPrefs.getLanguage().toString();
//   }
//
//   if (languageCode != "") {
//     isSetup = true;
//   }
//
//   return isSetup;
// }
//
// Future<String?> getDeviceName() async {
//   var deviceInfo = DeviceInfoPlugin();
//   if (Platform.isIOS) {
//     var iosDeviceInfo = await deviceInfo.iosInfo;
//     return "${iosDeviceInfo.systemName} ${iosDeviceInfo.systemVersion}";
//   } else {
//     var androidDeviceInfo = await deviceInfo.androidInfo;
//     return "${androidDeviceInfo.model} ${androidDeviceInfo.device}-api${androidDeviceInfo.version.sdkInt}";
//   }
// }
//
// Future<Map> getPackageInfo() async {
//   PackageInfo packageInfo = await PackageInfo.fromPlatform();
//   String? version = packageInfo.version;
//   String? build = packageInfo.buildNumber;
//   return {
//     "version": version,
//     "build": build,
//   };
// }

