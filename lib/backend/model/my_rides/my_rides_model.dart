// To parse this JSON data, do
//
//     final getRidesResponseModel = getRidesResponseModelFromJson(jsonString);

import 'dart:convert';

GetRidesResponseModel getRidesResponseModelFromJson(String str) =>
    GetRidesResponseModel.fromJson(json.decode(str));

String getRidesResponseModelToJson(GetRidesResponseModel data) =>
    json.encode(data.toJson());

class GetRidesResponseModel {
  int? status;
  String? message;
  RideData? data;

  GetRidesResponseModel({
    this.status,
    this.message,
    this.data,
  });

  factory GetRidesResponseModel.fromJson(Map<String, dynamic> json) =>
      GetRidesResponseModel(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null ? null : RideData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data?.toJson(),
      };
}

class RideData {
  int? count;
  String? next;
  String? previous;
  List<Ride>? results;

  RideData({
    this.count,
    this.next,
    this.previous,
    this.results,
  });

  factory RideData.fromJson(Map<String, dynamic> json) => RideData(
        count: json["count"],
        next: json["next"],
        previous: json["previous"],
        results: json["results"] == null
            ? []
            : List<Ride>.from(json["results"]!.map((x) => Ride.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "count": count,
        "next": next,
        "previous": previous,
        "results": results == null
            ? []
            : List<dynamic>.from(results!.map((x) => x.toJson())),
      };
}

class Ride {
  String? id;
  String? startLocationLat;
  String? startLocationLong;
  String? endLocationLat;
  String? endLocationLong;
  DateTime? startTime;
  DateTime? endTime;
  int? duration;
  String? distance;
  String? rideType;
  String? amount;
  String? endLocation;
  String? startLocation;
  bool? isPaid;
  DateTime?  paidTime;
  DateTime? created;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? driver;
  String? passenger;

  Ride({
    this.id,
    this.startLocationLat,
    this.startLocationLong,
    this.endLocationLat,
    this.endLocationLong,
    this.startTime,
    this.endTime,
    this.endLocation,
    this.startLocation,
    this.duration,
    this.distance,
    this.rideType,
    this.amount,
    this.isPaid,
    this.paidTime,
    this.created,
    this.createdAt,
    this.updatedAt,
    this.driver,
    this.passenger,
  });

  factory Ride.fromJson(Map<String, dynamic> json) => Ride(
        id: json["id"],
        startLocationLat: json["start_location_lat"],
        startLocationLong: json["start_location_long"],
        endLocationLat: json["end_location_lat"],
        startLocation: json["start_location"],
        endLocation: json["end_location"],
        endLocationLong: json["end_location_long"],
        startTime: json["start_time"] == null
            ? null
            : DateTime.parse(json["start_time"]),
        endTime:
            json["end_time"] == null ? null : DateTime.parse(json["end_time"]),
        duration: json["duration"],
        distance: json["distance"],
        rideType: json["ride_type"],
        amount: json["amount"],
        isPaid: json["is_paid"],
        paidTime: json["paid_time"] == null
            ? null
            : DateTime.parse(json["paid_time"]),
        created:
            json["created"] == null ? null : DateTime.parse(json["created"]),
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        driver: json["driver"],
        passenger: json["passenger"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "start_location_lat": startLocationLat,
        "start_location_long": startLocationLong,
        "end_location_lat": endLocationLat,
        "end_location_long": endLocationLong,
        "end_location": endLocation,
        "start_location": startLocation,
        "start_time": startTime?.toIso8601String(),
        "end_time": endTime?.toIso8601String(),
        "duration": duration,
        "distance": distance,
        "ride_type": rideType,
        "amount": amount,
        "is_paid": isPaid,
        "paid_time": paidTime?.toIso8601String(),
        "created": created?.toIso8601String(),
        "created_at":
            "${createdAt!.year.toString().padLeft(4, '0')}-${createdAt!.month.toString().padLeft(2, '0')}-${createdAt!.day.toString().padLeft(2, '0')}",
        "updated_at":
            "${updatedAt!.year.toString().padLeft(4, '0')}-${updatedAt!.month.toString().padLeft(2, '0')}-${updatedAt!.day.toString().padLeft(2, '0')}",
        "driver": driver,
        "passenger": passenger,
      };
}

class MyRidesModel {
  String km;
  String time;
  String earnings;
  DateTime rideStart;
  List<String> stops;
  MyRidesModel({
    required this.km,
    required this.time,
    required this.earnings,
    required this.rideStart,
    required this.stops,
  });
}
