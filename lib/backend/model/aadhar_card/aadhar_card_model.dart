// To parse this JSON data, do
//
//     final uploadAadharResponseModel = uploadAadharResponseModelFromJson(jsonString);

import 'dart:convert';

UploadFileResponseModel uploadFileResponseModelFromJson(String str) =>
    UploadFileResponseModel.fromJson(json.decode(str));

String uploadFileResponseModelToJson(UploadFileResponseModel data) =>
    json.encode(data.toJson());

class UploadFileResponseModel {
  final int? status;
  final String? message;
  final Data? data;

  UploadFileResponseModel({
    this.status,
    this.message,
    this.data,
  });

  factory UploadFileResponseModel.fromJson(Map<String, dynamic> json) =>
      UploadFileResponseModel(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data?.toJson(),
      };
}

class Data {
  final String? file;

  Data({
    this.file,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        file: json["file"],
      );

  Map<String, dynamic> toJson() => {
        "file": file,
      };
}
