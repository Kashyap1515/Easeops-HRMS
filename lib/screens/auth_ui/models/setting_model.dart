// To parse this JSON data, do
//
//     final settingsDataModel = settingsDataModelFromJson(jsonString);

import 'dart:convert';

List<SettingsDataModel> settingsDataModelFromJson(String str) =>
    List<SettingsDataModel>.from(
      json.decode(str).map((x) => SettingsDataModel.fromJson(x)),
    );

String settingsDataModelToJson(List<SettingsDataModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class SettingsDataModel {
  String? privilege;
  List<String>? abilities;

  SettingsDataModel({
    this.privilege,
    this.abilities,
  });

  factory SettingsDataModel.fromJson(Map<String, dynamic> json) =>
      SettingsDataModel(
        privilege: json['privilege'],
        abilities: json['abilities'] == null
            ? []
            : List<String>.from(json['abilities']!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        'privilege': privilege,
        'abilities': abilities == null
            ? []
            : List<dynamic>.from(abilities!.map((x) => x)),
      };
}
