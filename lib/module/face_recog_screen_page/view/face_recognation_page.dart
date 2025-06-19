import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/face_recognation_controller.dart';

class FaceRecognitionPage extends GetView<FaceRecognitionController> {
  const FaceRecognitionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Verifikasi Wajah')),
      body: Obx(() {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const Text("📷 Foto Referensi", style: TextStyle(fontSize: 16)),
              const SizedBox(height: 8),
              controller.referenceImageBytes.value != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.memory(
                        controller.referenceImageBytes.value!,
                        width: double.infinity,
                        height: 180,
                        fit: BoxFit.cover,
                      ),
                    )
                  : Container(
                      width: double.infinity,
                      height: 180,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      alignment: Alignment.center,
                      child: const Text("Belum ada foto referensi"),
                    ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: controller.pickReferenceImage,
                icon: const Icon(Icons.photo_camera),
                label: const Text("Ambil Foto Referensi"),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () => controller.startLiveCaptureAndCompare(context),
                icon: const Icon(Icons.face),
                label: const Text("Mulai Pengenalan Wajah"),
              ),
              const SizedBox(height: 24),
              if (controller.isLoading.value) const CircularProgressIndicator(),
              if (!controller.isLoading.value &&
                  controller.similarity.value > 0)
                Text(
                  "Similarity: ${(controller.similarity.value * 100).toStringAsFixed(2)}%",
                  style: TextStyle(
                    fontSize: 16,
                    color: controller.similarity.value >= 0.75
                        ? Colors.green
                        : Colors.red,
                  ),
                ),
            ],
          ),
        );
      }),
    );
  }
}
