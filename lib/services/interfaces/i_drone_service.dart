import 'package:flutter/material.dart';
import 'package:forest_garbage_mapper/DTO/responses/drone_response.dart';

import '../../models/drone.dart';

abstract class IDroneService extends ChangeNotifier {
  Future<List<Drone>> getDrones();
  DroneResponse getDroneResponse(Map<String, dynamic> response);
  Drone getDroneObject(DroneResponse response);
}