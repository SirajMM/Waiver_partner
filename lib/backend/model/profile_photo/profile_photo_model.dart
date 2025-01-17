// To parse this JSON data, do
//
//     final uploadProfilePhotoResponseModel = uploadProfilePhotoResponseModelFromJson(jsonString);

import 'dart:convert';

UploadProfilePhotoResponseModel uploadProfilePhotoResponseModelFromJson(
        String str) =>
    UploadProfilePhotoResponseModel.fromJson(json.decode(str));

String uploadProfilePhotoResponseModelToJson(
        UploadProfilePhotoResponseModel data) =>
    json.encode(data.toJson());

class UploadProfilePhotoResponseModel {
  int? status;
  String? message;
  UploadProfilePhotoItem? data;

  UploadProfilePhotoResponseModel({
    this.status,
    this.message,
    this.data,
  });

  factory UploadProfilePhotoResponseModel.fromJson(Map<String, dynamic> json) =>
      UploadProfilePhotoResponseModel(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null
            ? null
            : UploadProfilePhotoItem.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data?.toJson(),
      };
}

class UploadProfilePhotoItem {
  String? profileImage;

  UploadProfilePhotoItem({
    this.profileImage,
  });

  factory UploadProfilePhotoItem.fromJson(Map<String, dynamic> json) =>
      UploadProfilePhotoItem(
        profileImage: json["profile_image"],
      );

  Map<String, dynamic> toJson() => {
        "profile_image": profileImage,
      };
}
