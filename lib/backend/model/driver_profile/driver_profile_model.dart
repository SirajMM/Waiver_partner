// To parse this JSON data, do
//
//     final getDriverProfileResponseModel = getDriverProfileResponseModelFromJson(jsonString);

import 'dart:convert';

import 'package:waiver_driver/backend/model/registration/registration_model.dart';

GetDriverProfileResponseModel getDriverProfileResponseModelFromJson(
    String str) =>
    GetDriverProfileResponseModel.fromJson(json.decode(str));

String getDriverProfileResponseModelToJson(
    GetDriverProfileResponseModel data) =>
    json.encode(data.toJson());

class GetDriverProfileResponseModel {
  int? status;
  String? message;
  Data? data;

  GetDriverProfileResponseModel({
    this.status,
    this.message,
    this.data,
  });

  factory GetDriverProfileResponseModel.fromJson(Map<String, dynamic> json) =>
      GetDriverProfileResponseModel(
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
  String? id;
  Statemodel? state;
  District? district;
  List<Transmission>? transmissionType;
  List<Statemodel>? vehicleType;
  DrivingExperience? drivingExperience;
  WorkLocation? workLocation;
  String? uniqueId;
  String? fullname;
  String? gender;
  String? status;
  String? email;
  String? dob;
  bool? isVerified;
  bool? isOnline;
  String? rating;
  String? alternativePhone;
  String? whatsappPhone;
  String? address;
  dynamic licenseValidity;
  dynamic profileImage;
  bool? isProfileImageVerified;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? user;
  dynamic deleted;
  bool? availableStatus;
  bool? hasVehicleAssigned;
  VehicleDetails? vehicleDetails;

  Data({
    this.id,
    this.state,
    this.district,
    this.transmissionType,
    this.vehicleType,
    this.drivingExperience,
    this.workLocation,
    this.uniqueId,
    this.fullname,
    this.gender,
    this.status,
    this.email,
    this.dob,
    this.isVerified,
    this.isOnline,
    this.rating,
    this.alternativePhone,
    this.whatsappPhone,
    this.address,
    this.licenseValidity,
    this.profileImage,
    this.isProfileImageVerified,
    this.createdAt,
    this.updatedAt,
    this.user,
    this.deleted,
    this.availableStatus,
    this.hasVehicleAssigned,
    this.vehicleDetails,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["id"],
    state: json["state"] == null ? null : Statemodel.fromJson(json["state"]),
    district: json["district"] == null
        ? null
        : District.fromJson(json["district"]),
    transmissionType: json["transmission_type"] == null
        ? []
        : List<Transmission>.from(json["transmission_type"]!.map((x) => Transmission.fromJson(x))),
    vehicleType: json["vehicle_type"] == null
        ? []
        : List<Statemodel>.from(json["vehicle_type"]!.map((x) => Statemodel.fromJson(x))),
    drivingExperience: json["driving_experience"] == null
        ? null
        : DrivingExperience.fromJson(json["driving_experience"]),
    workLocation: json["work_location"] == null
        ? null
        : WorkLocation.fromJson(json["work_location"]),
    uniqueId: json["unique_id"],
    fullname: json["fullname"],
    gender: json["gender"],
    status: json["status"],
    email: json["email"],
    dob: json["dob"],
    isVerified: json["is_verified"],
    isOnline: json["is_online"],
    rating: json["rating"],
    alternativePhone: json["alternative_phone"],
    whatsappPhone: json["whatsapp_phone"],
    address: json["address"],
    licenseValidity: json["license_validity"],
    profileImage: json["profile_image"],
    isProfileImageVerified: json["is_profile_image_verified"],
    createdAt: json["created_at"] == null
        ? null
        : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null
        ? null
        : DateTime.parse(json["updated_at"]),
    user: json["user"],
    deleted: json["deleted"],
    availableStatus: json["available_status"],
    hasVehicleAssigned: json["has_vehicle_assigned"],
    vehicleDetails: json["vehicle_details"] == null
        ? null
        : VehicleDetails.fromJson(json["vehicle_details"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "state": state?.toJson(),
    "district": district?.toJson(),
    "transmission_type": transmissionType == null ? [] : List<dynamic>.from(transmissionType!.map((x) => x.toJson())),
    "vehicle_type": vehicleType == null
        ? []
        : List<dynamic>.from(vehicleType!.map((x) => x.toJson())),
    "driving_experience": drivingExperience?.toJson(),
    "work_location": workLocation?.toJson(),
    "unique_id": uniqueId,
    "fullname": fullname,
    "gender": gender,
    "status": status,
    "email": email,
    "dob": dob,
    "is_verified": isVerified,
    "is_online": isOnline,
    "rating": rating,
    "alternative_phone": alternativePhone,
    "whatsapp_phone": whatsappPhone,
    "address": address,
    "license_validity": licenseValidity,
    "profile_image": profileImage,
    "is_profile_image_verified": isProfileImageVerified,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "user": user,
    "deleted": deleted,
    "available_status": availableStatus,
    "has_vehicle_assigned": hasVehicleAssigned,
    "vehicle_details": vehicleDetails?.toJson(),
  };
}

class VehicleDetails {
  String? id;
  dynamic deleted;
  String? registrationNumber;
  String? brand;
  String? name;
  String? permitEndDate;
  String? insuranceEndDate;
  bool? isValid;
  String? status;
  String? createdAt;
  String? updatedAt;
  String? user;
  int? vehicleType;
  int? transmissionType;

  VehicleDetails({
    this.id,
    this.deleted,
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

  factory VehicleDetails.fromJson(Map<String, dynamic> json) => VehicleDetails(
    id: json["id"],
    deleted: json["deleted"],
    registrationNumber: json["registration_number"],
    brand: json["brand"],
    name: json["name"],
    permitEndDate: json["permit_end_date"],
    insuranceEndDate: json["insurance_end_date"],
    isValid: json["is_valid"],
    status: json["status"],
    createdAt: json["created_at"],
    updatedAt: json["updated_at"],
    user: json["user"],
    vehicleType: json["vehicle_type"],
    transmissionType: json["transmission_type"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "deleted": deleted,
    "registration_number": registrationNumber,
    "brand": brand,
    "name": name,
    "permit_end_date": permitEndDate,
    "insurance_end_date": insuranceEndDate,
    "is_valid": isValid,
    "status": status,
    "created_at": createdAt,
    "updated_at": updatedAt,
    "user": user,
    "vehicle_type": vehicleType,
    "transmission_type": transmissionType,
  };
}

class District {
  int? id;
  String? name;
  int? state;

  District({
    this.id,
    this.name,
    this.state,
  });

  factory District.fromJson(Map<String, dynamic> json) => District(
        id: json["id"],
        name: json["name"],
        state: json["state"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "state": state,
      };
}

class DrivingExperience {
  int? id;
  int? experience;

  DrivingExperience({
    this.id,
    this.experience,
  });

  factory DrivingExperience.fromJson(Map<String, dynamic> json) =>
      DrivingExperience(
        id: json["id"],
        experience: json["experience"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "experience": experience,
      };
}

class Statemodel {
  int? id;
  String? name;

  Statemodel({
    this.id,
    this.name,
  });

  factory Statemodel.fromJson(Map<String, dynamic> json) => Statemodel(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}

class WorkLocation {
  int? id;
  String? name;
  dynamic status;
  dynamic locationType;
  int? radius;

  WorkLocation({
    this.id,
    this.name,
    this.status,
    this.locationType,
    this.radius,
  });

  factory WorkLocation.fromJson(Map<String, dynamic> json) => WorkLocation(
        id: json["id"],
        name: json["name"],
        status: json["status"],
        locationType: json["location_type"],
        radius: json["radius"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "status": status,
        "location_type": locationType,
        "radius": radius,
      };
}
