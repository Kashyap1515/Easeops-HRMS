// To parse this JSON data, do
//
//     final checklistWithLocationModel = checklistWithLocationModelFromJson(jsonString);

import 'dart:convert';

List<ChecklistWithLocationModel> checklistWithLocationModelFromJson(
  String str,
) =>
    List<ChecklistWithLocationModel>.from(
      json.decode(str).map((x) => ChecklistWithLocationModel.fromJson(x)),
    );

String checklistWithLocationModelToJson(
  List<ChecklistWithLocationModel> data,
) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ChecklistWithLocationModel {
  String? id;
  String? name;
  String? locationId;
  Department? department;

  ChecklistWithLocationModel({
    this.id,
    this.name,
    this.locationId,
    this.department,
  });

  factory ChecklistWithLocationModel.fromJson(Map<String, dynamic> json) =>
      ChecklistWithLocationModel(
        id: json['id'],
        name: json['name'],
        locationId: json['location_id'],
        department: json["department"] != null
            ? Department.fromJson(json["department"])
            : null,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'location_id': locationId,
        "department": department?.toJson(),
      };
}

class Department {
  String id;
  String name;

  Department({
    required this.id,
    required this.name,
  });

  factory Department.fromJson(Map<String, dynamic> json) => Department(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}
