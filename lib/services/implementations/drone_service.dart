import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:forest_garbage_mapper/DTO/responses/drone_response.dart';
import 'package:forest_garbage_mapper/models/drone.dart';
import 'package:forest_garbage_mapper/services/interfaces/i_drone_service.dart';

class DroneService extends ChangeNotifier implements IDroneService {
  @override
  Drone getDroneObject(DroneResponse response) {
    return Drone(idDrone: response.idDrone, name: response.name, sessionsCount: response.sessionsCount, distanceTraveled: response.distanceTraveled);
  }

  @override
  DroneResponse getDroneResponse(Map<String, dynamic> response) {
    return DroneResponse(idDrone: response['id_drone'], name: response['name'], sessionsCount: response['sessions_count'], distanceTraveled: response['distance_traveled']);
  }

  @override
  Future<List<Drone>> getDrones() async {
    List<DocumentSnapshot<Map<String, dynamic>>> dronesSnaps = (await FirebaseFirestore.instance.collection('/Drone').get()).docs;
    List<Drone> drones = [];

    for (DocumentSnapshot<Map<String, dynamic>> droneSnap in dronesSnaps) {
      DroneResponse response = getDroneResponse(droneSnap.data()!);
      Drone drone = getDroneObject(response);
      drones.add(drone);
    }

    return drones;
  }

}