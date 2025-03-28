// To parse this JSON data, do
//
//     final getUserModel = getUserModelFromJson(jsonString);

import 'dart:convert';

List<GetUserModel> getUserModelFromJson(String str) => List<GetUserModel>.from(
      json.decode(str).map((x) => GetUserModel.fromJson(x)),
    );

String getUserModelToJson(List<GetUserModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class GetUserModel {
  GetUserModel({
    this.id,
    this.name,
    this.department,
    this.email,
    this.phoneNo,
    this.isVerified,
    this.roles,
    this.locations,
    this.assessments,
    this.checklists,
  });

  factory GetUserModel.fromJson(Map<String, dynamic> json) => GetUserModel(
        id: json['id'],
        name: json['name'],
        department: json['department_name'],
        email: json['email'],
        phoneNo: json['phone_number'],
        isVerified: json['is_verified'],
        roles: json['roles'] == null
            ? []
            : List<Role>.from(json['roles']!.map((x) => Role.fromJson(x))),
        locations: json['locations'] == null
            ? []
            : List<Location>.from(
                json['locations']!.map((x) => Location.fromJson(x)),
              ),
        checklists: json['checklists'] == null
            ? []
            : List<UserCheckList>.from(
                json['checklists']!.map((x) => UserCheckList.fromJson(x)),
              ),
        assessments: json['assessments'] == null
            ? []
            : List<Assessment>.from(
                json['assessments']!.map((x) => Assessment.fromJson(x)),
              ),
      );
  String? id;
  String? name;
  String? email;
  String? department;
  String? phoneNo;
  bool? isVerified;
  List<Role>? roles;
  List<Location>? locations;
  List<UserCheckList>? checklists;
  List<Assessment>? assessments;

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'department_name': department,
        'email': email,
        'is_verified': isVerified,
        'phone_number': phoneNo,
        'roles': roles == null
            ? []
            : List<dynamic>.from(roles!.map((x) => x.toJson())),
        'locations': locations == null
            ? []
            : List<dynamic>.from(locations!.map((x) => x.toJson())),
        'checklists': checklists == null
            ? []
            : List<dynamic>.from(checklists!.map((x) => x.toJson())),
        'assessments': assessments == null
            ? []
            : List<dynamic>.from(assessments!.map((x) => x.toJson())),
      };
}

class Assessment {
  Assessment({
    this.id,
    this.name,
    this.popupData,
    this.isAssess,
  });

  factory Assessment.fromJson(Map<String, dynamic> json) => Assessment(
        id: json['id'],
        name: json['name'],
        popupData: json['name'],
        isAssess: json['is_assess'],
      );
  String? id;
  String? name;
  String? popupData;
  bool? isAssess;

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'is_assess': isAssess,
      };
}

class UserCheckList {
  UserCheckList({
    this.id,
    this.name,
    this.popupData,
  });

  factory UserCheckList.fromJson(Map<String, dynamic> json) => UserCheckList(
        id: json['id'],
        name: json['name'],
        popupData: json['name'],
      );
  String? id;
  String? name;
  String? popupData;

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
      };
}

class Location {
  Location({
    this.id,
    this.alias,
    this.location,
    this.popupData,
  });

  factory Location.fromJson(Map<String, dynamic> json) => Location(
        id: json['id'],
        alias: json['alias'],
        location: json['location'],
        popupData: json['location'],
      );
  String? id;
  String? alias;
  String? popupData;
  String? location;

  Map<String, dynamic> toJson() => {
        'id': id,
        'alias': alias,
        'location': location,
      };
}

class Role {
  Role({
    this.id,
    this.name,
    this.popupData,
  });

  factory Role.fromJson(Map<String, dynamic> json) => Role(
        id: json['id'],
        name: json['name'],
        popupData: json['name'],
      );
  String? id;
  String? name;
  String? popupData;

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
      };
}

class AssignedUser {
  String? id;
  String? popupData;

  AssignedUser({
    this.id,
    this.popupData,
  });

  factory AssignedUser.fromJson(Map<String, dynamic> json) => AssignedUser(
    id: json["id"],
    popupData: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": popupData,
  };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          (other is AssignedUser &&
              runtimeType == other.runtimeType &&
              id == other.id);

  @override
  int get hashCode => id.hashCode;
}