class LocationDataModel{
  int id;
  String title;
  LatLng location;
  int createdAt;

  LocationDataModel({
    this.id = 0,
    required this.title,
    required this.location,
    this.createdAt = 0
});

  factory LocationDataModel.fromJson(Map<String, dynamic> json) {
    return LocationDataModel(
      id: json['id'],
      title: json["title"],
      location: LatLng(latitude: json['lat'], longitude: json['lng']),
      createdAt: json["createdAt"],
    );
  }
}

class LatLng{
  double latitude;
  double longitude;
  LatLng({
    required this.latitude,
    required this.longitude
});
}