// To parse this JSON data, do
//
//     final imageUploadModel = imageUploadModelFromJson(jsonString);

import 'dart:convert';

ImageUploadModel imageUploadModelFromJson(String str) =>
    ImageUploadModel.fromJson(json.decode(str));

String imageUploadModelToJson(ImageUploadModel data) =>
    json.encode(data.toJson());

class ImageUploadModel {
  String? key;
  String? url;
  String? fileName;
  bool isSuccess;

  ImageUploadModel({
    this.key,
    this.url,
    this.fileName,
    this.isSuccess = false,
  });

  factory ImageUploadModel.fromJson(Map<String, dynamic> json) =>
      ImageUploadModel(
        key: json['key'],
        url: json['url'],
        fileName: json['fileName'],
        isSuccess: json['isSuccess'] ?? false,
      );

  Map<String, dynamic> toJson() =>
      {'key': key, 'url': url, 'fileName': fileName, 'isSuccess': isSuccess};
}
