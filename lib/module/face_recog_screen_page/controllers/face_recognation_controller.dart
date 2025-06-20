import 'dart:async';
import 'dart:io';
import 'dart:ui' as ui;
import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_face_api/flutter_face_api.dart' as regula;
import 'package:get/get.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import '../model/face_embedding_model.dart';
import '../model/result_model.dart';
import '../view/face_painter_new.dart';

import 'dart:typed_data';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_face_core_basic/flutter_face_core.dart';

class FaceRecognitionController extends GetxController {
  final Rx<Uint8List?> referenceImageBytes = Rx<Uint8List?>(null);
  final RxDouble similarity = 0.0.obs;
  final RxBool isLoading = false.obs;
  var faceSdk = regula.FaceSDK.instance;

  @override
  void onInit() {
    super.onInit();
    initialize();
  }

  Future<bool> initialize() async {
    var license = await loadAssetIfExists("assets/regula.license");
    regula.InitConfig? config = null;
    if (license != null) config = regula.InitConfig(license);
    var (success, error) = await faceSdk.initialize(config: config);
    if (!success) {
      print("${error?.code}: ${error?.message}");
    }
    return success;
  }

  Future<ByteData?> loadAssetIfExists(String path) async {
    try {
      return await rootBundle.load(path);
    } catch (_) {
      return null;
    }
  }

  Future<void> pickReferenceImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.camera,preferredCameraDevice: CameraDevice.front);
    if (picked != null) {

      referenceImageBytes.value = await picked.readAsBytes();
    }
  }

  Future<void> startLiveCaptureAndCompare(BuildContext context) async {
    // var faceSdk = regula.FaceSDK.instance;

    final response = await faceSdk.startFaceCapture();
    if (response.image == null || referenceImageBytes.value == null) return;

    final refImage = regula.MatchFacesImage(
      referenceImageBytes.value!,
      regula.ImageType.PRINTED,
    );
    final liveImage = regula.MatchFacesImage(
      response.image!.image,
      regula.ImageType.LIVE,
    );

    final request = regula.MatchFacesRequest([refImage, liveImage]);

    isLoading.value = true;
    final matchResponse = await faceSdk.matchFaces(request);
    final splitResult = await faceSdk.splitComparedFaces(
      matchResponse.results,
      0.75,
    );
    isLoading.value = false;

    if (splitResult.matchedFaces.isNotEmpty) {
      final sim = splitResult.matchedFaces.first.similarity;
      similarity.value = sim;
      if (sim >= 0.75) {
        faceSdk.stopFaceCapture(); // optional untuk stop proses sebelum back
        WidgetsBinding.instance.addPostFrameCallback((_) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text("Wajah Cocok 🎉")));
        });
        // Get.defaultDialog(
        //   title: "Wajah Cocok 🎉",
        //   middleText: "Similarity ${(sim * 100).toStringAsFixed(2)}%",
        //   confirm: ElevatedButton(
        //     onPressed: () => Get.back(),
        //     child: const Text("OK"),
        //   ),
        // );
      }
    } else {
      similarity.value = 0.0;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Wajah Tidak Cocok",
              style: TextStyle(color: Colors.white),
            ),
          ),
        );
      });
    }
  }
}
