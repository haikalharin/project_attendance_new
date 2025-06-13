// pages/employee_list_page.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../routes/app_routes.dart';
import '../controllers/employee_controller.dart';

class EmployeeListPage extends GetView<EmployeeController> {
  const EmployeeListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Color(0xFF00B4DB)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Obx(() => ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: (controller.employees.value.data).length,
              itemBuilder: (context, index) {
                final employee = (controller.employees.value.data)[index];
                return Card(
                  color: Colors.white.withAlpha(95),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 4,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor:
                          (employee.status == 1) ? Colors.green : Colors.grey,
                      child: Text(
                        (employee.name.isNotEmpty?employee.name:"Empty")[0],
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    title: Text((employee.name.isNotEmpty?employee.name:"Other")),
                    subtitle: Text(
                      employee.status == 1 ? 'Aktif' : 'Nonaktif',
                      style: TextStyle(
                        color: employee.status == 1 ? Colors.green : Colors.red,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      controller.setSelectedEmployee(employee);
                      Get.toNamed(Routes.FORM_EMPLOYEE);
                      // Get.snackbar(
                      //   'Info Karyawan',
                      //   'Karyawan: ${employee.name} ${(employee.status == 1) ? 'Aktif' : 'Nonaktif'}',
                      //   snackPosition: SnackPosition.BOTTOM,
                      // );
                    },
                  ),
                );
              },
            )),
      ),
    );
  }
}
