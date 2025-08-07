import 'dart:convert';

class SettingItemModel {
  String header;
  String text;
  String icon;
  SettingItemModel({
    required this.header,
    required this.text,
    required this.icon,
  });
}

// To parse this JSON data, do
//
//     final logoutResponseModel = logoutResponseModelFromJson(jsonString);

LogoutResponseModel logoutResponseModelFromJson(String str) =>
    LogoutResponseModel.fromJson(json.decode(str));

String logoutResponseModelToJson(LogoutResponseModel data) =>
    json.encode(data.toJson());

class LogoutResponseModel {
  final int? status;
  final String? message;
  final Data? data;

  LogoutResponseModel({
    this.status,
    this.message,
    this.data,
  });

  factory LogoutResponseModel.fromJson(Map<String, dynamic> json) =>
      LogoutResponseModel(
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
  Data();

  factory Data.fromJson(Map<String, dynamic> json) => Data();

  Map<String, dynamic> toJson() => {};
}
