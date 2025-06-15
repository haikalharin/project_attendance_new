import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:project_attendance_new/utils/loading_app.dart';
import '../controllers/map_screen_controller.dart';

class MapScreen extends GetView<MapsController> {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return WillPopScope(
        onWillPop: () async {
          Get.delete<MapsController>();
          return true;
        },
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Current Position'),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Get.delete<MapsController>();
                Get.back();
              },
            ),
          ),
          body: LoadingApp(
            isLoading: controller.isLoading.value,
            child: Column(
              children: [
                Expanded(
                  child: FlutterMap(
                    mapController: controller.mapController,
                    options: MapOptions(
                      initialCenter: controller.currentPosition.value ??
                          const LatLng(50.5, 30.51),
                      initialZoom: controller.currentPosition.value == null ? 3.0 : 16.0,
                      maxZoom: 19.0,
                      minZoom: 10.0,
                      onPositionChanged: (position, hasGesture) {
                        if (hasGesture && position.center != null) {
                          controller.mapController
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
                            point: LatLng(-6.266903733076428, 106.9781681733102),
                            child: const Icon(Icons.circle, color: Colors.red),
                          ),
                          Marker(
                            point: LatLng(-6.266936794841454, 106.97816025413766),
                            child: const Icon(Icons.circle, color: Colors.green),
                          ),
                          Marker(
                            point: LatLng(-6.267024959537934, 106.97851820073629),
                            child: const Icon(Icons.circle, color: Colors.blue),
                          ),
                          Marker(
                            point: LatLng(-6.267226478788224, 106.97842792216937),
                            child: const Icon(Icons.circle, color: Colors.orange),
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
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'My Location (Inside Attendance Zone)',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            controller.isNearLocation.value ? 'Normal' : 'Out of Zone',
                            style: TextStyle(
                              color: controller.isNearLocation.value ? Colors.green : Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        controller.addressModel.value?.displayName ?? 'Loading address...',
                        style: const TextStyle(color: Colors.grey),
                      ),
                      const SizedBox(height: 8),
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
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: ElevatedButton(
                    onPressed:
                    // controller.isNearLocation.value
                    //     ?
                        () => controller.checkIn(context)
                        // : null
                    ,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: controller.isNearLocation.value
                          ? Colors.blue
                          : Colors.grey,
                      minimumSize: const Size(double.infinity, 48),
                    ),
                    child: const Text('Check In'),
                  ),
                ),
              ],
            ),
          ),
          floatingActionButton: Padding(
            padding: const EdgeInsets.only(bottom: 80.0),
            child: Obx(() {
              return FloatingActionButton(
                heroTag: 'floating2',
                onPressed:
                controller.isLoading.value
                    ? null
                    :
                    () async {
                  controller.isLoading.value = true;
                  await controller.getCurrentLocation();
                  controller.isLoading.value = false;
                },
                backgroundColor: controller.isLoading.value ? Colors.grey : Colors.blue,
                child: const Icon(Icons.my_location),
              );
            }),
          ),
        ),
      );
    });
  }
}
