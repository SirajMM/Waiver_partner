// To parse this JSON data, do
//
//     final getProfileResponseModel = getProfileResponseModelFromJson(jsonString);

// To parse this JSON data, do
//
//     final getProfileResponseModel = getProfileResponseModelFromJson(jsonString);

import 'dart:convert';

import 'package:get/get_rx/src/rx_types/rx_types.dart';

import '../registration/registration_model.dart';

GetProfileResponseModel getProfileResponseModelFromJson(String str) =>
    GetProfileResponseModel.fromJson(json.decode(str));

String getProfileResponseModelToJson(GetProfileResponseModel data) =>
    json.encode(data.toJson());

class GetProfileResponseModel {
  int? status;
  String? message;
  ProfileData? data;

  GetProfileResponseModel({
    this.status,
    this.message,
    this.data,
  });

  factory GetProfileResponseModel.fromJson(Map<String, dynamic> json) =>
      GetProfileResponseModel(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null ? null : ProfileData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data?.toJson(),
      };
}

class ProfileData {
  String? id;
  State? state;
  District? district;
  State? transmissionType;
  List<State>? vehicleType;
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
  int? rating;
  String? alternativePhone;
  String? whatsappPhone;
  String? address;
  String? licenseValidity;
  String? profileImage;
  bool? isProfileImageVerified;
  String? createdAt;
  String? updatedAt;
  String? user;

  ProfileData({
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
  });

  factory ProfileData.fromJson(Map<String, dynamic> json) => ProfileData(
        id: json["id"],
        state: json["state"] == null ? null : State.fromJson(json["state"]),
        district: json["district"] == null
            ? null
            : District.fromJson(json["district"]),
        transmissionType: json["transmission_type"] == null
            ? null
            : State.fromJson(json["transmission_type"]),
        vehicleType: json["vehicle_type"] == null
            ? []
            : List<State>.from(
                json["vehicle_type"]!.map((x) => State.fromJson(x))),
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
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        user: json["user"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "state": state?.toJson(),
        "district": district?.toJson(),
        "transmission_type": transmissionType?.toJson(),
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
        "created_at": createdAt,
        "updated_at": updatedAt,
        "user": user,
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

class State {
  int? id;
  String? name;
  RxBool isSelected = false.obs;

  State({
    this.id,
    this.name,
  });

  factory State.fromJson(Map<String, dynamic> json) => State(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}

// class WorkLocation {
//   int? id;
//   String? name;
//   dynamic status;
//   dynamic locationType;
//   int? radius;
//
//   WorkLocation({
//     this.id,
//     this.name,
//     this.status,
//     this.locationType,
//     this.radius,
//   });
//
//   factory WorkLocation.fromJson(Map<String, dynamic> json) => WorkLocation(
//     id: json["id"],
//     name: json["name"],
//     status: json["status"],
//     locationType: json["location_type"],
//     radius: json["radius"],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "id": id,
//     "name": name,
//     "status": status,
//     "location_type": locationType,
//     "radius": radius,
//   };
// }

// To parse this JSON data, do
//
//     final updateProfileResponseModel = updateProfileResponseModelFromJson(jsonString);

UpdateProfileResponseModel updateProfileResponseModelFromJson(String str) =>
    UpdateProfileResponseModel.fromJson(json.decode(str));

String updateProfileResponseModelToJson(UpdateProfileResponseModel data) =>
    json.encode(data.toJson());

class UpdateProfileResponseModel {
  int? status;
  String? message;
  ProfileData? data;

  UpdateProfileResponseModel({
    this.status,
    this.message,
    this.data,
  });

  factory UpdateProfileResponseModel.fromJson(Map<String, dynamic> json) =>
      UpdateProfileResponseModel(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null ? null : ProfileData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data?.toJson(),
      };
}

class UpdateProfileData {
  String? email;
  String? alternativePhone;
  String? whatsappPhone;

  UpdateProfileData({
    this.email,
    this.alternativePhone,
    this.whatsappPhone,
  });

  factory UpdateProfileData.fromJson(Map<String, dynamic> json) =>
      UpdateProfileData(
        email: json["email"],
        alternativePhone: json["alternative_phone"],
        whatsappPhone: json["whatsapp_phone"],
      );

  Map<String, dynamic> toJson() => {
        "email": email,
        "alternative_phone": alternativePhone,
        "whatsapp_phone": whatsappPhone,
      };
}

// To parse this JSON data, do
//
//     final profileImageModel = profileImageModelFromJson(jsonString);

ProfileImageModel profileImageModelFromJson(String str) =>
    ProfileImageModel.fromJson(json.decode(str));

String profileImageModelToJson(ProfileImageModel data) =>
    json.encode(data.toJson());

class ProfileImageModel {
  int? status;
  String? message;
  Data? data;

  ProfileImageModel({
    this.status,
    this.message,
    this.data,
  });

  factory ProfileImageModel.fromJson(Map<String, dynamic> json) =>
      ProfileImageModel(
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
  List<FileElement>? files;
  Rejection? rejection;
  String? documentType;
  String? status;
  bool? isVerified;
  bool? isValid;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? user;

  Data({
    this.id,
    this.files,
    this.rejection,
    this.documentType,
    this.status,
    this.isVerified,
    this.isValid,
    this.createdAt,
    this.updatedAt,
    this.user,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
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

  FileElement({
    this.id,
    this.file,
    this.document,
  });

  factory FileElement.fromJson(Map<String, dynamic> json) => FileElement(
        id: json["id"],
        file: json["file"],
        document: json["document"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "file": file,
        "document": document,
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
