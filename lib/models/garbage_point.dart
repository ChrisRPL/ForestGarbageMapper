import 'package:cloud_firestore/cloud_firestore.dart';

import 'drone.dart';

class GarbagePoint {
  final String idGarbagePoint;
  final Drone idDroneObject;
  final GeoPoint coords;
  final String imageUrl;
  final DateTime time;

  GarbagePoint(
      {required this.idGarbagePoint,
        required this.idDroneObject,
        required this.coords,
        required this.imageUrl,
        required this.time});
}