// To parse this JSON data, do
//
//     final getLocationModel = getLocationModelFromJson(jsonString);

import 'dart:convert';

List<GetLocationModel> getLocationModelFromJson(String str) =>
    List<GetLocationModel>.from(
      json.decode(str).map((x) => GetLocationModel.fromJson(x)),
    );

String getLocationModelToJson(List<GetLocationModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class GetLocationModel {
  GetLocationModel({
    this.id,
    this.name,
    this.location,
    this.timeZone,
    this.lat,
    this.lon,
    this.reviewUrl,
    this.isCorporate,
    this.brand,
    this.locationType,
    this.market,
  });

  factory GetLocationModel.fromJson(Map<String, dynamic> json) =>
      GetLocationModel(
        id: json['id'],
        name: json['name'],
        location: json['location'],
        timeZone: json['time_zone'],
        lat: json['lat']?.toDouble(),
        lon: json['lon']?.toDouble(),
        isCorporate: json['is_corporate'],
        reviewUrl: json["review_url"],
        brand: json['brand'],
        locationType: json['location_type'],
        market: json['market'],
      );
  String? id;
  String? name;
  String? location;
  dynamic timeZone;
  double? lat;
  String? reviewUrl;
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
        "review_url": reviewUrl,
        'location_type': locationType,
        'market': market,
      };
}
