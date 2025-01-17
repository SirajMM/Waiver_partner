import 'dart:convert';

import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:waiver_driver/backend/model/view_bank_account/view_bank_model.dart';
import 'package:waiver_driver/core/constants/enums/enums.dart';




class AddProofItemModel {
  String text;

  ProofDocument? documentProof;
  Rx<ApprovalStatus> approvalStatus;
  AddProofItemModel({
    required this.text,
    required this.approvalStatus,
    this.documentProof,
  });
}

// To parse this JSON data, do
//
//     final addBankAccountResponseModel = addBankAccountResponseModelFromJson(jsonString);

GetDocumentsResponseModel getDocumentsResponseModelFromJson(String str) =>
    GetDocumentsResponseModel.fromJson(json.decode(str));

String getDocumentsResponseModelToJson(GetDocumentsResponseModel data) =>
    json.encode(data.toJson());

class GetDocumentsResponseModel {
  int? status;
  String? message;
  List<ProofDocument>? data;

  GetDocumentsResponseModel({
    this.status,
    this.message,
    this.data,
  });

  factory GetDocumentsResponseModel.fromJson(Map<String, dynamic> json) =>
      GetDocumentsResponseModel(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null
            ? []
            : List<ProofDocument>.from(
                json["data"]!.map((x) => ProofDocument.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class ProofDocument {
  String? id;
  List<FileElement>? files;
  Rejection? rejection;
  String? documentType;
  String? proofType;
  String? status;
  bool? isVerified;
  bool? isValid;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? user;

  ProofDocument({
    this.id,
    this.files,
    this.rejection,
    this.documentType,
    this.status,
    this.isVerified,
    this.proofType,
    this.isValid,
    this.createdAt,
    this.updatedAt,
    this.user,
  });

  factory ProofDocument.fromJson(Map<String, dynamic> json) => ProofDocument(
        id: json["id"],
        files: json["files"] == null
            ? []
            : List<FileElement>.from(
                json["files"]!.map((x) => FileElement.fromJson(x))),
        rejection: json["rejection"] == null
            ? null
            : Rejection.fromJson(json["rejection"]),
        documentType: json["document_type"],
        status: json["status"],
        isVerified: json["is_verified"],
        proofType: json["proof_type"],
        isValid: json["is_valid"],
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
        "files": files == null
            ? []
            : List<dynamic>.from(files!.map((x) => x.toJson())),
        "rejection": rejection?.toJson(),
        "document_type": documentType,
        "status": status,
        "proof_type": proofType,
        "is_verified": isVerified,
        "is_valid": isValid,
        "created_at":
            "${createdAt!.year.toString().padLeft(4, '0')}-${createdAt!.month.toString().padLeft(2, '0')}-${createdAt!.day.toString().padLeft(2, '0')}",
        "updated_at":
            "${updatedAt!.year.toString().padLeft(4, '0')}-${updatedAt!.month.toString().padLeft(2, '0')}-${updatedAt!.day.toString().padLeft(2, '0')}",
        "user": user,
      };
}

class FileElement {
  int? id;
  String? file;
  String? document;
  String? proofType;

  FileElement({
    this.id,
    this.file,
    this.document,
    this.proofType,
  });

  factory FileElement.fromJson(Map<String, dynamic> json) => FileElement(
        id: json["id"],
        file: json["file"],
        document: json["document"],
        proofType: json["proof_type"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "file": file,
        "document": document,
        "proof_type": proofType,
      };
}

class Rejection {
  String? reason;
  String? userResponse;
  bool? isRectified;
  dynamic document;

  Rejection({
    this.reason,
    this.userResponse,
    this.isRectified,
    this.document,
  });

  factory Rejection.fromJson(Map<String, dynamic> json) => Rejection(
        reason: json["reason"],
        userResponse: json["user_response"],
        isRectified: json["is_rectified"],
        document: json["document"],
      );

  Map<String, dynamic> toJson() => {
        "reason": reason,
        "user_response": userResponse,
        "is_rectified": isRectified,
        "document": document,
      };
}

///============================================================================>
// To parse this JSON data, do
//
//     final getProfilePhotoResponseModel = getProfilePhotoResponseModelFromJson(jsonString);

GetProfilePhotoResponseModel getProfilePhotoResponseModelFromJson(String str) =>
    GetProfilePhotoResponseModel.fromJson(json.decode(str));

String getProfilePhotoResponseModelToJson(GetProfilePhotoResponseModel data) =>
    json.encode(data.toJson());

class GetProfilePhotoResponseModel {
  int? status;
  String? message;
  ProfilePhotoModel? data;

  GetProfilePhotoResponseModel({
    this.status,
    this.message,
    this.data,
  });

  factory GetProfilePhotoResponseModel.fromJson(Map<String, dynamic> json) =>
      GetProfilePhotoResponseModel(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null
            ? null
            : ProfilePhotoModel.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data?.toJson(),
      };
}

class ProfilePhotoModel {
  String? profileImage;

  ProfilePhotoModel({
    this.profileImage,
  });

  factory ProfilePhotoModel.fromJson(Map<String, dynamic> json) =>
      ProfilePhotoModel(
        profileImage: json["profile_image"],
      );

  Map<String, dynamic> toJson() => {
        "profile_image": profileImage,
      };
}

// To parse this JSON data, do
//
//     final getBankAccountResponseModel = getBankAccountResponseModelFromJson(jsonString);

///============================================================================>
GetBankAccountResponseModel getBankAccountResponseModelFromJson(String str) =>
    GetBankAccountResponseModel.fromJson(json.decode(str));

String getBankAccountResponseModelToJson(GetBankAccountResponseModel data) =>
    json.encode(data.toJson());

class GetBankAccountResponseModel {
  int? status;
  String? message;
  BankData? data;

  GetBankAccountResponseModel({
    this.status,
    this.message,
    this.data,
  });

  factory GetBankAccountResponseModel.fromJson(Map<String, dynamic> json) =>
      GetBankAccountResponseModel(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null ? null : BankData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data?.toJson(),
      };
}

class BankData {
  String? id;
  Banks? bank;
  String? holderName;
  String? ifsc;
  String? accountNumber;
  bool? isVerified;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? user;

  BankData({
    this.id,
    this.bank,
    this.holderName,
    this.ifsc,
    this.accountNumber,
    this.isVerified,
    this.createdAt,
    this.updatedAt,
    this.user,
  });

  factory BankData.fromJson(Map<String, dynamic> json) => BankData(
        id: json["id"],
        bank: json["bank"] == null ? null : Banks.fromJson(json["bank"]),
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
        "bank": bank,
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

///============================================================================>

// To parse this JSON data, do
//
//     final uploadDocumentResponseModel = uploadDocumentResponseModelFromJson(jsonString);

// To parse this JSON data, do
//
//     final uploadDocumentResponseModel = uploadDocumentResponseModelFromJson(jsonString);

UploadDocumentResponseModel uploadDocumentResponseModelFromJson(String str) =>
    UploadDocumentResponseModel.fromJson(json.decode(str));

String uploadDocumentResponseModelToJson(UploadDocumentResponseModel data) =>
    json.encode(data.toJson());

class UploadDocumentResponseModel {
  int? status;
  String? message;
  Data? data;

  UploadDocumentResponseModel({
    this.status,
    this.message,
    this.data,
  });

  factory UploadDocumentResponseModel.fromJson(Map<String, dynamic> json) =>
      UploadDocumentResponseModel(
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
  List<String>? files;

  Data({
    this.files,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        files: json["files"] == null
            ? []
            : List<String>.from(json["files"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "files": files == null ? [] : List<dynamic>.from(files!.map((x) => x)),
      };
}
