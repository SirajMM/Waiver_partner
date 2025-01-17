// To parse this JSON data, do
//
//     final verifyOtpResponseModel = verifyOtpResponseModelFromJson(jsonString);

import 'dart:convert';

VerifyOtpResponseModel verifyOtpResponseModelFromJson(String str) =>
    VerifyOtpResponseModel.fromJson(json.decode(str));

String verifyOtpResponseModelToJson(VerifyOtpResponseModel data) =>
    json.encode(data.toJson());

class VerifyOtpResponseModel {
  int? status;
  String? message;
  UserDataOtp? data;

  VerifyOtpResponseModel({
    this.status,
    this.message,
    this.data,
  });

  factory VerifyOtpResponseModel.fromJson(Map<String, dynamic> json) =>
      VerifyOtpResponseModel(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null ? null : UserDataOtp.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data?.toJson(),
      };
}

class UserDataOtp {
  String? id;
  String? accessToken;
  String? refreshToken;
  bool? isRegistered;
  String? userType;
  String? fullname;
  bool? arePhotosUploaded;
  String? userId;
  bool? isVerifed;

  UserDataOtp({
    this.id,
    this.accessToken,
    this.refreshToken,
    this.isRegistered,
    this.userType,
    this.fullname,
    this.arePhotosUploaded,
    this.userId,
    this.isVerifed,
  });

  factory UserDataOtp.fromJson(Map<String, dynamic> json) => UserDataOtp(
        id: json["id"],
        accessToken: json["access_token"],
        refreshToken: json["refresh_token"],
        isRegistered: json["is_registered"],
        userType: json["user_type"],
        fullname: json["fullname"],
        arePhotosUploaded: json["are_photos_uploaded"],
        userId: json["user_id"],
        isVerifed: json["is_verifed"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "access_token": accessToken,
        "refresh_token": refreshToken,
        "is_registered": isRegistered,
        "user_type": userType,
        "fullname": fullname,
        "are_photos_uploaded": arePhotosUploaded,
        "user_id": userId,
        "is_verifed": isVerifed,
      };
}
