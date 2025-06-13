import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:formz/formz.dart';
import 'package:project_attendance_new/module/map_screen_page/bindings/map_screen_binding.dart';
import 'package:project_attendance_new/utils/loading_app.dart';
import '../controllers/map_screen_controller.dart';

class MapScreen extends GetView<MapsController> {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // final mapCtrl = MapController();
    // controller.mapController.value = mapCtrl;

    return Obx(() {
      // if (controller.submitStatus.value.isSuccess) {
      //   WidgetsBinding.instance.addPostFrameCallback((_) {
      //     ScaffoldMessenger.of(context).showSnackBar(
      //       SnackBar(
      //           content:
      //               Text(controller.addressModel.value?.displayName ?? '')),
      //     );
      //   });
      // }

      return WillPopScope(
        onWillPop: () async {
          // Hentikan live location jika perlu
          controller.positionStream?.cancel();
          Get.delete<MapController>();
          return true; // true = izinkan back, false = cegah back
        },
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Current Position'),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () async {
                // Sama seperti onWillPop
                controller.positionStream?.cancel();
                Get.delete<MapController>();
                Get.back(); // atau Navigator.pop(context);
              },
            ),
          ),
          body: LoadingApp(
            isLoading: controller.isLoading.value,
            child: Column(
              children: [
                Expanded(
                  child: FlutterMap(
                    mapController: controller.mapController.value,
                    options: MapOptions(
                      initialCenter: controller.currentPosition.value ??
                          const LatLng(50.5, 30.51),
                      initialZoom: 16.0,
                      maxZoom: 19.0,
                      minZoom: 10.0,
                      onPositionChanged:
                          (MapPosition position, bool hasGesture) {
                        if (hasGesture && position.center != null) {
                          controller.mapController.value
                              .move(position.center!, 16.0);
                        }
                      },
                    ),
                    children: [
                      TileLayer(
                        urlTemplate:
                            'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                        subdomains: const ['a', 'b', 'c'],
                      ),
                      MarkerLayer(
                        markers: [
                          Marker(
                            point:
                                LatLng(-6.266903733076428, 106.9781681733102),
                            child: const Icon(Icons.circle, color: Colors.red),
                          ),
                          Marker(
                            point:
                                LatLng(-6.266936794841454, 106.97816025413766),
                            child:
                                const Icon(Icons.circle, color: Colors.green),
                          ),
                          Marker(
                            point:
                                LatLng(-6.267024959537934, 106.97851820073629),
                            child: const Icon(Icons.circle, color: Colors.blue),
                          ),
                          Marker(
                            point:
                                LatLng(-6.267226478788224, 106.97842792216937),
                            child:
                                const Icon(Icons.circle, color: Colors.orange),
                          ),
                          Marker(
                            point: controller.companyTarget,
                            width: 80,
                            height: 80,
                            child: const Icon(Icons.location_city,
                                color: Colors.blue, size: 40),
                          ),
                          Marker(
                            point: controller.currentPosition.value ??
                                const LatLng(50.5, 30.51),
                            width: 80,
                            height: 80,
                            child: const Icon(Icons.person_pin_circle,
                                color: Colors.red, size: 40),
                          ),
                        ],
                      ),
                      if (controller.isNearLocationBefore.value)
                        PolygonLayer(
                          polygons: [
                            Polygon(
                              points: controller.polygonPoints,
                              color: Colors.blue.withOpacity(0.3),
                              isFilled: true,
                              borderColor: Colors.blue,
                              borderStrokeWidth: 2,
                            ),
                          ],
                        ),

                      // CircleLayer(
                      //   circles: [
                      //     CircleMarker(
                      //       point: controller.companyTarget,
                      //       color: Colors.blue.withOpacity(0.2),
                      //       borderStrokeWidth: 2.0,
                      //       borderColor: Colors.blue,
                      //       radius: controller.getRadiusForProximity(),
                      //     ),
                      //   ],
                      // ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('My Location (Inside Attendance Zone)',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          Text(controller.isNearLocation.value
                              ? 'Normal'
                              : 'Out of Zone'),
                        ],
                      ),
                      Obx(() => Text(
                          controller.addressModel.value?.displayName ?? '',
                          style: TextStyle(color: Colors.grey))),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Remarks: Optional'),
                          Text('${controller.checkInTime.value} Normal'),
                        ],
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    controller.isNearLocation.value
                        ? controller.checkIn(context)
                        : null;
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: controller.isNearLocation.value
                        ? Colors.blue
                        : Colors.grey,
                    minimumSize: const Size(double.infinity, 40),
                  ),
                  child: const Text('Check In'),
                ),
              ],
            ),
          ),
          floatingActionButton: Padding(
            padding: const EdgeInsets.only(bottom: 80.0),
            // atur sesuai kebutuhan
            child: FloatingActionButton(
              heroTag: 'floating2',
              child: const Icon(Icons.my_location),
              onPressed: controller.getCurrentLocation,
            ),
          ),
        ),
      );
    });
  }
}
