import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:project_attendance_new/routes/app_pages.dart';
import 'package:project_attendance_new/routes/app_routes.dart';
import 'package:responsive_framework/responsive_framework.dart';

// Import lainnya seperti Routes, AppPages, LabelLanguage, Environment, APP_NAME

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    return GetMaterialApp(
      theme: ThemeData(useMaterial3: false),
      initialRoute: Routes.SPLASH_SCREEN,
      getPages: AppPages.list,
      title: "Project_attendance",
      debugShowCheckedModeBanner: true,
      enableLog: false,
      builder: (context, child) => ResponsiveBreakpoints.builder(
        child: child!,
        breakpoints: [
          const Breakpoint(start: 0, end: 450, name: MOBILE),
          const Breakpoint(start: 451, end: 800, name: TABLET),
          const Breakpoint(start: 801, end: 1920, name: DESKTOP),
          const Breakpoint(start: 1921, end: double.infinity, name: '4K'),
        ],
      ),
      routingCallback: (routing) async {
        // if (routing != null) {
        //   try {
        //     String current = routing.current.toString();
        //     await FirebaseAnalytics.instance
        //         .logScreenView(screenName: current);
        //     await FirebaseAnalytics.instance
        //         .setCurrentScreen(screenName: current);
        //   } catch (e) {
        //     // Logger.printLog("[ERROR] Firebase double instance : $e");
        //   }
        // }
      },
    );
  }
}

