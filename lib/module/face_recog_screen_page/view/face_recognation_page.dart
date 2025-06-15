import 'package:camerawesome/camerawesome_plugin.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/face_recognation_controller.dart';

class FaceRecognitionPage extends StatelessWidget {
  final FaceRecognitionController controller = Get.put(FaceRecognitionController());

  FaceRecognitionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          AwesomeCamera(
            selectDefaultSize: true,
            sensor: Sensors.front,
            onImageForAnalysis: (img) async {
              await controller.processImage(img);
            },
            imageAnalysisConfig: AnalysisConfig(
              androidOptions: AndroidAnalysisOptions.nv21(width: 480, height: 640),
              iosOptions: IOSAnalysisOptions.bgra8888(width: 480, height: 640),
            ),
          ),
          Obx(() => _buildFaceBoxes()),
          Obx(() => _buildStatusText()),
        ],
      ),
    );
  }

  Widget _buildFaceBoxes() {
    final faces = controller.detectedFaces;
    if (faces.isEmpty) return const SizedBox();

    return Stack(
      children: faces.map((f) {
        return Positioned(
          left: f.left,
          top: f.top,
          width: f.right - f.left,
          height: f.bottom - f.top,
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.greenAccent, width: 2),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildStatusText() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        padding: const EdgeInsets.all(12),
        child: Text(
          controller.status.value,
          style: const TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
    );
  }
}
