// To parse this JSON data, do
//
//     final shiftDataModel = shiftDataModelFromJson(jsonString);

import 'dart:convert';

List<ShiftDataModel> shiftDataModelFromJson(String str) =>
    List<ShiftDataModel>.from(
        json.decode(str).map((x) => ShiftDataModel.fromJson(x)));

String shiftDataModelToJson(List<ShiftDataModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ShiftDataModel {
  String? name;
  String? startTime;
  String? endTime;
  String? id;
  List<dynamic>? userList;

  ShiftDataModel({
    this.name,
    this.startTime,
    this.endTime,
    this.id,
    this.userList,
  });

  factory ShiftDataModel.fromJson(Map<String, dynamic> json) => ShiftDataModel(
        name: json["name"],
        startTime: json["start_time"],
        endTime: json["end_time"],
        id: json["id"],
        userList: List<dynamic>.from(json["user_list"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "start_time": startTime,
        "end_time": endTime,
        "id": id,
        "user_list": List<dynamic>.from(userList!.map((x) => x)),
      };
}
