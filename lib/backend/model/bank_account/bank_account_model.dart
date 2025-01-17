// To parse this JSON data, do
//
//     final addBankAccountResponseModel = addBankAccountResponseModelFromJson(jsonString);

import 'dart:convert';

AddBankAccountResponseModel addBankAccountResponseModelFromJson(String str) =>
    AddBankAccountResponseModel.fromJson(json.decode(str));

String addBankAccountResponseModelToJson(AddBankAccountResponseModel data) =>
    json.encode(data.toJson());

class AddBankAccountResponseModel {
  int? status;
  String? message;
  BankAccount? data;

  AddBankAccountResponseModel({
    this.status,
    this.message,
    this.data,
  });

  factory AddBankAccountResponseModel.fromJson(Map<String, dynamic> json) =>
      AddBankAccountResponseModel(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null ? null : BankAccount.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data?.toJson(),
      };
}

class BankAccount {
  String? id;
  String? bankName;
  String? holderName;
  String? ifsc;
  String? accountNumber;
  bool? isVerified;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? user;

  BankAccount({
    this.id,
    this.bankName,
    this.holderName,
    this.ifsc,
    this.accountNumber,
    this.isVerified,
    this.createdAt,
    this.updatedAt,
    this.user,
  });

  factory BankAccount.fromJson(Map<String, dynamic> json) => BankAccount(
        id: json["id"],
        bankName: json["bank_name"],
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
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "bank_name": bankName,
        "holder_name": holderName,
        "ifsc": ifsc,
        "account_number": accountNumber,
        "is_verified": isVerified,
        "created_at":
            "${createdAt!.year.toString().padLeft(4, '0')}-${createdAt!.month.toString().padLeft(2, '0')}-${createdAt!.day.toString().padLeft(2, '0')}",
        "updated_at":
            "${updatedAt!.year.toString().padLeft(4, '0')}-${updatedAt!.month.toString().padLeft(2, '0')}-${updatedAt!.day.toString().padLeft(2, '0')}",
        "user": user,
      };
}
