// To parse this JSON data, do
//
//     final addVehicleResponseModel = addVehicleResponseModelFromJson(jsonString);

import 'dart:convert';

import '../fleet_home_page/fleet_home_page_model.dart';

AddVehicleResponseModel addVehicleResponseModelFromJson(String str) =>
    AddVehicleResponseModel.fromJson(json.decode(str));

String addVehicleResponseModelToJson(AddVehicleResponseModel data) =>
    json.encode(data.toJson());

class AddVehicleResponseModel {
  final int? status;
  final String? message;
  final FleetVehicle? data;

  AddVehicleResponseModel({
    this.status,
    this.message,
    this.data,
  });

  factory AddVehicleResponseModel.fromJson(Map<String, dynamic> json) =>
      AddVehicleResponseModel(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null ? null : FleetVehicle.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data?.toJson(),
      };
}

class FleetVehileModel {
  final String? id;
  final String? registrationNumber;
  final String? brand;
  final String? name;
  final DateTime? permitEndDate;
  final DateTime? insuranceEndDate;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? vehicleType;
  final int? transmissionType;

  FleetVehileModel({
    this.id,
    this.registrationNumber,
    this.brand,
    this.name,
    this.permitEndDate,
    this.insuranceEndDate,
    this.createdAt,
    this.updatedAt,
    this.vehicleType,
    this.transmissionType,
  });

  factory FleetVehileModel.fromJson(Map<String, dynamic> json) =>
      FleetVehileModel(
        id: json["id"],
        registrationNumber: json["registration_number"],
        brand: json["brand"],
        name: json["name"],
        permitEndDate: json["permit_end_date"] == null
            ? null
            : DateTime.parse(json["permit_end_date"]),
        insuranceEndDate: json["insurance_end_date"] == null
            ? null
            : DateTime.parse(json["insurance_end_date"]),
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        vehicleType: json["vehicle_type"],
        transmissionType: json["transmission_type"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "registration_number": registrationNumber,
        "brand": brand,
        "name": name,
        "permit_end_date":
            "${permitEndDate!.year.toString().padLeft(4, '0')}-${permitEndDate!.month.toString().padLeft(2, '0')}-${permitEndDate!.day.toString().padLeft(2, '0')}",
        "insurance_end_date":
            "${insuranceEndDate!.year.toString().padLeft(4, '0')}-${insuranceEndDate!.month.toString().padLeft(2, '0')}-${insuranceEndDate!.day.toString().padLeft(2, '0')}",
        "created_at":
            "${createdAt!.year.toString().padLeft(4, '0')}-${createdAt!.month.toString().padLeft(2, '0')}-${createdAt!.day.toString().padLeft(2, '0')}",
        "updated_at":
            "${updatedAt!.year.toString().padLeft(4, '0')}-${updatedAt!.month.toString().padLeft(2, '0')}-${updatedAt!.day.toString().padLeft(2, '0')}",
        "vehicle_type": vehicleType,
        "transmission_type": transmissionType,
      };
}
