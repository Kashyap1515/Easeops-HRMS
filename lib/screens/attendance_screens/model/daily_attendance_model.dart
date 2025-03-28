// To parse this JSON data, do
//
//     final attendanceDailyModel = attendanceDailyModelFromJson(jsonString);

import 'dart:convert';

List<AttendanceDailyModel> attendanceDailyModelFromJson(String str) =>
    List<AttendanceDailyModel>.from(
        json.decode(str).map((x) => AttendanceDailyModel.fromJson(x)));

String attendanceDailyModelToJson(List<AttendanceDailyModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class AttendanceDailyModel {
  String? checkinDate;
  String? checkinTime;
  String? checkoutDate;
  String? checkoutTime;
  Shift? shift;

  AttendanceDailyModel({
    this.checkinDate,
    this.checkinTime,
    this.checkoutDate,
    this.checkoutTime,
    this.shift,
  });

  factory AttendanceDailyModel.fromJson(Map<String, dynamic> json) =>
      AttendanceDailyModel(
        checkinDate: json["checkin_date"],
        checkinTime: json["checkin_time"],
        checkoutDate: json["checkout_date"],
        checkoutTime: json["checkout_time"],
        shift: json["shift"] == null ? null : Shift.fromJson(json["shift"]),
      );

  Map<String, dynamic> toJson() => {
        "checkin_date": checkinDate,
        "checkin_time": checkinTime,
        "checkout_date": checkoutDate,
        "checkout_time": checkoutTime,
        "shift": shift?.toJson(),
      };
}

class Shift {
  String? id;
  String? name;
  String? startTime;
  String? endTime;

  Shift({
    this.id,
    this.name,
    this.startTime,
    this.endTime,
  });

  factory Shift.fromJson(Map<String, dynamic> json) => Shift(
        id: json["id"],
        name: json["name"],
        startTime: json["start_time"],
        endTime: json["end_time"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "start_time": startTime,
        "end_time": endTime,
      };
}
