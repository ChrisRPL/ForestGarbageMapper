import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:forest_garbage_mapper/models/drone.dart';
import 'package:forest_garbage_mapper/services/implementations/drone_service.dart';
import 'package:forest_garbage_mapper/services/implementations/garbage_point_service.dart';
import 'package:provider/provider.dart';

class StatsPanel extends StatefulWidget {
  final bool isWideScreen;

  const StatsPanel({Key? key, required this.isWideScreen}) : super(key: key);

  @override
  State<StatsPanel> createState() => _StatsPanelState();
}

class _StatsPanelState extends State<StatsPanel> {
  @override
  Widget build(BuildContext context) {
    final droneService = Provider.of<DroneService>(context, listen: false);
    final garbagePointsService =
        Provider.of<GarbagePointService>(context, listen: false);

    return widget.isWideScreen
        ? FutureBuilder<Map<String, dynamic>>(
            future: _getDronesAndGarbage(garbagePointsService, droneService),
            builder: (ctx, garbageAndDrones) => garbageAndDrones.hasData
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [...getStatsCards(garbageAndDrones)],
                  )
                : const CircularProgressIndicator(),
          )
        : FutureBuilder<Map<String, dynamic>>(
            future: _getDronesAndGarbage(garbagePointsService, droneService),
            builder: (ctx, garbageAndDrones) => garbageAndDrones.hasData
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [...getStatsCards(garbageAndDrones)],
                  )
                : const CircularProgressIndicator(),
          );
  }

  Future<Map<String, dynamic>> _getDronesAndGarbage(
      GarbagePointService garbagePointService,
      DroneService droneService) async {
    List<Drone> drones = await droneService.getDrones();
    int pointsCount = (await FirebaseFirestore.instance.collection("/GarbagePoint").get()).docs.length;

    Map<String, dynamic> dronesAndGarbage = {
      "drones": drones,
      "garbage_points": pointsCount
    };

    return dronesAndGarbage;
  }

  List<Widget> getStatsCards(AsyncSnapshot<Map<String, dynamic>> garbageAndDrones) {
    int sessions = (garbageAndDrones.data!['drones'] as List<Drone>).map((e) => e.sessionsCount).reduce((value, element) => value + element);
    int garbageCount = (garbageAndDrones.data!['garbage_points'] as int);
    int distance = (garbageAndDrones.data!['drones'] as List<Drone>).map((e) => e.distanceTraveled).reduce((value, element) => value + element);

    return MediaQuery.of(context).size.width > 800 ? [
      Card(
        shape: const StadiumBorder(
          side: BorderSide(
            color: Colors.lightGreen,
            width: 1.0,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                  "Drones active: ${garbageAndDrones.data!['drones']!.length.toString()}")
            ],
          ),
        ),
      ),
      Card(
        shape: const StadiumBorder(
          side: BorderSide(
            color: Colors.lightGreen,
            width: 1.0,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                  "Sessions made: $sessions")
            ],
          ),
        ),
      ),
      Card(
        shape: const StadiumBorder(
          side: BorderSide(
            color: Colors.lightGreen,
            width: 1.0,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                  "Garbage located: $garbageCount")
            ],
          ),
        ),
      ),
      Card(
        shape: const StadiumBorder(
          side: BorderSide(
            color: Colors.lightGreen,
            width: 1.0,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                  "Overall distance: $distance")
            ],
          ),
        ),
      ),
    ] : [
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Card(
            shape: const StadiumBorder(
              side: BorderSide(
                color: Colors.lightGreen,
                width: 1.0,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                      "Drones active: ${garbageAndDrones.data!['drones']!.length.toString()}")
                ],
              ),
            ),
          ),
          Card(
            shape: const StadiumBorder(
              side: BorderSide(
                color: Colors.lightGreen,
                width: 1.0,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                      "Sessions made: $sessions")
                ],
              ),
            ),
          ),
        ],
      ),
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Card(
            shape: const StadiumBorder(
              side: BorderSide(
                color: Colors.lightGreen,
                width: 1.0,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                      "Overall distance: $distance")
                ],
              ),
            ),
          ),
          Card(
            shape: const StadiumBorder(
              side: BorderSide(
                color: Colors.lightGreen,
                width: 1.0,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                      "Garbage located: $garbageCount")
                ],
              ),
            ),
          ),
        ],
      ),
    ];
  }
}
