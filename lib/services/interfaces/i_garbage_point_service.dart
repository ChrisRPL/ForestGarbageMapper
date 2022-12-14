import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:forest_garbage_mapper/DTO/responses/garbage_point_response.dart';
import 'package:forest_garbage_mapper/models/garbage_point.dart';

import '../implementations/drone_service.dart';

abstract class IGarbagePointService extends ChangeNotifier {
  Future<List<GarbagePoint>> getGarbagePoints(DroneService service, List<DocumentSnapshot<Map<String, dynamic>>> pointsSnaps);
  GarbagePointResponse getGarbagePointResponse(Map<String, dynamic> response);
  Future<GarbagePoint> getGarbagePointObject(GarbagePointResponse response, DroneService service);
  List<Marker> createMapMarkersFromPoints(List<GarbagePoint> points);
  Future<String> getAddressFromCoordinates(double latitude, double longitude);
}