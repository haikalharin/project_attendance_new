import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../utils/loading_app.dart';
import '../controllers/employee_controller.dart';

class EmployeeFormPage extends GetView<EmployeeController> {
  const EmployeeFormPage({super.key});

  @override
  Widget build(BuildContext context) {
    final employee = controller.selectedEmployee.value;

    final nameController = TextEditingController(text: employee?.name ?? '');
    final emailController = TextEditingController(text: employee?.email ?? '');
    final phoneController = TextEditingController(text: employee?.phone ?? '');
    final jobTitleController = TextEditingController(text: employee?.jobTitle ?? '');
    final departmentController = TextEditingController(text: employee?.department ?? '');
    final addressController = TextEditingController(text: employee?.address ?? '');



    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Data Karyawan'),
        backgroundColor: const Color(0xFF00B4DB),
        foregroundColor: Colors.white,
      ),
      body: Obx(() => LoadingApp(
        isLoading: controller.isLoading.value,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              _buildTextField('Nama', nameController),
              _buildTextField('Email', emailController),
              _buildTextField('Telepon', phoneController),
              _buildTextField('Jabatan', jobTitleController),
              _buildTextField('Departemen', departmentController),
              _buildTextField('Alamat', addressController),
              const SizedBox(height: 8),
              Obx(() => SwitchListTile(
                value: controller.isActive.value == 1,
                onChanged: (val) {
                  controller.isActive.value = val ? 1 : 0;
                },
                title: const Text("Status Karyawan Aktif"),
                activeColor: const Color(0xFF00B4DB),
              )),
            ],
          ),
        ),
      )),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00B4DB),
                  minimumSize: const Size.fromHeight(48),
                ),
                onPressed: () async {
                  final updatedData = {
                    "id": employee?.id ?? 0,
                    "name": nameController.text,
                    "email": emailController.text,
                    "phone": phoneController.text,
                    "jobTitle": jobTitleController.text,
                    "department": departmentController.text,
                    "address": addressController.text,
                    "status": controller.isActive.value,
                  };

                  await controller.updateEmployeeData(updatedData);
                },
                icon: const Icon(Icons.save),
                label: const Text('Simpan Perubahan'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  minimumSize: const Size.fromHeight(48),
                ),
                onPressed: () {
                  Get.defaultDialog(
                    title: "Konfirmasi Hapus",
                    middleText: "Yakin ingin menghapus data ini?",
                    textConfirm: "Ya, Hapus",
                    textCancel: "Batal",
                    confirmTextColor: Colors.white,
                    onConfirm: () {
                      Get.back();
                      controller.deleteEmployeeData(employee.id);
                    },
                  );
                },
                icon: const Icon(Icons.delete),
                label: const Text('Hapus'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
  }
}
