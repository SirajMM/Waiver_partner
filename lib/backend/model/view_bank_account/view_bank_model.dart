// To parse this JSON data, do
//
//     final getBanksResponseModel = getBanksResponseModelFromJson(jsonString);

import 'dart:convert';

GetBanksResponseModel getBanksResponseModelFromJson(String str) =>
    GetBanksResponseModel.fromJson(json.decode(str));

String getBanksResponseModelToJson(GetBanksResponseModel data) =>
    json.encode(data.toJson());

class GetBanksResponseModel {
  int? status;
  String? message;
  List<Banks>? data;

  GetBanksResponseModel({
    this.status,
    this.message,
    this.data,
  });

  factory GetBanksResponseModel.fromJson(Map<String, dynamic> json) =>
      GetBanksResponseModel(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null
            ? []
            : List<Banks>.from(json["data"]!.map((x) => Banks.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class Banks {
  int? id;
  String? name;

  Banks({
    this.id,
    this.name,
  });

  factory Banks.fromJson(Map<String, dynamic> json) => Banks(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}

// To parse this JSON data, do
//
//     final updateBanksResponseModel = updateBanksResponseModelFromJson(jsonString);

UpdateBanksResponseModel updateBanksResponseModelFromJson(String str) =>
    UpdateBanksResponseModel.fromJson(json.decode(str));

String updateBanksResponseModelToJson(UpdateBanksResponseModel data) =>
    json.encode(data.toJson());

class UpdateBanksResponseModel {
  int? status;
  String? message;
  UpdateBankData? data;

  UpdateBanksResponseModel({
    this.status,
    this.message,
    this.data,
  });

  factory UpdateBanksResponseModel.fromJson(Map<String, dynamic> json) =>
      UpdateBanksResponseModel(
        status: json["status"],
        message: json["message"],
        data:
            json["data"] == null ? null : UpdateBankData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data?.toJson(),
      };
}

class UpdateBankData {
  String? id;
  String? holderName;
  String? ifsc;
  String? accountNumber;
  bool? isVerified;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? user;
  int? bank;

  UpdateBankData({
    this.id,
    this.holderName,
    this.ifsc,
    this.accountNumber,
    this.isVerified,
    this.createdAt,
    this.updatedAt,
    this.user,
    this.bank,
  });

  factory UpdateBankData.fromJson(Map<String, dynamic> json) => UpdateBankData(
        id: json["id"],
        holderName: json["holder_name"],
        ifsc: json["ifsc"],
        accountNumber: json["account_number"],
        isVerified: json["is_verified"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        user: json["user"],
        bank: json["bank"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "holder_name": holderName,
        "ifsc": ifsc,
        "account_number": accountNumber,
        "is_verified": isVerified,
        "created_at":
            "${createdAt!.year.toString().padLeft(4, '0')}-${createdAt!.month.toString().padLeft(2, '0')}-${createdAt!.day.toString().padLeft(2, '0')}",
        "updated_at":
            "${updatedAt!.year.toString().padLeft(4, '0')}-${updatedAt!.month.toString().padLeft(2, '0')}-${updatedAt!.day.toString().padLeft(2, '0')}",
        "user": user,
        "bank": bank,
      };
}
