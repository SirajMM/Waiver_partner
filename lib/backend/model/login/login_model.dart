import 'dart:convert';

import 'package:google_sign_in/google_sign_in.dart';

class CountryModel {
  String image;
  String name;
  String mobileCode;
  CountryModel({
    required this.image,
    required this.name,
    required this.mobileCode,
  });
}

// To parse this JSON data, do
//
//     final sendPhoneOtp = sendPhoneOtpFromJson(jsonString);

///============================================================================>
SendPhoneOtpResponseModel sendPhoneOtpResponseModelFromJson(String str) =>
    SendPhoneOtpResponseModel.fromJson(json.decode(str));

String sendPhoneOtpResponseModelToJson(SendPhoneOtpResponseModel data) =>
    json.encode(data.toJson());

class SendPhoneOtpResponseModel {
  int? status;
  String? message;

  SendPhoneOtpResponseModel({
    this.status,
    this.message,
  });

  factory SendPhoneOtpResponseModel.fromJson(Map<String, dynamic> json) =>
      SendPhoneOtpResponseModel(
        status: json["status"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
      };
}

///============================================================================>

class ArgumentModelForOtpPage {
  String mobilePhoneNumber;
  String mobileCode;
  GoogleSignInAccount? user;
  ArgumentModelForOtpPage(
      {required this.mobileCode,
      required this.user,
      required this.mobilePhoneNumber});
}
