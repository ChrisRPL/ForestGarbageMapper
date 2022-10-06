import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map/src/layer/marker_layer.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:forest_garbage_mapper/DTO/responses/drone_response.dart';
import 'package:forest_garbage_mapper/DTO/responses/garbage_point_response.dart';
import 'package:forest_garbage_mapper/models/drone.dart';
import 'package:forest_garbage_mapper/models/garbage_point.dart';
import 'package:forest_garbage_mapper/services/implementations/drone_service.dart';
import 'package:forest_garbage_mapper/services/interfaces/i_garbage_point_service.dart';
import 'package:latlong2/latlong.dart';

class GarbagePointService extends ChangeNotifier
    implements IGarbagePointService {
  @override
  Future<GarbagePoint> getGarbagePointObject(
      GarbagePointResponse response, DroneService service) async {
    DocumentSnapshot<Map<String, dynamic>> droneSnap = await FirebaseFirestore
        .instance
        .collection("/Drone")
        .doc(response.idDrone)
        .get();
    DroneResponse droneResponse = service.getDroneResponse(droneSnap.data()!);
    Drone drone = service.getDroneObject(droneResponse);

    return GarbagePoint(
        idGarbagePoint: response.idGarbagePoint,
        idDroneObject: drone,
        coords: response.coords,
        imageUrl: response.imageUrl,
        time: response.time.toDate());
  }

  @override
  GarbagePointResponse getGarbagePointResponse(Map<String, dynamic> response) {
    return GarbagePointResponse(
        idGarbagePoint: response['id_garbage_point'],
        idDrone: response['id_drone'],
        coords: response['coords'],
        imageUrl: response['image_url'],
        time: response['time']);
  }

  @override
  Future<List<GarbagePoint>> getGarbagePoints(DroneService service) async {
    List<DocumentSnapshot<Map<String, dynamic>>> pointsSnaps =
        (await FirebaseFirestore.instance.collection("/GarbagePoint").get())
            .docs;
    List<GarbagePoint> garbagePoints = [];

    for (DocumentSnapshot<Map<String, dynamic>> pointSnap in pointsSnaps) {
      GarbagePointResponse response =
          getGarbagePointResponse(pointSnap.data()!);
      GarbagePoint garbagePoint =
          await getGarbagePointObject(response, service);
      garbagePoints.add(garbagePoint);
    }

    return garbagePoints;
  }

  @override
  List<CircleMarker> createMapMarkersFromPoints(List<GarbagePoint> points) {
    List<CircleMarker> markers = [];

    for (GarbagePoint point in points) {
      markers.add(CircleMarker(
          radius: 5,
          point: LatLng(point.coords.latitude, point.coords.longitude),
      color: Colors.red));
    }

    return markers;
  }
}
