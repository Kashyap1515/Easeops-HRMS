// To parse this JSON data, do
//
//     final loginModel = loginModelFromJson(jsonString);

import 'dart:convert';

LoginModel loginModelFromJson(String str) =>
    LoginModel.fromJson(json.decode(str));

String loginModelToJson(LoginModel data) => json.encode(data.toJson());

class LoginModel {
  LoginModel({
    this.name,
    this.isActive,
    this.isSuperuser,
    this.lastLogin,
    this.email,
    this.phoneNumber,
    this.updatedAt,
    this.isStaff,
    this.id,
    this.isVerified,
    this.password,
    this.createdAt,
    this.token,
  });

  factory LoginModel.fromJson(Map<String, dynamic> json) => LoginModel(
        name: json['name'],
        isActive: json['is_active'],
        isSuperuser: json['is_superuser'],
        lastLogin: json['last_login'],
        email: json['email'],
        phoneNumber: json['phone_number'],
        updatedAt: json['updated_at'] == null
            ? null
            : DateTime.parse(json['updated_at']),
        isStaff: json['is_staff'],
        id: json['id'],
        isVerified: json['is_verified'],
        password: json['password'],
        createdAt: json['created_at'] == null
            ? null
            : DateTime.parse(json['created_at']),
        token: json['token'] ?? '',
      );
  String? name;
  bool? isActive;
  bool? isSuperuser;
  dynamic lastLogin;
  String? email;
  String? phoneNumber;
  DateTime? updatedAt;
  bool? isStaff;
  String? id;
  bool? isVerified;
  String? password;
  DateTime? createdAt;
  String? token;

  Map<String, dynamic> toJson() => {
        'name': name,
        'is_active': isActive,
        'is_superuser': isSuperuser,
        'last_login': lastLogin,
        'email': email,
        'phone_number': phoneNumber,
        'updated_at': updatedAt?.toIso8601String(),
        'is_staff': isStaff,
        'id': id,
        'is_verified': isVerified,
        'password': password,
        'created_at': createdAt?.toIso8601String(),
        'token': token,
      };
}
