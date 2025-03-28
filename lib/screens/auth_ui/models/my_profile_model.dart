// To parse this JSON data, do
//
//     final myProfileDataModel = myProfileDataModelFromJson(jsonString);

import 'dart:convert';

MyProfileDataModel myProfileDataModelFromJson(String str) =>
    MyProfileDataModel.fromJson(json.decode(str));

String myProfileDataModelToJson(MyProfileDataModel data) =>
    json.encode(data.toJson());

class MyProfileDataModel {
  String? id;
  String? name;
  String? email;
  String? phoneNumber;

  List<UserAccountsDetail>? userAccountsDetails;
  String? s3Url;

  MyProfileDataModel({
    this.id,
    this.name,
    this.email,
    this.phoneNumber,
    this.userAccountsDetails,
    this.s3Url,
  });

  factory MyProfileDataModel.fromJson(Map<String, dynamic> json) =>
      MyProfileDataModel(
        id: json['id'],
        name: json['name'] ?? '',
        email: json['email'],
        phoneNumber: json['phone_number'],
        userAccountsDetails: json['user_accounts_details'] == null
            ? []
            : List<UserAccountsDetail>.from(
                json['user_accounts_details']!
                    .map((x) => UserAccountsDetail.fromJson(x)),
              ),
        s3Url: json['s3_url'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
        'phone_number': phoneNumber,
        'user_accounts_details': userAccountsDetails == null
            ? []
            : List<dynamic>.from(userAccountsDetails!.map((x) => x.toJson())),
        's3_url': s3Url,
      };
}

class UserAccountsDetail {
  String? id;
  String? name;
  List<String>? privileges;
  List<String>? abilities;
  bool? geoFencedSubmission;
  int? geoRadius;
  int? corrActionCriticalDueTime;
  int? corrActionDueTime;

  UserAccountsDetail({
    this.id,
    this.name,
    this.privileges,
    this.abilities,
    this.geoFencedSubmission,
    this.corrActionCriticalDueTime,
    this.geoRadius,
    this.corrActionDueTime,
  });

  factory UserAccountsDetail.fromJson(Map<String, dynamic> json) =>
      UserAccountsDetail(
        id: json['id'],
        name: json['name'],
        geoFencedSubmission: json['geo_fence_submission'],
        geoRadius: json['geo_radius'],
        corrActionCriticalDueTime: json['critical_corr_action_due_time'],
        corrActionDueTime: json['corr_action_due_time'],
        privileges: json['privileges'] == null
            ? []
            : List<String>.from(json['privileges']!.map((x) => x)),
        abilities: json['abilities'] == null
            ? []
            : List<String>.from(json['abilities']!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'geo_fence_submission': geoFencedSubmission,
        'geo_radius': geoRadius,
        'critical_corr_action_due_time': corrActionCriticalDueTime,
        'corr_action_due_time': corrActionDueTime,
        'privileges': privileges == null
            ? []
            : List<dynamic>.from(privileges!.map((x) => x)),
        'abilities': abilities == null
            ? []
            : List<dynamic>.from(abilities!.map((x) => x)),
      };
}
