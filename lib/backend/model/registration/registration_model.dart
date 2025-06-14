//
// ///============================================================================>


import 'dart:convert';

import 'package:get/get.dart';

import '../driver_profile/driver_profile_model.dart';

class GenderModel {
  String label;
  String code;
  GenderModel({required this.label, required this.code});
}

///============================================================================>

// To parse this JSON data, do
//
//     final getAllStatesResponseModel = getAllStatesResponseModelFromJson(jsonString);

GetAllStatesResponseModel getAllStatesResponseModelFromJson(String str) =>
    GetAllStatesResponseModel.fromJson(json.decode(str));

String getAllStatesResponseModelToJson(GetAllStatesResponseModel data) =>
    json.encode(data.toJson());

class GetAllStatesResponseModel {
  int? status;
  String? message;
  List<StatesModel>? data;

  GetAllStatesResponseModel({
    this.status,
    this.message,
    this.data,
  });

  factory GetAllStatesResponseModel.fromJson(Map<String, dynamic> json) =>
      GetAllStatesResponseModel(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null
            ? []
            : List<StatesModel>.from(
            json["data"]!.map((x) => StatesModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": data == null
        ? []
        : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class StatesModel {
  int? id;
  String? name;
  dynamic deleted;

  StatesModel({
    this.id,
    this.name,
    this.deleted,
  });

  factory StatesModel.fromJson(Map<String, dynamic> json) => StatesModel(
    id: json["id"],
    name: json["name"],
    deleted: json["deleted"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "deleted": deleted,
  };
}

///============================================================================>
// To parse this JSON data, do
//
//     final getAllDistrictsResponseModel = getAllDistrictsResponseModelFromJson(jsonString);

GetAllDistrictsResponseModel getAllDistrictsResponseModelFromJson(String str) =>
    GetAllDistrictsResponseModel.fromJson(json.decode(str));

String getAllDistrictsResponseModelToJson(GetAllDistrictsResponseModel data) =>
    json.encode(data.toJson());

class GetAllDistrictsResponseModel {
  int? status;
  String? message;
  List<DistrictModel>? data;

  GetAllDistrictsResponseModel({
    this.status,
    this.message,
    this.data,
  });

  factory GetAllDistrictsResponseModel.fromJson(Map<String, dynamic> json) =>
      GetAllDistrictsResponseModel(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null
            ? []
            : List<DistrictModel>.from(
            json["data"]!.map((x) => DistrictModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": data == null
        ? []
        : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class DistrictModel {
  int? id;
  String? name;
  int? state;
  dynamic deleted;

  DistrictModel({
    this.id,
    this.name,
    this.state,
    this.deleted,
  });

  factory DistrictModel.fromJson(Map<String, dynamic> json) => DistrictModel(
    id: json["id"],
    name: json["name"],
    state: json["state"],
    deleted: json["deleted"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "state": state,
    "deleted": deleted,
  };
}

///============================================================================>
// To parse this JSON data, do
//
//     final getAllWorkLocationsResponseModel = getAllWorkLocationsResponseModelFromJson(jsonString);

GetAllWorkLocationsResponseModel getAllWorkLocationsResponseModelFromJson(
    String str) =>
    GetAllWorkLocationsResponseModel.fromJson(json.decode(str));

String getAllWorkLocationsResponseModelToJson(
    GetAllWorkLocationsResponseModel data) =>
    json.encode(data.toJson());

class GetAllWorkLocationsResponseModel {
  int? status;
  String? message;
  List<WorkLocation>? data;

  GetAllWorkLocationsResponseModel({
    this.status,
    this.message,
    this.data,
  });

  factory GetAllWorkLocationsResponseModel.fromJson(
      Map<String, dynamic> json) =>
      GetAllWorkLocationsResponseModel(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null
            ? []
            : List<WorkLocation>.from(
            json["data"]!.map((x) => WorkLocation.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": data == null
        ? []
        : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class WorkLocation {
  int? id;
  String? name;
  dynamic deleted;
  String? status;
  String? locationType;
  int? radius;

  WorkLocation({
    this.id,
    this.name,
    this.deleted,
    this.status,
    this.locationType,
    this.radius,
  });

  factory WorkLocation.fromJson(Map<String, dynamic> json) => WorkLocation(
    id: json["id"],
    name: json["name"],
    deleted: json["deleted"],
    status: json["status"],
    locationType: json["location_type"],
    radius: json["radius"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "deleted": deleted,
    "status": status,
    "location_type": locationType,
    "radius": radius,
  };
}

///============================================================================>
// To parse this JSON data, do
//
//     final getAllWorkExperienceResponseModel = getAllWorkExperienceResponseModelFromJson(jsonString);

GetAllWorkExperienceResponseModel getAllWorkExperienceResponseModelFromJson(
    String str) =>
    GetAllWorkExperienceResponseModel.fromJson(json.decode(str));

String getAllWorkExperienceResponseModelToJson(
    GetAllWorkExperienceResponseModel data) =>
    json.encode(data.toJson());

class GetAllWorkExperienceResponseModel {
  int? status;
  String? message;
  List<WorkExperience>? data;

  GetAllWorkExperienceResponseModel({
    this.status,
    this.message,
    this.data,
  });

  factory GetAllWorkExperienceResponseModel.fromJson(
      Map<String, dynamic> json) =>
      GetAllWorkExperienceResponseModel(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null
            ? []
            : List<WorkExperience>.from(
            json["data"]!.map((x) => WorkExperience.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": data == null
        ? []
        : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class WorkExperience {
  int? id;
  String? experience;
  dynamic deleted;

  WorkExperience({
    this.id,
    this.experience,
    this.deleted,
  });

  factory WorkExperience.fromJson(Map<String, dynamic> json) => WorkExperience(
    id: json["id"],
    experience: json["experience"],
    deleted: json["deleted"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "experience": experience,
    "deleted": deleted,
  };
}

///============================================================================>
// To parse this JSON data, do
//
//     final getVehicleTypeResponseModel = getVehicleTypeResponseModelFromJson(jsonString);

GetVehicleTypeResponseModel getVehicleTypeResponseModelFromJson(String str) =>
    GetVehicleTypeResponseModel.fromJson(json.decode(str));

String getVehicleTypeResponseModelToJson(GetVehicleTypeResponseModel data) =>
    json.encode(data.toJson());

class GetVehicleTypeResponseModel {
  int? status;
  String? message;
  List<VehicleType>? data;

  GetVehicleTypeResponseModel({
    this.status,
    this.message,
    this.data,
  });

  factory GetVehicleTypeResponseModel.fromJson(Map<String, dynamic> json) =>
      GetVehicleTypeResponseModel(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null
            ? []
            : List<VehicleType>.from(
            json["data"]!.map((x) => VehicleType.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": data == null
        ? []
        : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class VehicleType {
  int? id;
  String? name;
  dynamic deleted;
  Rx<bool>? isSelected;

  VehicleType({this.id, this.name, this.deleted, this.isSelected});

  factory VehicleType.fromJson(Map<String, dynamic> json) => VehicleType(
      id: json["id"],
      name: json["name"],
      deleted: json["deleted"],
      isSelected: Rx<bool>(false));

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "deleted": deleted,
  };
}

///============================================================================>
// To parse this JSON data, do
//
//     final getTransmissionTypeResponseModel = getTransmissionTypeResponseModelFromJson(jsonString);

GetTransmissionTypeResponseModel getTransmissionTypeResponseModelFromJson(
    String str) =>
    GetTransmissionTypeResponseModel.fromJson(json.decode(str));

String getTransmissionTypeResponseModelToJson(
    GetTransmissionTypeResponseModel data) =>
    json.encode(data.toJson());

class GetTransmissionTypeResponseModel {
  int? status;
  String? message;
  List<Transmission>? data;

  GetTransmissionTypeResponseModel({
    this.status,
    this.message,
    this.data,
  });

  factory GetTransmissionTypeResponseModel.fromJson(
      Map<String, dynamic> json) =>
      GetTransmissionTypeResponseModel(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null
            ? []
            : List<Transmission>.from(
            json["data"]!.map((x) => Transmission.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": data == null
        ? []
        : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class Transmission {
  int? id;
  String? name;
  dynamic deleted;
  Rx<bool>? isSelected;

  Transmission({this.id, this.name, this.deleted, this.isSelected});

  factory Transmission.fromJson(Map<String, dynamic> json) => Transmission(
      id: json["id"],
      name: json["name"],
      deleted: json["deleted"],
      isSelected: Rx<bool>(false));

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "deleted": deleted,
  };
}

///============================================================================>
// To parse this JSON data, do
//
//     final createDriverProfileResponseModel = createDriverProfileResponseModelFromJson(jsonString);

CreateDriverProfileResponseModel createDriverProfileResponseModelFromJson(
    String str) =>
    CreateDriverProfileResponseModel.fromJson(json.decode(str));

String createDriverProfileResponseModelToJson(
    CreateDriverProfileResponseModel data) =>
    json.encode(data.toJson());

class CreateDriverProfileResponseModel {
  int? status;
  String? message;
  Data? data;

  CreateDriverProfileResponseModel({
    this.status,
    this.message,
    this.data,
  });

  factory CreateDriverProfileResponseModel.fromJson(
      Map<String, dynamic> json) =>
      CreateDriverProfileResponseModel(
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
  String? uniqueId;
  String? fullname;
  String? gender;
  String? status;
  String? email;
  DateTime? dob;
  bool? isVerified;
  bool? isOnline;
  String? alternativePhone;
  String? whatsappPhone;
  String? address;
  DateTime? licenseValidity;
  dynamic profileImage;
  bool? isProfileImageVerified;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? user;
  State? state;
  District? district;
  WorkExperience? drivingExperience;
  WorkLocation? workLocation;
  List<Transmission>? transmissionType;
  List<VehicleType>? vehicleType;
  String? rating;
  dynamic deleted;
  bool? availableStatus;
  bool? hasVehicleAssigned;
  dynamic vehicleDetails;

  Data({
    this.id,
    this.uniqueId,
    this.fullname,
    this.gender,
    this.status,
    this.email,
    this.dob,
    this.isVerified,
    this.isOnline,
    this.alternativePhone,
    this.whatsappPhone,
    this.address,
    this.licenseValidity,
    this.profileImage,
    this.isProfileImageVerified,
    this.createdAt,
    this.updatedAt,
    this.user,
    this.state,
    this.district,
    this.drivingExperience,
    this.workLocation,
    this.transmissionType,
    this.vehicleType,
    this.rating,
    this.deleted,
    this.availableStatus,
    this.hasVehicleAssigned,
    this.vehicleDetails,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["id"],
    uniqueId: json["unique_id"],
    fullname: json["fullname"],
    gender: json["gender"],
    status: json["status"],
    email: json["email"],
    dob: json["dob"] == null ? null : DateTime.parse(json["dob"]),
    isVerified: json["is_verified"],
    isOnline: json["is_online"],
    alternativePhone: json["alternative_phone"],
    whatsappPhone: json["whatsapp_phone"],
    address: json["address"],
    licenseValidity: json["license_validity"] == null
        ? null
        : DateTime.parse(json["license_validity"]),
    profileImage: json["profile_image"],
    isProfileImageVerified: json["is_profile_image_verified"],
    createdAt: json["created_at"] == null
        ? null
        : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null
        ? null
        : DateTime.parse(json["updated_at"]),
    user: json["user"],
    state: json["state"] == null ? null : State.fromJson(json["state"]),
    district: json["district"] == null ? null : District.fromJson(json["district"]),
    drivingExperience: json["driving_experience"] == null
        ? null
        : WorkExperience.fromJson(json["driving_experience"]),
    workLocation: json["work_location"] == null
        ? null
        : WorkLocation.fromJson(json["work_location"]),
    transmissionType: json["transmission_type"] == null
        ? []
        : List<Transmission>.from(json["transmission_type"]!
        .map((x) => Transmission.fromJson(x))),
    vehicleType: json["vehicle_type"] == null
        ? []
        : List<VehicleType>.from(
        json["vehicle_type"]!.map((x) => VehicleType.fromJson(x))),
    rating: json["rating"],
    deleted: json["deleted"],
    availableStatus: json["available_status"],
    hasVehicleAssigned: json["has_vehicle_assigned"],
    vehicleDetails: json["vehicle_details"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "unique_id": uniqueId,
    "fullname": fullname,
    "gender": gender,
    "status": status,
    "email": email,
    "dob": dob?.toIso8601String(),
    "is_verified": isVerified,
    "is_online": isOnline,
    "alternative_phone": alternativePhone,
    "whatsapp_phone": whatsappPhone,
    "address": address,
    "license_validity": licenseValidity?.toIso8601String(),
    "profile_image": profileImage,
    "is_profile_image_verified": isProfileImageVerified,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "user": user,
    "state": state?.toJson(),
    "district": district?.toJson(),
    "driving_experience": drivingExperience?.toJson(),
    "work_location": workLocation?.toJson(),
    "transmission_type": transmissionType == null
        ? []
        : List<dynamic>.from(transmissionType!.map((x) => x.toJson())),
    "vehicle_type": vehicleType == null
        ? []
        : List<dynamic>.from(vehicleType!.map((x) => x.toJson())),
    "rating": rating,
    "deleted": deleted,
    "available_status": availableStatus,
    "has_vehicle_assigned": hasVehicleAssigned,
    "vehicle_details": vehicleDetails,
  };
}

class State {
  int? id;
  String? name;
  dynamic deleted;
  RxBool isSelected = false.obs;

  State({
    this.id,
    this.name,
    this.deleted,
  });

  factory State.fromJson(Map<String, dynamic> json) => State(
    id: json["id"],
    name: json["name"],
    deleted: json["deleted"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "deleted": deleted,
  };
}

class District {
  int? id;
  String? name;
  int? state;
  dynamic deleted;

  District({
    this.id,
    this.name,
    this.state,
    this.deleted,
  });

  factory District.fromJson(Map<String, dynamic> json) => District(
    id: json["id"],
    name: json["name"],
    state: json["state"],
    deleted: json["deleted"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "state": state,
    "deleted": deleted,
  };
}

///============================================================================>