import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:forest_garbage_mapper/services/implementations/drone_service.dart';
import 'package:forest_garbage_mapper/services/implementations/garbage_point_service.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

import '../../../models/garbage_point.dart';

class MapPanel extends StatefulWidget {
  const MapPanel({Key? key}) : super(key: key);

  @override
  State<MapPanel> createState() => _MapPanelState();
}

class _MapPanelState extends State<MapPanel> {

  @override
  Widget build(BuildContext context) {
    final garbageService = Provider.of<GarbagePointService>(context, listen: false);
    final droneService = Provider.of<DroneService>(context, listen: false);

    return Flexible(
      child: Card(
        elevation: 15,
        child: FutureBuilder<Position>(
          future: _determinePosition(),
          builder: (ctx, locationSnap) => locationSnap.hasData ?  FlutterMap(options: MapOptions(
            center: LatLng(locationSnap.data!.latitude, locationSnap.data!.longitude),
            zoom: 15,
          ),
          children: [
            TileLayer(
              urlTemplate:
              'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'dev.fleaflet.flutter_map.example',
              retinaMode: MediaQuery.of(context).devicePixelRatio > 1.0,
            ),
            FutureBuilder<List<GarbagePoint>>(
              future: garbageService.getGarbagePoints(droneService),
              builder: (ctx, pointsSnap) => pointsSnap.hasData ?  MarkerLayer(
                markers: garbageService.createMapMarkersFromPoints(pointsSnap.data!),
              ) : Container(),
            )
          ],) : const CircularProgressIndicator(),
        ),
      ),
    );
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  }
}
