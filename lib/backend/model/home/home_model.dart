import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class DashBoardItemModel {
  Widget icon;
  String value;
  String text;
  DashBoardItemModel({
    required this.icon,
    required this.value,
    required this.text,
  });
}

// To parse this JSON data, do
//
//     final getRideDetailsResponseModel = getRideDetailsResponseModelFromJson(jsonString);

GetRideDetailsResponseModel getRideDetailsResponseModelFromJson(String str) =>
    GetRideDetailsResponseModel.fromJson(json.decode(str));

String getRideDetailsResponseModelToJson(GetRideDetailsResponseModel data) =>
    json.encode(data.toJson());

class GetRideDetailsResponseModel {
  int? status;
  String? message;
  OrderDetails? data;

  GetRideDetailsResponseModel({
    this.status,
    this.message,
    this.data,
  });

  factory GetRideDetailsResponseModel.fromJson(Map<String, dynamic> json) =>
      GetRideDetailsResponseModel(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null ? null : OrderDetails.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data?.toJson(),
      };
}

class OrderDetails {
  String? id;
  String? startLocation;
  String? endLocation;
  String? startLocationLat;
  String? startLocationLong;
  String? endLocationLat;
  String? endLocationLong;
  DateTime? startTime;
  double? customerRating;
  dynamic endTime;
  int? duration;
  String? distance;
  String? rideStatus;
  String? rideType;
  String? amount;
  bool? isPaid;
  dynamic paidTime;
  dynamic created;
  DateTime? createdAt;
  DateTime? updatedAt;
  dynamic driver;
  String? passengerPhone;
  String? passenger;
  String? passengerName;
  dynamic userVehicle;

  OrderDetails({
    this.id,
    this.startLocation,
    this.customerRating,
    this.passengerName,
    this.endLocation,
    this.startLocationLat,
    this.startLocationLong,
    this.endLocationLat,
    this.endLocationLong,
    this.startTime,
    this.endTime,
    this.duration,
    this.distance,
    this.rideStatus,
    this.rideType,
    this.amount,
    this.isPaid,
    this.paidTime,
    this.created,
    this.createdAt,
    this.updatedAt,
    this.driver,
    this.passenger,
    this.passengerPhone,
    this.userVehicle,
  });

  factory OrderDetails.fromJson(Map<String, dynamic> json) => OrderDetails(
        id: json["id"],
        startLocation: json["start_location"],
        endLocation: json["end_location"],
        startLocationLat: json["start_location_lat"],
        startLocationLong: json["start_location_long"],
        endLocationLat: json["end_location_lat"],
        customerRating: json["customer_rating"],
        passengerName: json["passenger_name"],
        endLocationLong: json["end_location_long"],
        passengerPhone: json["passenger_phone"],
        startTime: json["start_time"] == null
            ? null
            : DateTime.parse(json["start_time"]),
        endTime: json["end_time"],
        duration: json["duration"],
        distance: json["distance"],
        rideStatus: json["ride_status"],
        rideType: json["ride_type"],
        amount: json["amount"],
        isPaid: json["is_paid"],
        paidTime: json["paid_time"],
        created: json["created"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        driver: json["driver"],
        passenger: json["passenger"],
        userVehicle: json["user_vehicle"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "start_location": startLocation,
        "end_location": endLocation,
        "start_location_lat": startLocationLat,
        "start_location_long": startLocationLong,
        "end_location_lat": endLocationLat,
        "customer_rating": customerRating,
        "end_location_long": endLocationLong,
        "passenger_name": passengerName,
        "passenger_phone": passengerPhone,
        "start_time": startTime?.toIso8601String(),
        "end_time": endTime,
        "duration": duration,
        "distance": distance,
        "ride_status": rideStatus,
        "ride_type": rideType,
        "amount": amount,
        "is_paid": isPaid,
        "paid_time": paidTime,
        "created": created,
        "created_at":
            "${createdAt!.year.toString().padLeft(4, '0')}-${createdAt!.month.toString().padLeft(2, '0')}-${createdAt!.day.toString().padLeft(2, '0')}",
        "updated_at":
            "${updatedAt!.year.toString().padLeft(4, '0')}-${updatedAt!.month.toString().padLeft(2, '0')}-${updatedAt!.day.toString().padLeft(2, '0')}",
        "driver": driver,
        "passenger": passenger,
        "user_vehicle": userVehicle,
      };
}

// To parse this JSON data, do
//
//     final orderDetailsModel = orderDetailsModelFromJson(jsonString);

OrderDetailsModel orderDetailsModelFromJson(String str) =>
    OrderDetailsModel.fromJson(json.decode(str));

String orderDetailsModelToJson(OrderDetailsModel data) =>
    json.encode(data.toJson());

class OrderDetailsModel {
  String? startLocLat;
  String? title;
  String? body;
  String? rideId;
  String? endLocLat;
  String? endLoc;
  String? passengerId;
  String? startLoc;
  DateTime? bookingTime;
  String? startLocLong;
  String? endLocLong;
  String? rideStatus;
  String? paymentType;

  OrderDetailsModel(
      {this.startLocLat,
      this.title,
      this.body,
      this.rideId,
      this.endLocLat,
      this.endLoc,
      this.rideStatus,
      this.passengerId,
      this.startLoc,
      this.bookingTime,
      this.startLocLong,
      this.endLocLong,
      this.paymentType});

  // factory OrderDetailsModel.fromJson(Map<String, dynamic> json) =>
  //     OrderDetailsModel(
  //       startLocLat: json["start_loc_lat"],
  //       rideId: json["ride_id"],
  //       endLocLat: json["end_loc_lat"],
  //       rideStatus: json["ride_status"],
  //       endLoc: json["end_loc"],
  //       passengerId: json["passenger_id"],
  //       startLoc: json["start_loc"],
  //       bookingTime: json["booking_time"] == null
  //           ? null
  //           : DateTime.parse(json["booking_time"]),
  //       startLocLong: json["start_loc_long"],
  //       endLocLong: json["end_loc_long"],
  //       paymentType: json["payment_type"],
  //     );

  factory OrderDetailsModel.fromJson(Map<String, dynamic> json) {
    return OrderDetailsModel(
      startLocLat: json["start_loc_lat"] ?? "0.0", // Default value if null
      rideId: json["ride_id"] ?? "", // Default value for a string
      endLocLat: json["end_loc_lat"] ?? "0.0",
      rideStatus: json["ride_status"] ?? "",
      endLoc: json["end_loc"] ?? "",
      passengerId: json["passenger_id"] ?? "",
      startLoc: json["start_loc"] ?? "",
      bookingTime: json["booking_time"] == null
          ? null
          : DateTime.tryParse(json["booking_time"]) ??
              null, // Handle invalid date strings gracefully
      startLocLong: json["start_loc_long"] ?? "0.0",
      endLocLong: json["end_loc_long"] ?? "0.0",
      paymentType: json["payment_type"] ?? "",
      title: json["title"] ?? "",
      body: json["body"] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
        "start_loc_lat": startLocLat,
        "ride_id": rideId,
        "end_loc_lat": endLocLat,
        "end_loc": endLoc,
        "ride_status": rideStatus,
        "passenger_id": passengerId,
        "start_loc": startLoc,
        "booking_time": bookingTime?.toIso8601String(),
        "start_loc_long": startLocLong,
        "end_loc_long": endLocLong,
        "payment_type": paymentType,
        "title": title,
        "body": body,
      };
}

// To parse this JSON data, do
//
//     final changeRideStatus = changeRideStatusFromJson(jsonString);

ChangeRideStatusModel changeRideStatusFromJson(String str) =>
    ChangeRideStatusModel.fromJson(json.decode(str));

String changeRideStatusToJson(ChangeRideStatusModel data) =>
    json.encode(data.toJson());

class ChangeRideStatusModel {
  int? status;
  String? message;
  Data? data;

  ChangeRideStatusModel({
    this.status,
    this.message,
    this.data,
  });

  factory ChangeRideStatusModel.fromJson(Map<String, dynamic> json) =>
      ChangeRideStatusModel(
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
  Data();

  factory Data.fromJson(Map<String, dynamic> json) => Data();

  Map<String, dynamic> toJson() => {};
}

// To parse this JSON data, do
//
//     final getOnlineStatusResponseModel = getOnlineStatusResponseModelFromJson(jsonString);

GetOnlineStatusResponseModel getOnlineStatusResponseModelFromJson(String str) =>
    GetOnlineStatusResponseModel.fromJson(json.decode(str));

String getOnlineStatusResponseModelToJson(GetOnlineStatusResponseModel data) =>
    json.encode(data.toJson());

class GetOnlineStatusResponseModel {
  int? status;
  String? message;
  DriverOnlineStatus? data;

  GetOnlineStatusResponseModel({
    this.status,
    this.message,
    this.data,
  });

  factory GetOnlineStatusResponseModel.fromJson(Map<String, dynamic> json) =>
      GetOnlineStatusResponseModel(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null
            ? null
            : DriverOnlineStatus.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data?.toJson(),
      };
}

class DriverOnlineStatus {
  bool? isOnline;

  DriverOnlineStatus({
    this.isOnline,
  });

  factory DriverOnlineStatus.fromJson(Map<String, dynamic> json) =>
      DriverOnlineStatus(
        isOnline: json["is_online"],
      );

  Map<String, dynamic> toJson() => {
        "is_online": isOnline,
      };
}

GoogleLocationResponse googleLocationResponseFromJson(String str) =>
    GoogleLocationResponse.fromJson(json.decode(str));

String googleLocationResponseToJson(GoogleLocationResponse data) =>
    json.encode(data.toJson());

class GoogleLocationResponse {
  PlusCode? plusCode;
  List<Result>? results;
  String? status;

  GoogleLocationResponse({
    this.plusCode,
    this.results,
    this.status,
  });

  factory GoogleLocationResponse.fromJson(Map<String, dynamic> json) =>
      GoogleLocationResponse(
        plusCode: json["plus_code"] == null
            ? null
            : PlusCode.fromJson(json["plus_code"]),
        results: json["results"] == null
            ? []
            : List<Result>.from(
                json["results"]!.map((x) => Result.fromJson(x))),
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "plus_code": plusCode?.toJson(),
        "results": results == null
            ? []
            : List<dynamic>.from(results!.map((x) => x.toJson())),
        "status": status,
      };
}

class PlusCode {
  String? compoundCode;
  String? globalCode;

  PlusCode({
    this.compoundCode,
    this.globalCode,
  });

  factory PlusCode.fromJson(Map<String, dynamic> json) => PlusCode(
        compoundCode: json["compound_code"],
        globalCode: json["global_code"],
      );

  Map<String, dynamic> toJson() => {
        "compound_code": compoundCode,
        "global_code": globalCode,
      };
}

class Result {
  List<AddressComponent>? addressComponents;
  String? formattedAddress;
  Geometry? geometry;
  String? placeId;
  PlusCode? plusCode;
  List<String>? types;

  Result({
    this.addressComponents,
    this.formattedAddress,
    this.geometry,
    this.placeId,
    this.plusCode,
    this.types,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        addressComponents: json["address_components"] == null
            ? []
            : List<AddressComponent>.from(json["address_components"]!
                .map((x) => AddressComponent.fromJson(x))),
        formattedAddress: json["formatted_address"],
        geometry: json["geometry"] == null
            ? null
            : Geometry.fromJson(json["geometry"]),
        placeId: json["place_id"],
        plusCode: json["plus_code"] == null
            ? null
            : PlusCode.fromJson(json["plus_code"]),
        types: json["types"] == null
            ? []
            : List<String>.from(json["types"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "address_components": addressComponents == null
            ? []
            : List<dynamic>.from(addressComponents!.map((x) => x.toJson())),
        "formatted_address": formattedAddress,
        "geometry": geometry?.toJson(),
        "place_id": placeId,
        "plus_code": plusCode?.toJson(),
        "types": types == null ? [] : List<dynamic>.from(types!.map((x) => x)),
      };
}

class AddressComponent {
  String? longName;
  String? shortName;
  List<String>? types;

  AddressComponent({
    this.longName,
    this.shortName,
    this.types,
  });

  factory AddressComponent.fromJson(Map<String, dynamic> json) =>
      AddressComponent(
        longName: json["long_name"],
        shortName: json["short_name"],
        types: json["types"] == null
            ? []
            : List<String>.from(json["types"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "long_name": longName,
        "short_name": shortName,
        "types": types == null ? [] : List<dynamic>.from(types!.map((x) => x)),
      };
}

class Geometry {
  Location? location;
  LocationType? locationType;
  Bounds? viewport;
  Bounds? bounds;

  Geometry({
    this.location,
    this.locationType,
    this.viewport,
    this.bounds,
  });

  factory Geometry.fromJson(Map<String, dynamic> json) => Geometry(
        location: json["location"] == null
            ? null
            : Location.fromJson(json["location"]),
        locationType: locationTypeValues.map[json["location_type"]],
        viewport:
            json["viewport"] == null ? null : Bounds.fromJson(json["viewport"]),
        bounds: json["bounds"] == null ? null : Bounds.fromJson(json["bounds"]),
      );

  Map<String, dynamic> toJson() => {
        "location": location?.toJson(),
        "location_type": locationTypeValues.reverse[locationType],
        "viewport": viewport?.toJson(),
        "bounds": bounds?.toJson(),
      };
}

class Bounds {
  Location? northeast;
  Location? southwest;

  Bounds({
    this.northeast,
    this.southwest,
  });

  factory Bounds.fromJson(Map<String, dynamic> json) => Bounds(
        northeast: json["northeast"] == null
            ? null
            : Location.fromJson(json["northeast"]),
        southwest: json["southwest"] == null
            ? null
            : Location.fromJson(json["southwest"]),
      );

  Map<String, dynamic> toJson() => {
        "northeast": northeast?.toJson(),
        "southwest": southwest?.toJson(),
      };
}

class Location {
  double? lat;
  double? lng;

  Location({
    this.lat,
    this.lng,
  });

  factory Location.fromJson(Map<String, dynamic> json) => Location(
        lat: json["lat"]?.toDouble(),
        lng: json["lng"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "lat": lat,
        "lng": lng,
      };
}

enum LocationType { APPROXIMATE, GEOMETRIC_CENTER }

final locationTypeValues = EnumValues({
  "APPROXIMATE": LocationType.APPROXIMATE,
  "GEOMETRIC_CENTER": LocationType.GEOMETRIC_CENTER
});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}

PaymentSuccessModel paymentSuccessModelFromJson(String str) =>
    PaymentSuccessModel.fromJson(json.decode(str));

String paymentSuccessModelToJson(PaymentSuccessModel data) =>
    json.encode(data.toJson());

class PaymentSuccessModel {
  int? status;
  String? message;
  PaymentSuccessData? data;

  PaymentSuccessModel({
    this.status,
    this.message,
    this.data,
  });

  factory PaymentSuccessModel.fromJson(Map<String, dynamic> json) =>
      PaymentSuccessModel(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null
            ? null
            : PaymentSuccessData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data?.toJson(),
      };
}

class PaymentSuccessData {
  PaymentSuccessData();

  factory PaymentSuccessData.fromJson(Map<String, dynamic> json) =>
      PaymentSuccessData();

  Map<String, dynamic> toJson() => {};
}

// To parse this JSON data, do
//
//     final ridePaymentResponseModel = ridePaymentResponseModelFromJson(jsonString);

RidePaymentResponseModel ridePaymentResponseModelFromJson(String str) =>
    RidePaymentResponseModel.fromJson(json.decode(str));

String ridePaymentResponseModelToJson(RidePaymentResponseModel data) =>
    json.encode(data.toJson());

class RidePaymentResponseModel {
  int? status;
  String? message;
  RidePaymentData? data;

  RidePaymentResponseModel({
    this.status,
    this.message,
    this.data,
  });

  factory RidePaymentResponseModel.fromJson(Map<String, dynamic> json) =>
      RidePaymentResponseModel(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null
            ? null
            : RidePaymentData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data?.toJson(),
      };
}

class RidePaymentData {
  String? id;
  String? razorpayOrderId;
  String? fare;
  String? tip;
  String? promo;
  String? tax;
  String? total;
  String? waiverCharge;
  String? status;
  String? paymentType;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? ride;

  RidePaymentData({
    this.id,
    this.razorpayOrderId,
    this.fare,
    this.tip,
    this.promo,
    this.tax,
    this.total,
    this.waiverCharge,
    this.status,
    this.paymentType,
    this.createdAt,
    this.updatedAt,
    this.ride,
  });

  factory RidePaymentData.fromJson(Map<String, dynamic> json) =>
      RidePaymentData(
        id: json["id"],
        razorpayOrderId: json["razorpay_order_id"],
        fare: json["fare"],
        tip: json["tip"],
        promo: json["promo"],
        tax: json["tax"],
        total: json["total"],
        waiverCharge: json["waiver_charge"],
        status: json["status"],
        paymentType: json["payment_type"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        ride: json["ride"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "razorpay_order_id": razorpayOrderId,
        "fare": fare,
        "tip": tip,
        "promo": promo,
        "tax": tax,
        "total": total,
        "waiver_charge": waiverCharge,
        "status": status,
        "payment_type": paymentType,
        "created_at":
            "${createdAt!.year.toString().padLeft(4, '0')}-${createdAt!.month.toString().padLeft(2, '0')}-${createdAt!.day.toString().padLeft(2, '0')}",
        "updated_at":
            "${updatedAt!.year.toString().padLeft(4, '0')}-${updatedAt!.month.toString().padLeft(2, '0')}-${updatedAt!.day.toString().padLeft(2, '0')}",
        "ride": ride,
      };
}

AddStopResponseModel addStopResponseModelFromJson(String str) =>
    AddStopResponseModel.fromJson(json.decode(str));

String addStopResponseModelToJson(AddStopResponseModel data) =>
    json.encode(data.toJson());

class AddStopResponseModel {
  int? status;
  String? message;
  AddStopResponseModelData? data;

  AddStopResponseModel({
    this.status,
    this.message,
    this.data,
  });

  factory AddStopResponseModel.fromJson(Map<String, dynamic> json) =>
      AddStopResponseModel(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null
            ? null
            : AddStopResponseModelData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data?.toJson(),
      };
}

class AddStopResponseModelData {
  AddStopResponseModelData();

  factory AddStopResponseModelData.fromJson(Map<String, dynamic> json) =>
      AddStopResponseModelData();

  Map<String, dynamic> toJson() => {};
}

class TripsLocations {
  Rx<String?> name;
  Rx<double?> latitude;
  Rx<double?> longitude;

  TripsLocations({
    required this.name,
    required this.latitude,
    required this.longitude,
  });
}
