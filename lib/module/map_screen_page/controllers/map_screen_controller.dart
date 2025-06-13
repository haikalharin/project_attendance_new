import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:formz/formz.dart';
import 'package:project_attendance_new/repository/maps_repository.dart';
import 'package:project_attendance_new/services/maps_service/maps_services.dart';
import 'package:flutter_map/flutter_map.dart';
import '../../../routes/app_routes.dart';
import '../../employee_page/model/employee_model_new.dart';
import '../../face_recog_screen_page/model/face_embedding_model.dart';
import '../../face_recog_screen_page/model/result_model.dart';
import '../model/address_model.dart';

class MapsController extends GetxController {
  final MapsServices mapsServices;
  MapsController({required this.mapsServices});

  late final MapController mapController;
  final currentPosition = Rxn<LatLng>();
  final addressModel = Rxn<AddressModel>();
  final checkInTime = RxString('');
  final submitStatus = Rx<FormzSubmissionStatus>(FormzSubmissionStatus.initial);
  final distanceToTarget = RxDouble(0.0);
  final companyTarget = LatLng(-6.195996254116501, 106.97873532434217);
  final isNearLocation = RxBool(false);
  final isNearLocationBefore = RxBool(false);
  final zoomLevel = 16.0;
  final isLoading = false.obs;

  StreamSubscription<Position>? positionStream;
  bool isControllerDisposed = false;

  final polygonPoints = [
    LatLng(-6.196061008120713, 106.97853340741206),
    LatLng(-6.195348713637337, 106.97863110915242),
    LatLng(-6.195458795574853, 106.97910007750623),
    LatLng(-6.196138712915294, 106.97901540266457),
  ];

  @override
  void onInit() {
    super.onInit();
    mapController = MapController();
    startLiveLocation();
  }

  void startLiveLocation() async {
    try {
      if (!await Geolocator.isLocationServiceEnabled()) {
        throw 'Location services are disabled.';
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied ||
            permission == LocationPermission.deniedForever) {
          throw 'Location permissions are denied.';
        }
      }

      final initialPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      final latLng = LatLng(initialPosition.latitude, initialPosition.longitude);
      currentPosition.value = latLng;

      _safeMoveMap(latLng, zoomLevel);

      final distance = _getDistance(latLng, companyTarget);
      distanceToTarget.value = distance;

      final isInside = isPointInPolygon(latLng, polygonPoints);
      isNearLocation.value = isInside;
      isNearLocationBefore.value = distance <= 1000;
    } catch (e) {
      print(e);
      Get.snackbar('Error', 'Gagal mendapatkan lokasi awal: $e');
    }

    positionStream = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 1,
      ),
    ).listen((Position position) {
      final latLng = LatLng(position.latitude, position.longitude);
      currentPosition.value = latLng;

      _safeMoveMap(latLng, zoomLevel);

      final distance = _getDistance(latLng, companyTarget);
      distanceToTarget.value = distance;

      final isInside = isPointInPolygon(latLng, polygonPoints);
      isNearLocation.value = isInside;
      isNearLocationBefore.value = distance <= 1000;
    });
  }

  void _safeMoveMap(LatLng latLng, double zoom) {
    if (!isControllerDisposed) {
      try {
        mapController.move(latLng, zoom);
      } catch (e) {
        debugPrint("MapController move failed: $e");
      }
    }
  }

  Future<void> getCurrentLocation() async {
    try {
      if (!await Geolocator.isLocationServiceEnabled()) {
        throw 'Location services are disabled.';
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied ||
            permission == LocationPermission.deniedForever) {
          throw 'Location permissions are denied.';
        }
      }

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      final latLng = LatLng(position.latitude, position.longitude);
      currentPosition.value = latLng;

      _safeMoveMap(latLng, 16.0);

      final distance = _getDistance(latLng, companyTarget);
      distanceToTarget.value = distance;

      final isInside = isPointInPolygon(latLng, polygonPoints);
      isNearLocation.value = isInside;
      isNearLocationBefore.value = distance <= 1000;
    } catch (e) {
      Get.snackbar('Error', '$e');
    }
  }

  bool isPointInPolygon(LatLng point, List<LatLng> polygon) {
    int i, j = polygon.length - 1;
    bool result = false;

    for (i = 0; i < polygon.length; i++) {
      if ((polygon[i].latitude > point.latitude) !=
          (polygon[j].latitude > point.latitude) &&
          (point.longitude <
              (polygon[j].longitude - polygon[i].longitude) *
                  (point.latitude - polygon[i].latitude) /
                  (polygon[j].latitude - polygon[i].latitude) +
                  polygon[i].longitude)) {
        result = !result;
      }
      j = i;
    }

    return result;
  }

  Future<void> checkIn(BuildContext context) async {
    if (currentPosition.value == null) return;
    submitStatus.value = FormzSubmissionStatus.inProgress;

    final lat = currentPosition.value!.latitude;
    final long = currentPosition.value!.longitude;
    isLoading.value = true;
    final response = await mapsServices.getAddress(lat: lat, long: long);

    if (response.isSuccess) {
      isLoading.value = false;
      AddressModel addressModelData = AddressModel.fromJson(response.data);
      addressModel.value = addressModelData;
      checkInTime.value = DateFormat('HH:mm:ss').format(DateTime.now());
      submitStatus.value = FormzSubmissionStatus.success;

      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(addressModel.value?.displayName ?? '')),
        );
      });
    } else {
      isLoading.value = false;
      submitStatus.value = FormzSubmissionStatus.failure;
    }
  }

  double _getDistance(LatLng start, LatLng end) {
    final Distance distance = Distance();
    return distance.as(LengthUnit.Meter, start, end);
  }

  double getRadiusForProximity() {
    return distanceToTarget.value.clamp(100, 100);
  }

  @override
  void onClose() {
    isControllerDisposed = true;
    positionStream?.cancel();
    super.onClose();
  }
}
