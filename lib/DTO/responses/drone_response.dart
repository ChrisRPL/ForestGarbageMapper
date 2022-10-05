class DroneResponse {
  final String idDrone;
  final String name;
  final int sessionsCount;
  final int distanceTraveled;

  DroneResponse(
      {required this.idDrone,
        required this.name,
        required this.sessionsCount,
        required this.distanceTraveled});
}