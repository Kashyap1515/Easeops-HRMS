// To parse this JSON data, do
//
//     final attendanceActiveDayModel = attendanceActiveDayModelFromJson(jsonString);

import 'dart:convert';

List<Map<String, dynamic>> attendanceActiveDayModelFromJson(dynamic json) {
  List<Map<String, dynamic>> decodedJson;

  if (json is List) {
    decodedJson = List<Map<String, dynamic>>.from(json);
  } else if (json is String) {
    try {
      decodedJson = List<Map<String, dynamic>>.from(jsonDecode(json));
    } catch (e) {
      throw const FormatException('Failed to parse JSON string');
    }
  } else {
    throw const FormatException('Unexpected JSON format');
  }

  return decodedJson;
}

String attendanceActiveDayModelToJson(List<DateTime> data) {
  return json.encode(
    data
        .map((x) =>
            "${x.year.toString().padLeft(4, '0')}-${x.month.toString().padLeft(2, '0')}-${x.day.toString().padLeft(2, '0')}")
        .toList(),
  );
}
