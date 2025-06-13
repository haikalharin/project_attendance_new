import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:project_attendance_new/module/bottom_nav_page/view/bottom_nav_bar_page.dart';
import 'package:project_attendance_new/module/employee_page/bindings/employee_binding.dart';
import 'package:project_attendance_new/module/employee_page/view/employee_form_page.dart';
import 'package:project_attendance_new/module/employee_page/view/employee_list_page.dart';
import 'package:project_attendance_new/module/face_recog_screen_page/view/face_recog_page.dart';
import 'package:project_attendance_new/module/face_recog_screen_page/view/face_recognation_page.dart';
import 'package:project_attendance_new/module/map_screen_page/bindings/map_screen_binding.dart';
import 'package:project_attendance_new/module/map_screen_page/view/map_screen_page.dart';
import 'package:project_attendance_new/module/splash_screen_page/bindings/splash_screen_binding.dart';
import 'package:project_attendance_new/module/splash_screen_page/view/splash_screen_page.dart';

import '../module/bottom_nav_page/bindings/bottom_nav_binding.dart';
import '../module/face_recog_screen_page/bindings/face_recog_binding.dart';
import '../module/login_page/bindings/login_binding.dart';
import '../module/login_page/view/login_page.dart';
import 'app_routes.dart';

class AppPages {
  static final list = [
    GetPage(
      name: Routes.SPLASH_SCREEN,
      page: () => const SplashScreenPage(),
      binding: SplashScreenBinding(),
    ),
    GetPage(
      name: Routes.LOGIN,
      page: () => const LoginPage(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: Routes.EMPLOYEE,
      page: () => const EmployeeListPage(),
      binding: EmployeeBinding(),
    ),
    GetPage(
      name: Routes.FORM_EMPLOYEE,
      page: () => const EmployeeFormPage(),
      binding: EmployeeBinding(),
    ),
    GetPage(
      name: Routes.BOTTOM_NAV_BAR,
      page: () => const BottomNavBarPage(),
      binding: BottomNavBarBinding(),
    ),
    GetPage(
      name: Routes.MAPS_PAGE,
      page: () => const MapScreen(),
      binding: MapScreenBinding(),
    ),
    GetPage(
      name: Routes.FACE_RECOG_PAGE,
      page: () => const FaceRecognitionPage(),
      binding: FaceRecogBinding(),
    ),
  ];
}
