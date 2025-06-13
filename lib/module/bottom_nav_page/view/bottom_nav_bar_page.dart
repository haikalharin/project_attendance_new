// lib/views/main_page.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../employee_page/view/employee_list_page.dart';
import '../../setting_page/setting_page.dart';
import '../controllers/bottom_nav_controller.dart';

class BottomNavBarPage extends GetView<BottomNavBarController> {
  const BottomNavBarPage({super.key});

  final List<Widget> pages = const [
    EmployeeListPage(),
    SettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Attendance App'),
          backgroundColor: const Color(0xFF00B4DB),
          foregroundColor: Colors.white,
          elevation: 0,
          actions: [
            IconButton(
              onPressed: controller.logout,
              icon: const Icon(Icons.logout),
              tooltip: 'Logout',
            ),
          ],
          leading: Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () => Scaffold.of(context).openDrawer(),
            ),
          ),
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              const DrawerHeader(
                decoration: BoxDecoration(
                  color: Color(0xFF00B4DB),
                ),
                child: Text(
                  'Menu',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.person),
                title: const Text('Profil'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.info),
                title: const Text('Tentang Aplikasi'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.logout),
                title: const Text('Logout'),
                onTap: () {
                  Navigator.pop(context);
                  Get.snackbar("Logout", "Kamu telah logout.");
                },
              ),
            ],
          ),
        ),
        body: pages[controller.currentIndex.value],
        floatingActionButton: FloatingActionButton(
          onPressed: controller.goToAttendance, // aksi absen
          backgroundColor: Colors.orange,
          child: const Icon(Icons.fingerprint, size: 32),
          tooltip: 'Absen',
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: BottomAppBar(
          shape: const CircularNotchedRectangle(),
          notchMargin: 8.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                icon: const Icon(Icons.home),
                color: controller.currentIndex.value == 0
                    ? Colors.blue
                    : Colors.grey,
                onPressed: () => controller.changeTab(0),
              ),
              const SizedBox(width: 48), // untuk memberi ruang ke FAB
              IconButton(
                icon: const Icon(Icons.settings),
                color: controller.currentIndex.value == 1
                    ? Colors.blue
                    : Colors.grey,
                onPressed: () => controller.changeTab(1),
              ),
            ],
          ),
        ),
      );
    });
  }
}
