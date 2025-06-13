// controller/employee_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/app_preferences.dart';
import '../../../routes/app_routes.dart';
import '../../../services/employee_service/employee_services.dart';
import '../../../services/models/response_service_model.dart';
import '../../../utils/dialog.dart';
import '../../login_page/view/login_page.dart';
import '../model/employee_model.dart';
import '../model/employee_model_new.dart';

class EmployeeController extends GetxController {
  final EmployeeServices employeeServices;
  final isLoading = false.obs;

  EmployeeController({required this.employeeServices});

  RxInt isActive = (-1).obs; // default -1 agar tahu belum diinisialisasi
  var employees = EmployeeModel(data: [], status: false).obs;
  var selectedEmployee = Datum(id: 0, name: '', status: 0, address: '', department: '', jobTitle: '', email: '', phone: '', photo: '').obs;

  @override
  Future<void> onInit() async {
    await getListEmployee();
    super.onInit();
  }


  void setSelectedEmployee(Datum employee) {
    // Inisialisasi status aktif jika belum di-set
      isActive.value = employee.status;
    selectedEmployee.value = employee;
  }

  Future<void> getListEmployee() async {
    isLoading.value = true;
    try {
      ResponseServiceModel response = await employeeServices.getListEmployee();

      if (response.isSuccess) {
        var data = response.data;
        EmployeeModel employeeModel = employeeModelFromJson(data);

        if (employeeModel.status == true) {
          // Get.snackbar('Success','',
          //     snackPosition: SnackPosition.BOTTOM);
          employees.value = employeeModel;
        } else {
          Get.snackbar('Error', '',
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.redAccent,
              colorText: Colors.white);
        }

        isLoading.value = false;
      } else {
        isLoading.value = false;
        AppDialog.DialogInfo(
          onBtnCenter: () {
            Get.back();
          },
          title: 'Info!',
          btnCenter: 'OK',
          desc: "Failed",
        );
        return;
      }
    } catch (e) {
      isLoading.value = false;
      Get.snackbar('Error', 'Email atau password salah',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent,
          colorText: Colors.white);
    }
  }

  Future<void> updateEmployeeData(Map<String, dynamic> body) async {
    isLoading.value = true;

    try {
      ResponseServiceModel response =
          await employeeServices.updateEmployee( body);

      if (response.isSuccess) {
        // Jika berhasil, refresh list karyawan
        await getListEmployee();

        Get.back(); // Kembali ke halaman sebelumnya
        Get.snackbar('Success', 'Data berhasil diperbarui',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white);
        isLoading.value = false;
      } else {
        isLoading.value = false;

        AppDialog.DialogInfo(
          onBtnCenter: () {
            Get.back();
          },
          title: 'Gagal',
          btnCenter: 'OK',
          desc: response.message,
        );
      }
    } catch (e) {
      isLoading.value = false;

      Get.snackbar('Error', 'Terjadi kesalahan saat memperbarui data',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent,
          colorText: Colors.white);
    }
  }

  Future<void> deleteEmployeeData(int id) async {
    isLoading.value = true;

    try {
      final response = await employeeServices.deleteEmployee(id.toString());

      if (response.isSuccess) {
        // Refresh list data
        await getListEmployee();
        Get.back(); // Kembali ke halaman list

        Get.snackbar(
          'Sukses',
          'Data berhasil dihapus',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        isLoading.value = false;

        AppDialog.DialogInfo(
          onBtnCenter: () {
            Get.back();
          },
          title: 'Info!',
          btnCenter: 'OK',
          desc: response.message,
        );
      }
    } catch (e) {
      isLoading.value = false;

      Get.snackbar(
        'Error',
        'Gagal menghapus data',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    }
  }

  void logout() async {
    await AppPreferences.clear(); // hapus status login
    Get.offAllNamed(
        Routes.LOGIN); // kembali ke login dan hapus semua halaman sebelumnya
  }
}
