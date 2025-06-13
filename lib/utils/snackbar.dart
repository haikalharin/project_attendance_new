import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppSnackBar {
  static void dynamic(
      {String title = "Info",
      required String message,
      Color colorText = Colors.white,
      Color backgroundColor = Colors.black,
      required Icon icon,
      SnackPosition snackPosition = SnackPosition.TOP,
      int seconds = 3}) {
    Get.snackbar(
      title,
      message,
      icon: icon,
      colorText: colorText,
      backgroundColor: backgroundColor,
      forwardAnimationCurve: Curves.fastOutSlowIn,
      snackPosition: snackPosition,
      shouldIconPulse: true,
      margin: EdgeInsets.only(bottom: 5, left: 20, right: 20),
      isDismissible: true,
      duration: Duration(seconds: seconds),
    );
  }

  static void success(String message) {
    Get.snackbar(
      "Success",
      message,
      icon: Icon(Icons.check_circle_outline_rounded, color: Colors.white),
      colorText: Colors.white,
      backgroundColor: Colors.blue,
      forwardAnimationCurve: Curves.fastOutSlowIn,
      snackPosition: SnackPosition.TOP,
      shouldIconPulse: true,
      margin: EdgeInsets.only(bottom: 5, left: 20, right: 20),
      isDismissible: true,
      duration: Duration(seconds: 2),
    );
  }

  static void info(String message) {
    Get.snackbar(
      "Info",
      message,
      icon: Icon(Icons.info, color: Colors.white),
      colorText: Colors.white,
      backgroundColor: Colors.orange[900],
      forwardAnimationCurve: Curves.fastOutSlowIn,
      snackPosition: SnackPosition.TOP,
      shouldIconPulse: true,
      margin: EdgeInsets.only(bottom: 5, left: 20, right: 20),
      isDismissible: true,
      duration: Duration(seconds: 4),
    );
  }

  static void error(String message, {String? title}) {
    Get.snackbar(
      title ?? "Error",
      message,
      icon: Icon(Icons.error, color: Colors.white),
      colorText: Colors.white,
      backgroundColor: Colors.red[900],
      forwardAnimationCurve: Curves.fastOutSlowIn,
      snackPosition: SnackPosition.TOP,
      shouldIconPulse: true,
      margin: EdgeInsets.only(bottom: 5, left: 20, right: 20),
      isDismissible: true,
      duration: Duration(seconds: 4),
    );
  }

  static void general(String message, {String? title}) {
    Get.snackbar(
      title ?? "Information",
      message,
      icon: Icon(Icons.error, color: Colors.white),
      colorText: Colors.white,
      backgroundColor: Colors.blue,
      forwardAnimationCurve: Curves.fastOutSlowIn,
      snackPosition: SnackPosition.TOP,
      shouldIconPulse: true,
      margin: EdgeInsets.only(bottom: 5, left: 20, right: 20),
      isDismissible: true,
      duration: Duration(seconds: 4),
    );
  }
}
