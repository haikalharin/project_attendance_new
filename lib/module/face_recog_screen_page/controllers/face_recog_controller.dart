import 'dart:io';
import 'dart:typed_data';
import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import '../model/face_embedding_model.dart';
import '../model/detected_face_model.dart';

class FaceRecogController extends GetxController {
  final Rxn<CameraController> cameraController = Rxn<CameraController>();
  final RxBool isCameraInitialized = false.obs;
  final RxList<DetectedFaceModel> detectedFaces = <DetectedFaceModel>[].obs;
  final RxString status = 'Tekan mulai untuk buka kamera'.obs;

  late List<CameraDescription> cameras;
  bool isProcessing = false;
  FaceEmbeddingModel? referenceFace;
  bool referenceCaptured = false;

  final FaceDetector faceDetector = FaceDetector(
    options: FaceDetectorOptions(
      enableClassification: true,
      enableContours: true,
      performanceMode: FaceDetectorMode.accurate,
    ),
  );

  @override
  void onInit() {
    super.onInit();
    initCamera();
  }

  Future<void> initCamera() async {
    try {
      cameras = await availableCameras();
      final frontCamera = cameras.firstWhere(
            (c) => c.lensDirection == CameraLensDirection.front,
      );

      final controller = CameraController(
        frontCamera,
        ResolutionPreset.medium,
        enableAudio: false,
        imageFormatGroup:
        Platform.isIOS ? ImageFormatGroup.bgra8888 : ImageFormatGroup.nv21,
      );

      await controller.initialize();

      cameraController.value = controller;
      isCameraInitialized.value = true;

      await controller.startImageStream(_processCameraImage);
      status.value = 'Kamera siap. Arahkan wajah.';
    } catch (e) {
      debugPrint('Camera init error: $e');
      status.value = '❌ Gagal inisialisasi kamera.';
    }
  }

  Future<void> stopCamera() async {
    final ctrl = cameraController.value;
    if (ctrl != null) {
      try {
        await ctrl.stopImageStream();
        await ctrl.dispose();
      } catch (e) {
        debugPrint('Error disposing camera: $e');
      }
      cameraController.value = null;
    }

    isCameraInitialized.value = false;
    status.value = 'Kamera dimatikan.';
    referenceCaptured = false;
    detectedFaces.clear();
  }

  void _processCameraImage(CameraImage image) async {
    if (isProcessing || cameraController.value == null) return;
    isProcessing = true;

    final inputImage = _convertCameraImage(image);
    if (inputImage == null) {
      isProcessing = false;
      return;
    }

    try {
      final faces = await faceDetector.processImage(inputImage);
      if (faces.isEmpty) {
        status.value = 'Tidak ada wajah.';
        detectedFaces.clear();
      } else {
        detectedFaces.value = faces
            .map((f) => DetectedFaceModel.fromRect(f.boundingBox))
            .toList();

        final currentFace = _extractFeatures(faces.first);

        if (!referenceCaptured) {
          referenceFace = currentFace;
          referenceCaptured = true;
          status.value = '✅ Wajah acuan disimpan. Silakan verifikasi...';
        } else {
          final distance = referenceFace!.distanceTo(currentFace);
          status.value = distance < 0.6
              ? '✅ Cocok (distance: ${distance.toStringAsFixed(3)})'
              : '❌ Tidak cocok (distance: ${distance.toStringAsFixed(3)})';
        }
      }
    } catch (e) {
      status.value = '❌ Gagal mendeteksi wajah.';
      debugPrint('Face detection error: $e');
    }

    isProcessing = false;
  }

  InputImage? _convertCameraImage(CameraImage image) {
    try {
      final WriteBuffer allBytes = WriteBuffer();
      for (final Plane plane in image.planes) {
        allBytes.putUint8List(plane.bytes);
      }
      final bytes = allBytes.done().buffer.asUint8List();

      final Size imageSize =
      Size(image.width.toDouble(), image.height.toDouble());

      final InputImageRotation imageRotation =
          InputImageRotation.rotation0deg; // adjust if needed

      final InputImageFormat inputImageFormat =
      Platform.isIOS ? InputImageFormat.bgra8888 : InputImageFormat.nv21;

      final plane = image.planes.first;

      final metadata = InputImageMetadata(
        size: imageSize,
        rotation: imageRotation,
        format: inputImageFormat,
        bytesPerRow: plane.bytesPerRow,
      );

      return InputImage.fromBytes(bytes: bytes, metadata: metadata);
    } catch (e) {
      debugPrint('Error converting image: $e');
      return null;
    }
  }

  FaceEmbeddingModel _extractFeatures(Face face) {
    final features = [
      face.boundingBox.left,
      face.boundingBox.top,
      face.boundingBox.right,
      face.boundingBox.bottom,
      face.headEulerAngleX ?? 0,
      face.headEulerAngleY ?? 0,
      face.headEulerAngleZ ?? 0,
      face.smilingProbability ?? 0,
      face.leftEyeOpenProbability ?? 0,
      face.rightEyeOpenProbability ?? 0,
    ];
    return FaceEmbeddingModel(features);
  }

  @override
  void onClose() async {
    await stopCamera();
    await faceDetector.close();
    super.onClose();
  }
}
