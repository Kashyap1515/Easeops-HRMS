// To parse this JSON data, do
//
//     final getRoleModel = getRoleModelFromJson(jsonString);

import 'dart:convert';

List<GetRoleModel> getRoleModelFromJson(String str) => List<GetRoleModel>.from(
      json.decode(str).map((x) => GetRoleModel.fromJson(x)),
    );

String getRoleModelToJson(List<GetRoleModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class GetRoleModel {
  GetRoleModel({
    this.name,
    this.description,
    this.privilege,
    this.id,
  });

  factory GetRoleModel.fromJson(Map<String, dynamic> json) => GetRoleModel(
        name: json['name'],
        description: json['description'],
        privilege: json['privilege'],
        id: json['id'],
      );
  String? name;
  String? description;
  String? privilege;
  String? id;

  Map<String, dynamic> toJson() => {
        'name': name,
        'description': description,
        'privilege': privilege,
        'id': id,
      };
}
