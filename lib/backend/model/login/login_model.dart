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
  ErrorDetails? error;

  SendPhoneOtpResponseModel({
    this.status,
    this.message,
    this.error,
  });

  factory SendPhoneOtpResponseModel.fromJson(Map<String, dynamic> json) =>
      SendPhoneOtpResponseModel(
        status: json["status"],
        message: json["message"],
        error:
            json["error"] != null ? ErrorDetails.fromJson(json["error"]) : null,
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "error": error?.toJson(),
      };
}

class ErrorDetails {
  List<String>? nonFieldErrors;

  ErrorDetails({
    this.nonFieldErrors,
  });

  factory ErrorDetails.fromJson(Map<String, dynamic> json) => ErrorDetails(
        nonFieldErrors: json["non_field_errors"] != null
            ? List<String>.from(json["non_field_errors"].map((x) => x))
            : null,
      );

  Map<String, dynamic> toJson() => {
        "non_field_errors": nonFieldErrors != null
            ? List<dynamic>.from(nonFieldErrors!.map((x) => x))
            : null,
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
