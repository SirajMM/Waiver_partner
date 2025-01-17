// To parse this JSON data, do
//
//     final getVehicleListResponseModel = getVehicleListResponseModelFromJson(jsonString);

import 'dart:convert';

import 'package:get/get_rx/src/rx_types/rx_types.dart';

import '../chauffeur_proof/chauffeur_proof_model.dart';

GetVehicleListResponseModel getVehicleListResponseModelFromJson(String str) =>
    GetVehicleListResponseModel.fromJson(json.decode(str));

String getVehicleListResponseModelToJson(GetVehicleListResponseModel data) =>
    json.encode(data.toJson());

class GetVehicleListResponseModel {
  int? status;
  String? message;
  List<FleetVehicle>? data;

  GetVehicleListResponseModel({
    this.status,
    this.message,
    this.data,
  });

  factory GetVehicleListResponseModel.fromJson(Map<String, dynamic> json) =>
      GetVehicleListResponseModel(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null
            ? []
            : List<FleetVehicle>.from(
                json["data"]!.map((x) => FleetVehicle.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class FleetVehicle {
  String? id;
  Driver? driver;
  List<ProofDocument>? proof;
  String? registrationNumber;
  String? brand;
  String? name;
  DateTime? permitEndDate;
  DateTime? insuranceEndDate;
  bool? isValid;
  Rx<String?>? status;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? user;
  int? vehicleType;
  int? transmissionType;

  FleetVehicle({
    this.id,
    this.driver,
    this.proof,
    this.registrationNumber,
    this.brand,
    this.name,
    this.permitEndDate,
    this.insuranceEndDate,
    this.isValid,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.user,
    this.vehicleType,
    this.transmissionType,
  });

  factory FleetVehicle.fromJson(Map<String, dynamic> json) => FleetVehicle(
        id: json["id"],
        driver: json["driver"] == null ? null : Driver.fromJson(json["driver"]),
        proof: json["proof"] == null
            ? []
            : List<ProofDocument>.from(
                json["proof"]!.map((x) => ProofDocument.fromJson(x))),
        registrationNumber: json["registration_number"],
        brand: json["brand"],
        name: json["name"],
        permitEndDate: json["permit_end_date"] == null
            ? null
            : DateTime.parse(json["permit_end_date"]),
        insuranceEndDate: json["insurance_end_date"] == null
            ? null
            : DateTime.parse(json["insurance_end_date"]),
        isValid: json["is_valid"],
        status: Rx<String?>(json["status"]),
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        user: json["user"],
        vehicleType: json["vehicle_type"],
        transmissionType: json["transmission_type"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "driver": driver?.toJson(),
        "proof": proof == null
            ? []
            : List<dynamic>.from(proof!.map((x) => x.toJson())),
        "registration_number": registrationNumber,
        "brand": brand,
        "name": name,
        "permit_end_date":
            "${permitEndDate!.year.toString().padLeft(4, '0')}-${permitEndDate!.month.toString().padLeft(2, '0')}-${permitEndDate!.day.toString().padLeft(2, '0')}",
        "insurance_end_date":
            "${insuranceEndDate!.year.toString().padLeft(4, '0')}-${insuranceEndDate!.month.toString().padLeft(2, '0')}-${insuranceEndDate!.day.toString().padLeft(2, '0')}",
        "is_valid": isValid,
        "status": status,
        "created_at":
            "${createdAt!.year.toString().padLeft(4, '0')}-${createdAt!.month.toString().padLeft(2, '0')}-${createdAt!.day.toString().padLeft(2, '0')}",
        "updated_at":
            "${updatedAt!.year.toString().padLeft(4, '0')}-${updatedAt!.month.toString().padLeft(2, '0')}-${updatedAt!.day.toString().padLeft(2, '0')}",
        "user": user,
        "vehicle_type": vehicleType,
        "transmission_type": transmissionType,
      };
}

class Driver {
  String? id;
  String? driverName;
  String? driverId;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? driver;

  Driver({
    this.id,
    this.driverName,
    this.driverId,
    this.createdAt,
    this.updatedAt,
    this.driver,
  });

  factory Driver.fromJson(Map<String, dynamic> json) => Driver(
        id: json["id"],
        driverName: json["driver_name"],
        driverId: json["driver_id"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        driver: json["driver"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "driver_name": driverName,
        "driver_id": driverId,
        "created_at":
            "${createdAt!.year.toString().padLeft(4, '0')}-${createdAt!.month.toString().padLeft(2, '0')}-${createdAt!.day.toString().padLeft(2, '0')}",
        "updated_at":
            "${updatedAt!.year.toString().padLeft(4, '0')}-${updatedAt!.month.toString().padLeft(2, '0')}-${updatedAt!.day.toString().padLeft(2, '0')}",
        "driver": driver,
      };
}

class Proof {
  String? id;
  List<FileElement>? files;
  Rejection? rejection;
  String? proofType;
  String? status;
  bool? isVerified;
  bool? isValid;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? vehicle;

  Proof({
    this.id,
    this.files,
    this.rejection,
    this.proofType,
    this.status,
    this.isVerified,
    this.isValid,
    this.createdAt,
    this.updatedAt,
    this.vehicle,
  });

  factory Proof.fromJson(Map<String, dynamic> json) => Proof(
        id: json["id"],
        files: json["files"] == null
            ? []
            : List<FileElement>.from(
                json["files"]!.map((x) => FileElement.fromJson(x))),
        rejection: json["rejection"] == null
            ? null
            : Rejection.fromJson(json["rejection"]),
        proofType: json["proof_type"],
        status: json["status"],
        isVerified: json["is_verified"],
        isValid: json["is_valid"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        vehicle: json["vehicle"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "files": files == null
            ? []
            : List<dynamic>.from(files!.map((x) => x.toJson())),
        "rejection": rejection?.toJson(),
        "proof_type": proofType,
        "status": status,
        "is_verified": isVerified,
        "is_valid": isValid,
        "created_at":
            "${createdAt!.year.toString().padLeft(4, '0')}-${createdAt!.month.toString().padLeft(2, '0')}-${createdAt!.day.toString().padLeft(2, '0')}",
        "updated_at":
            "${updatedAt!.year.toString().padLeft(4, '0')}-${updatedAt!.month.toString().padLeft(2, '0')}-${updatedAt!.day.toString().padLeft(2, '0')}",
        "vehicle": vehicle,
      };
}

class Rejection {
  String? reason;
  String? userResponse;
  bool? isRectified;
  dynamic vehicleProof;

  Rejection({
    this.reason,
    this.userResponse,
    this.isRectified,
    this.vehicleProof,
  });

  factory Rejection.fromJson(Map<String, dynamic> json) => Rejection(
        reason: json["reason"],
        userResponse: json["user_response"],
        isRectified: json["is_rectified"],
        vehicleProof: json["vehicle_proof"],
      );

  Map<String, dynamic> toJson() => {
        "reason": reason,
        "user_response": userResponse,
        "is_rectified": isRectified,
        "vehicle_proof": vehicleProof,
      };
}

enum CarRegistrationStatus {
  pending,
  active,
  blocked,
}
