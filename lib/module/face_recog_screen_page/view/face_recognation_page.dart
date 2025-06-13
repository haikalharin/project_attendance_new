import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/face_recognation_controller.dart';
import '../model/result_model.dart';

class FaceRecognitionPage extends GetView<FaceRecognitionController> {
  const FaceRecognitionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Obx(() {
          final state = controller.cameraState.value;

          switch (state.status) {
            case Status.LOADING:
              return const CircularProgressIndicator();
            case Status.ERROR:
              return Text('Error: ${state.message}');
            case Status.COMPLETED:
              final camera = state.data;
              if (camera != null && camera.value.isInitialized) {
                return _buildCameraPreview(context);
              }
              return const SizedBox();
            default:
              return const SizedBox();
          }
        }),
      ),
    );
  }

  Widget _buildCameraPreview(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Obx(() {
      final cameraResult = controller.cameraState.value;

      if (cameraResult.status == Status.LOADING) {
        return const Center(child: CircularProgressIndicator());
      }

      if (cameraResult.status == Status.ERROR) {
        return Center(child: Text("Error: ${cameraResult.message}"));
      }

      final camera = cameraResult.data;

      if (camera == null || !camera.value.isInitialized) {
        return const Center(child: Text("Camera not initialized"));
      }

      return Transform.scale(
        scale: 1.0,
        child: AspectRatio(
          aspectRatio: MediaQuery.of(context).size.aspectRatio,
          child: OverflowBox(
            alignment: Alignment.center,
            child: FittedBox(
              fit: BoxFit.fitHeight,
              child: SizedBox(
                width: width,
                height: width * camera.value.aspectRatio,
                child: Stack(
                  fit: StackFit.expand,
                  children: <Widget>[
                    CameraPreview(camera),
                    if (!kReleaseMode) _buildDetector(),
                    _buildBottomWidget(),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    });
  }

  Widget _buildDetector() {
    return Obx(() {
      final painter = controller.painter.value;
      if (painter == null || painter.faces.isEmpty) return const SizedBox();
      return CustomPaint(painter: painter);
    });
  }

  Widget _buildBottomWidget() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          _buildFaceLog(),
          _buildFaceTestDesc(),
          Row(mainAxisSize: MainAxisSize.min, children: [
            _buildChangeDirectionButton(),
            _buildCaptureButton(),
          ]),
        ]),
      ),
    );
  }

  Widget _buildCaptureButton() {
    if (controller.predictedDatas.isNotEmpty) return const SizedBox();

    return Obx(() {
      final faces = controller.painter.value?.faces ?? [];

      if (faces.length != 1) return const SizedBox();

      final face = faces.first;
      final isStraight = (face.headEulerAngleY?.abs() ?? 0) <= 10 &&
          (face.headEulerAngleZ?.abs() ?? 0) <= 10;

      return ElevatedButton(
        onPressed: isStraight ? controller.capture : null,
        style: ElevatedButton.styleFrom(
          shape: const CircleBorder(),
          padding: const EdgeInsets.all(16),
        ),
        child: const Icon(Icons.camera),
      );
    });
  }

  Widget _buildChangeDirectionButton() {
    return IconButton(
      icon: Obx(() => Icon(
        _getLensIcon(controller.selectedCamera.value?.lensDirection),
        color: Colors.white,
      )),
      onPressed: controller.switchCamera,
    );
  }

  IconData _getLensIcon(CameraLensDirection? direction) {
    switch (direction) {
      case CameraLensDirection.back:
        return Icons.camera_rear;
      case CameraLensDirection.front:
        return Icons.camera_front;
      case CameraLensDirection.external:
        return Icons.camera_alt;
      default:
        return Icons.device_unknown;
    }
  }

  Widget _buildFaceTestDesc() {
    return Obx(() {
      if ((controller.faceTestDesc.value).isEmpty) return const SizedBox();
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(controller.faceTestDesc.value),
        ),
      );
    });
  }

  Widget _buildFaceLog() {
    if (kReleaseMode) return const SizedBox();

    return Obx(() {
      final faces = controller.painter.value?.faces ?? [];
      if (faces.isEmpty) return const SizedBox();

      final face = faces.first;

      return Column(mainAxisSize: MainAxisSize.min, children: [
        _buildTextFaceLog('Tracking ID', face.trackingId.toString()),
        const SizedBox(height: 2),
        _buildTextFaceLog('Head Euler Angle Y', face.headEulerAngleY?.toString() ?? 'N/A'),
        const SizedBox(height: 2),
        _buildTextFaceLog('Head Euler Angle Z', face.headEulerAngleZ?.toString() ?? 'N/A'),
        const SizedBox(height: 2),
        _buildTextFaceLog('Left Eye Open Probability', face.leftEyeOpenProbability?.toString() ?? 'N/A'),
        const SizedBox(height: 2),
        _buildTextFaceLog('Right Eye Open Probability', face.rightEyeOpenProbability?.toString() ?? 'N/A'),
        const SizedBox(height: 2),
        _buildTextFaceLog('Smiling Probability', face.smilingProbability?.toString() ?? 'N/A'),
        const SizedBox(height: 16),
      ]);
    });
  }

  Widget _buildTextFaceLog(String label, String value) {
    return Row(mainAxisSize: MainAxisSize.min, children: [
      Text('$label: ', style: const TextStyle(fontSize: 12, color: Colors.white)),
      Text(value, style: const TextStyle(fontSize: 12, color: Colors.white)),
    ]);
  }
}
