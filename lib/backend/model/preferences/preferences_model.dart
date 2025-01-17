// To parse this JSON data, do
//
//     final updatePreferenceResponseModel = updatePreferenceResponseModelFromJson(jsonString);

import 'dart:convert';

UpdatePreferenceResponseModel updatePreferenceResponseModelFromJson(
        String str) =>
    UpdatePreferenceResponseModel.fromJson(json.decode(str));

String updatePreferenceResponseModelToJson(
        UpdatePreferenceResponseModel data) =>
    json.encode(data.toJson());

class UpdatePreferenceResponseModel {
  final int? status;
  final String? message;
  final Data? data;

  UpdatePreferenceResponseModel({
    this.status,
    this.message,
    this.data,
  });

  factory UpdatePreferenceResponseModel.fromJson(Map<String, dynamic> json) =>
      UpdatePreferenceResponseModel(
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
  final bool? emailPromotion;
  final bool? emailInvoice;
  final bool? smsInvoice;
  final bool? smsPromotion;
  final bool? wtspUpdates;
  final bool? pushNotification;
  final bool? picInPicAccess;

  Data({
    this.emailPromotion,
    this.emailInvoice,
    this.smsInvoice,
    this.smsPromotion,
    this.wtspUpdates,
    this.pushNotification,
    this.picInPicAccess,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        emailPromotion: json["email_promotion"],
        emailInvoice: json["email_invoice"],
        smsInvoice: json["sms_invoice"],
        smsPromotion: json["sms_promotion"],
        wtspUpdates: json["wtsp_updates"],
        pushNotification: json["push_notification"],
        picInPicAccess: json["pic_in_pic_access"],
      );

  Map<String, dynamic> toJson() => {
        "email_promotion": emailPromotion,
        "email_invoice": emailInvoice,
        "sms_invoice": smsInvoice,
        "sms_promotion": smsPromotion,
        "wtsp_updates": wtspUpdates,
        "push_notification": pushNotification,
        "pic_in_pic_access": picInPicAccess,
      };
}
