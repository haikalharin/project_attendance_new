import 'package:dio/dio.dart';
import 'package:get/get.dart';

import '../../../api_client/api_client.dart';
import '../../../repository/maps_repository.dart';
import '../../../services/maps_service/maps_services.dart';
import '../controllers/face_recog_controller.dart';
import '../controllers/face_recognation_controller.dart';


class FaceRecogBinding extends Bindings {
  @override
  void dependencies() {

    // Get.lazyPut(() => ApiClient(Dio()));
    // Get.lazyPut<MapsRepository>(() => MapsRepository(apiClient: Get.find()));
    // Get.lazyPut<MapsServices>(
    //         () => MapsServices(mapsRepository: Get.find()));

    Get.put<FaceRecognitionController>(FaceRecognitionController());
  }
}