// To parse this JSON data, do
//
//     final attendanceReportUserModel = attendanceReportUserModelFromJson(jsonString);

import 'dart:convert';

List<AttendanceReportUserModel> attendanceReportUserModelFromJson(String str) =>
    List<AttendanceReportUserModel>.from(
        json.decode(str).map((x) => AttendanceReportUserModel.fromJson(x)));

String attendanceReportUserModelToJson(List<AttendanceReportUserModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class AttendanceReportUserModel {
  User? user;
  List<AttendanceList>? attendanceList;

  AttendanceReportUserModel({
    this.user,
    this.attendanceList,
  });

  factory AttendanceReportUserModel.fromJson(Map<String, dynamic> json) =>
      AttendanceReportUserModel(
        user: json["user"] == null ? null : User.fromJson(json["user"]),
        attendanceList: json["attendance_list"] == null
            ? []
            : List<AttendanceList>.from(json["attendance_list"]!
                .map((x) => AttendanceList.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "user": user?.toJson(),
        "attendance_list": attendanceList == null
            ? []
            : List<dynamic>.from(attendanceList!.map((x) => x.toJson())),
      };
}

class AttendanceList {
  String? id;
  DateTime? markedAt;
  Location? location;
  int? totalTimeSpentInMinutes;
  List<SessionList>? sessionList;

  AttendanceList({
    this.id,
    this.markedAt,
    this.location,
    this.totalTimeSpentInMinutes,
    this.sessionList,
  });

  factory AttendanceList.fromJson(Map<String, dynamic> json) => AttendanceList(
        id: json["id"],
        markedAt: json["marked_at"] == null
            ? null
            : DateTime.parse(json["marked_at"]),
        location: json["location"] == null
            ? null
            : Location.fromJson(json["location"]),
        totalTimeSpentInMinutes: json["total_time_spent_in_minutes"],
        sessionList: json["session_list"] == null
            ? []
            : List<SessionList>.from(
                json["session_list"]!.map((x) => SessionList.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "marked_at": markedAt?.toIso8601String(),
        "location": location?.toJson(),
        "total_time_spent_in_minutes": totalTimeSpentInMinutes,
        "session_list": sessionList == null
            ? []
            : List<dynamic>.from(sessionList!.map((x) => x.toJson())),
      };
}

class Location {
  String? id;
  String? name;

  Location({
    this.id,
    this.name,
  });

  factory Location.fromJson(Map<String, dynamic> json) => Location(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}

class SessionList {
  String? id;
  DateTime? checkinAt;
  List<String>? checkinImages;
  List<String>? checkinCoordinates;
  DateTime? checkoutAt;
  List<String>? checkoutImages;
  List<String>? checkoutCoordinates;
  Shift? shift;

  SessionList({
    this.id,
    this.checkinAt,
    this.checkinImages,
    this.checkinCoordinates,
    this.checkoutAt,
    this.checkoutImages,
    this.checkoutCoordinates,
    this.shift,
  });

  factory SessionList.fromJson(Map<String, dynamic> json) => SessionList(
        id: json["id"],
        checkinAt: json["checkin_at"] == null
            ? null
            : DateTime.parse(json["checkin_at"]),
        checkinImages: json["checkin_images"] == null
            ? []
            : List<String>.from(json["checkin_images"]!.map((x) => x)),
        checkinCoordinates: json["checkin_coordinates"] == null
            ? []
            : List<String>.from(json["checkin_coordinates"]!.map((x) => x)),
        checkoutAt: json["checkout_at"] == null
            ? null
            : DateTime.parse(json["checkout_at"]),
        checkoutImages: json["checkout_images"] == null
            ? []
            : List<String>.from(json["checkout_images"]!.map((x) => x)),
        checkoutCoordinates: json["checkout_coordinates"] == null
            ? []
            : List<String>.from(json["checkout_coordinates"]!.map((x) => x)),
        shift: json["shift"] == null ? null : Shift.fromJson(json["shift"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "checkin_at": checkinAt?.toIso8601String(),
        "checkin_images": checkinImages == null
            ? []
            : List<dynamic>.from(checkinImages!.map((x) => x)),
        "checkin_coordinates": checkinCoordinates == null
            ? []
            : List<dynamic>.from(checkinCoordinates!.map((x) => x)),
        "checkout_at": checkoutAt?.toIso8601String(),
        "checkout_images": checkoutImages == null
            ? []
            : List<dynamic>.from(checkoutImages!.map((x) => x)),
        "checkout_coordinates": checkoutCoordinates == null
            ? []
            : List<dynamic>.from(checkoutCoordinates!.map((x) => x)),
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

class User {
  String? id;
  String? name;
  String? displayPicture;

  User({
    this.id,
    this.name,
    this.displayPicture,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        name: json["name"],
        displayPicture: json["display_picture"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "display_picture": displayPicture,
      };
}
