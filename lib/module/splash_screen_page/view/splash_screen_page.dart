import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_attendance_new/module/splash_screen_page/controllers/splash_screen_controller.dart';

class SplashScreenPage extends GetView<SplashScreenController> {
  const SplashScreenPage({super.key});


  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text("Splash Screen")),
    );
  }
}
