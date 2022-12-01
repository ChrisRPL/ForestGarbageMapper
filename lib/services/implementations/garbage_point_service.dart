import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:forest_garbage_mapper/DTO/responses/drone_response.dart';
import 'package:forest_garbage_mapper/DTO/responses/garbage_point_response.dart';
import 'package:forest_garbage_mapper/models/drone.dart';
import 'package:forest_garbage_mapper/models/garbage_point.dart';
import 'package:forest_garbage_mapper/services/implementations/drone_service.dart';
import 'package:forest_garbage_mapper/services/interfaces/i_garbage_point_service.dart';
import 'package:geocode/geocode.dart';
import 'package:image_network/image_network.dart';
import 'package:intl/intl.dart';
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
  List<Marker> createMapMarkersFromPoints(List<GarbagePoint> points) {
    ScrollController controller = ScrollController();
    final DateFormat format = DateFormat('yyyy-MM-dd – kk:mm');
    List<Marker> markers = [];

    for (GarbagePoint point in points) {
      markers.add(Marker(
          point: LatLng(point.coords.latitude, point.coords.longitude),
          builder: (BuildContext context) => InkWell(
                child: FaIcon(FontAwesomeIcons.solidCircle, size: 15, color: Colors.redAccent.withOpacity(0.6)),
                onTap: () => showModalBottomSheet(
                    context: context,
                    builder: (ctx) => SingleChildScrollView(
                          controller: controller,
                          scrollDirection: Axis.horizontal,
                          child: Wrap(
                            children: [
                              SizedBox(
                                height: 300,
                                child: Card(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Card(
                                        elevation: 10,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(5.0),
                                          side: const BorderSide(
                                            color: Colors.lightGreen,
                                            width: 1.0,
                                          ),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(15),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              FutureBuilder<String>(
                                                future:
                                                    getAddressFromCoordinates(
                                                        point.coords.latitude,
                                                        point.coords.longitude),
                                                builder: (ctx, address) => address
                                                        .hasData
                                                    ? Column(
                                                        children: [
                                                          const Text(
                                                            "City:",
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                          const SizedBox(
                                                            height: 15,
                                                          ),
                                                          Text(
                                                            address.data!,
                                                            style:
                                                                const TextStyle(
                                                                    fontSize:
                                                                        15),
                                                          )
                                                        ],
                                                      )
                                                    : const CircularProgressIndicator(),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 300,
                                        child: Card(
                                          elevation: 10,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(5.0),
                                            side: const BorderSide(
                                              color: Colors.lightGreen,
                                              width: 1.0,
                                            ),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(15),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                const Text(
                                                  "Date captured:",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                const SizedBox(
                                                  height: 15,
                                                ),
                                                Text(
                                                  format.format(point.time),
                                                  style: const TextStyle(
                                                      fontSize: 15),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 300,
                                        child: Card(
                                          elevation: 10,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(5.0),
                                            side: const BorderSide(
                                              color: Colors.lightGreen,
                                              width: 1.0,
                                            ),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(15),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                const Text(
                                                  "Assigned drone:",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                const SizedBox(
                                                  height: 15,
                                                ),
                                                Text(
                                                  "Name: ${point.idDroneObject.name}",
                                                  style: const TextStyle(
                                                      fontSize: 15),
                                                ),
                                                Text(
                                                  "Sessions count: ${point.idDroneObject.sessionsCount}",
                                                  style: const TextStyle(
                                                      fontSize: 15),
                                                ),
                                                Text(
                                                  "Distance traveled: ${point.idDroneObject.distanceTraveled}",
                                                  style: const TextStyle(
                                                      fontSize: 15),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 300,
                                        child: Card(
                                          elevation: 10,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(5.0),
                                            side: const BorderSide(
                                              color: Colors.lightGreen,
                                              width: 1.0,
                                            ),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(15),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                const Text(
                                                  "Coordinates:",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                const SizedBox(
                                                  height: 15,
                                                ),
                                                Text(
                                                  "N [${point.coords.latitude}]",
                                                  style: const TextStyle(
                                                      fontSize: 15),
                                                ),
                                                Text(
                                                  "E [${point.coords.longitude}]",
                                                  style: const TextStyle(
                                                      fontSize: 15),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 300,
                                        child: Card(
                                          elevation: 10,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(5.0),
                                            side: const BorderSide(
                                              color: Colors.lightGreen,
                                              width: 1.0,
                                            ),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(15),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                const Text(
                                                  "Garbage image:",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                const SizedBox(
                                                  height: 15,
                                                ),
                                                ImageNetwork(
                                                  image: point.imageUrl,
                                                  height: 200,
                                                  width: 200,
                                                  fitWeb: BoxFitWeb.cover,
                                                  fitAndroidIos: BoxFit.cover,
                                                  curve: Curves.easeIn,
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )),
              )));
    }

    return markers;
  }

  @override
  Future<String> getAddressFromCoordinates(
      double latitude, double longitude) async {
    GeoCode geoCode = GeoCode();
    Address address = await geoCode.reverseGeocoding(
        latitude: latitude, longitude: longitude);

    return address.city!;
  }
}
