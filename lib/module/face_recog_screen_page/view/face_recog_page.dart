import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:camera/camera.dart';
import 'package:project_attendance_new/module/face_recog_screen_page/view/face_painter.dart';

import '../controllers/face_recog_controller.dart';
import '../model/detected_face_model.dart';

class FaceRecogPage extends GetView<FaceRecogController> {
  const FaceRecogPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Face Recognition Live')),
      body: Obx(() {
        final cam = controller.cameraController.value;
        if (cam == null || !cam.value.isInitialized) {
          return const Center(child: CircularProgressIndicator());
        }

        final size = MediaQuery.of(context).size;
        final camData = controller.cameraController.value;
        if (camData == null || !cam.value.isInitialized) {
          return const Center(child: CircularProgressIndicator());
        }

        final scale = size.aspectRatio * camData.value.aspectRatio;
        return Stack(
          fit: StackFit.expand,
          children: [
            Transform.scale(
                scale: scale,
                child:
                Obx(() {
                  final cam = controller.cameraController.value;
                  if (cam == null || !cam.value.isInitialized) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  return CameraPreview(cam);
                })

            ),
            Obx(() {
              final cam = controller.cameraController.value;

              if (cam == null || !cam.value.isInitialized || cam.value.previewSize == null) {
                return const Center(child: CircularProgressIndicator());
              }

              // Salin daftar wajah secara aman
              final faces = List<DetectedFaceModel>.from(controller.detectedFaces);

              return CustomPaint(
                painter: FacePainter(
                  faces: faces,
                  imageSize: Size(
                    cam.value.previewSize!.height,
                    cam.value.previewSize!.width,
                  ),
                  isCameraFront: true,
                ),
              );
            }),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                color: Colors.black54,
                padding: const EdgeInsets.all(12),
                child: Obx(() => Text(
                      controller.status.value,
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                    )),
              ),
            ),
          ],
        );
      }),
    );
  }
}

