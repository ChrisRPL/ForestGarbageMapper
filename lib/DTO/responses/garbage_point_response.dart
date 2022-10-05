import 'package:cloud_firestore/cloud_firestore.dart';

class GarbagePointResponse {
  final String idGarbagePoint;
  final String idDrone;
  final GeoPoint coords;
  final String imageUrl;
  final Timestamp time;

  GarbagePointResponse(
      {required this.idGarbagePoint,
        required this.idDrone,
        required this.coords,
        required this.imageUrl,
        required this.time});
}