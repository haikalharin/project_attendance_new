import 'dart:async';
import 'dart:io';
import 'dart:ui' as ui;
import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import '../model/face_embedding_model.dart';
import '../model/result_model.dart';
import '../view/face_painter_new.dart';

class FaceRecognitionController extends GetxController {
  final Rx<ResultModel<CameraController?>> cameraState =
      ResultModel<CameraController?>.loading().obs;

  final Rx<CameraDescription?> selectedCamera = Rx<CameraDescription?>(null);
  final RxList<ResultModel<FaceEmbeddingModel>> predictedDatas = <ResultModel<FaceEmbeddingModel>>[].obs;

  final RxString faceTestDesc = ''.obs;
  final Rx<FacePainter?> painter = Rx<FacePainter?>(null);
  final RxInt resultCompare = 0.obs;
  final Rx<FaceEmbeddingModel?> faceData = Rx<FaceEmbeddingModel?>(null);
  final List<FaceEmbeddingModel> predictedDatasFace =
      (Get.arguments?['predicted_datas'] as List<dynamic>?)
          ?.cast<FaceEmbeddingModel>() ?? [];

  List<CameraDescription>? cameras;
  late FaceDetector faceDetector;
  bool _isDetecting = false;
  late Timer _timer;

  @override
  void onInit() {
    super.onInit();
    // Dummy prediction data
    predictedDatas.assignAll([
      ResultModel.completed(FaceEmbeddingModel([0.1, 0.2, 0.3, 0.4])),
      ResultModel.completed(FaceEmbeddingModel([0.15, 0.22, 0.35, 0.42])),
    ]);
    initial(predictedDatasFace);
  }

  void _initFaceDetector() {
    final options = FaceDetectorOptions(
      enableContours: true,
      enableClassification: true,
      performanceMode: FaceDetectorMode.fast,
    );
    faceDetector = FaceDetector(options: options);
  }

  Future<void> initial(List<dynamic> datas) async {
    if (datas.isNotEmpty) {
      predictedDatas.assignAll(datas.cast<ResultModel<FaceEmbeddingModel>>());
    }
    await _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    try {
      cameraState.value = ResultModel.loading();

      cameras = await availableCameras();
      cameras = await availableCameras();
      selectedCamera.value = cameras!.firstWhere(
            (c) => c.lensDirection == CameraLensDirection.front,
      );

      final controller = CameraController(
        selectedCamera.value!,
        ResolutionPreset.medium,
        enableAudio: false,
      );
      await controller.initialize();
      cameraState.value = ResultModel.completed(controller);

      _startImageStream(controller);
    } catch (e) {
      cameraState.value = ResultModel.error(e.toString());
    }
  }

  void _startImageStream(CameraController controller) {
    controller.startImageStream((CameraImage image) async {
      if (_isDetecting) return;
      _isDetecting = true;

      try {
        final inputImage = _getInputImage(image, controller.description.sensorOrientation);
        final faces = await faceDetector.processImage(inputImage);

        if (faces.isNotEmpty) {
          final face = faces.first;
          final anglesOK = ((face.headEulerAngleY?.abs() ?? 0) <= 10) &&
              ((face.headEulerAngleZ?.abs() ?? 0) <= 10);

          faceTestDesc.value = anglesOK ? "Good Angle" : "Adjust Face";

          painter.value = FacePainter(faces: faces, imageSize: inputImage.metadata!.size);
        } else {
          faceTestDesc.value = "No face detected";
          painter.value = null;
        }
      } catch (_) {
        painter.value = null;
      }

      _isDetecting = false;
    });
  }

  InputImage _getInputImage(CameraImage image, int rotation) {
    final allBytes = WriteBuffer();
    for (var plane in image.planes) {
      allBytes.putUint8List(plane.bytes);
    }

    final bytes = allBytes.done().buffer.asUint8List();
    final ui.Size imageSize = ui.Size(image.width.toDouble(), image.height.toDouble());

    final InputImageRotation imageRotation =
        InputImageRotationValue.fromRawValue(rotation) ?? InputImageRotation.rotation0deg;

    final inputImageFormat =
         Platform.isIOS?InputImageFormat.yuv420:InputImageFormat.nv21;



    final metadata = InputImageMetadata(
      size: imageSize,
      rotation: imageRotation,
      format: inputImageFormat,
      bytesPerRow: image.planes.first.bytesPerRow,
    );

    return InputImage.fromBytes(bytes: bytes, metadata: metadata);
  }

  void switchCamera() {
    if (cameras == null || cameras!.isEmpty) return;

    final currentIndex = cameras!.indexOf(selectedCamera.value!);
    final nextIndex = (currentIndex + 1) % cameras!.length;
    selectedCamera.value = cameras![nextIndex];

    cameraState.value.data?.dispose();
    _initializeCamera();
  }

  void capture() {
    // Simulasi face vector, nanti diganti dengan hasil dari model
    faceData.value = FaceEmbeddingModel([0.1, 0.2, 0.3, 0.4]);
    Get.back(result: faceData.value);
  }

  void verifyFace() {
    if (faceData.value == null) return;

    final refVector = faceData.value!;
    final result = predictedDatas.firstWhereOrNull((e) {
      final double distance = e.data!.distanceTo(refVector);
      return distance < 0.6; // threshold
    });

    resultCompare.value = result != null ? 1 : -1;
    Get.back(result: resultCompare.value == 1);
  }

  @override
  void onClose() {
    cameraState.value.data?.dispose();
    faceDetector.close();
    super.onClose();
  }
}
