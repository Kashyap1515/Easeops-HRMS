import 'package:easeops_web_hrms/app_export.dart';

class LocationGETConfigModel {
  // List<UsersDataLocationConfig>? usersList;

  LocationGETConfigModel({
    this.locId,
    this.brand,
    this.alias,
    this.location,
    this.latitude,
    this.longitude,
    this.type,
    this.market,
    this.isCorporate,
  });

  LocationGETConfigModel.fromJson(Map<String, dynamic> json) {
    locId = json['id'];
    brand = json['brand'];
    alias = json['name'];
    location = json['location'];
    latitude = json['lat'];
    longitude = json['lon'];
    type = json['location_type'];
    market = json['market'];
    isCorporate = json['is_corporate'];
  }

  String? locId;
  String? brand;
  String? alias;
  String? location;
  double? latitude;
  double? longitude;
  String? type;
  String? market;
  bool? isCorporate;
}

// To parse this JSON data, do
//
//     final locationListModel = locationListModelFromJson(jsonString);

List<LocationListModel> locationListModelFromJson(String str) =>
    List<LocationListModel>.from(
      json.decode(str).map((x) => LocationListModel.fromJson(x)),
    );

String locationListModelToJson(List<LocationListModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class LocationListModel {
  LocationListModel({
    this.id,
    this.name,
    this.location,
    this.timeZone,
    this.lat,
    this.lon,
    this.isCorporate,
    this.brand,
    this.locationType,
    this.market,
  });

  factory LocationListModel.fromJson(Map<String, dynamic> json) =>
      LocationListModel(
        id: json['id'],
        name: json['name'],
        location: json['location'],
        timeZone: json['time_zone'],
        lat: json['lat']?.toDouble(),
        lon: json['lon']?.toDouble(),
        isCorporate: json['is_corporate'],
        brand: json['brand'],
        locationType: json['location_type'],
        market: json['market'],
      );
  String? id;
  String? name;
  String? location;
  dynamic timeZone;
  double? lat;
  double? lon;
  bool? isCorporate;
  String? brand;
  String? locationType;
  String? market;

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'location': location,
        'time_zone': timeZone,
        'lat': lat,
        'lon': lon,
        'is_corporate': isCorporate,
        'brand': brand,
        'location_type': locationType,
        'market': market,
      };
}
