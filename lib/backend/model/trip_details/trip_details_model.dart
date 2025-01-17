// To parse this JSON data, do
//
//     final getRidesDetailsResponseModel = getRidesDetailsResponseModelFromJson(jsonString);

import 'dart:convert';

GetRidesDetailsResponseModel getRidesDetailsResponseModelFromJson(String str) =>
    GetRidesDetailsResponseModel.fromJson(json.decode(str));

String getRidesDetailsResponseModelToJson(GetRidesDetailsResponseModel data) =>
    json.encode(data.toJson());

class GetRidesDetailsResponseModel {
  int? status;
  String? message;
  Data? data;

  GetRidesDetailsResponseModel({
    this.status,
    this.message,
    this.data,
  });

  factory GetRidesDetailsResponseModel.fromJson(Map<String, dynamic> json) =>
      GetRidesDetailsResponseModel(
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
  Review? review;
  Payment? payment;
  String? startLocationLat;
  String? startLocationLong;
  String? endLocationLat;
  String? endLocationLong;
  DateTime? startTime;
  DateTime? endTime;
  String? duration;
  String? distance;
  String? rideType;
  String? amount;
  bool? isPaid;
  DateTime? paidTime;
  DateTime? created;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? driver;
  String? passenger;

  Data({
    this.id,
    this.review,
    this.payment,
    this.startLocationLat,
    this.startLocationLong,
    this.endLocationLat,
    this.endLocationLong,
    this.startTime,
    this.endTime,
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

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        review: json["review"] == null ? null : Review.fromJson(json["review"]),
        payment:
            json["payment"] == null ? null : Payment.fromJson(json["payment"]),
        startLocationLat: json["start_location_lat"],
        startLocationLong: json["start_location_long"],
        endLocationLat: json["end_location_lat"],
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
        "review": review?.toJson(),
        "payment": payment?.toJson(),
        "start_location_lat": startLocationLat,
        "start_location_long": startLocationLong,
        "end_location_lat": endLocationLat,
        "end_location_long": endLocationLong,
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

class Payment {
  String? id;
  String? fare;
  String? promo;
  String? tax;
  String? total;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? ride;

  Payment({
    this.id,
    this.fare,
    this.promo,
    this.tax,
    this.total,
    this.createdAt,
    this.updatedAt,
    this.ride,
  });

  factory Payment.fromJson(Map<String, dynamic> json) => Payment(
        id: json["id"],
        fare: json["fare"],
        promo: json["promo"],
        tax: json["tax"],
        total: json["total"],
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
        "fare": fare,
        "promo": promo,
        "tax": tax,
        "total": total,
        "created_at":
            "${createdAt!.year.toString().padLeft(4, '0')}-${createdAt!.month.toString().padLeft(2, '0')}-${createdAt!.day.toString().padLeft(2, '0')}",
        "updated_at":
            "${updatedAt!.year.toString().padLeft(4, '0')}-${updatedAt!.month.toString().padLeft(2, '0')}-${updatedAt!.day.toString().padLeft(2, '0')}",
        "ride": ride,
      };
}

class Review {
  String? id;
  String? review;
  int? rating;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? driver;
  String? passenger;
  String? ride;

  Review({
    this.id,
    this.review,
    this.rating,
    this.createdAt,
    this.updatedAt,
    this.driver,
    this.passenger,
    this.ride,
  });

  factory Review.fromJson(Map<String, dynamic> json) => Review(
        id: json["id"],
        review: json["review"],
        rating: json["rating"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        driver: json["driver"],
        passenger: json["passenger"],
        ride: json["ride"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "review": review,
        "rating": rating,
        "created_at":
            "${createdAt!.year.toString().padLeft(4, '0')}-${createdAt!.month.toString().padLeft(2, '0')}-${createdAt!.day.toString().padLeft(2, '0')}",
        "updated_at":
            "${updatedAt!.year.toString().padLeft(4, '0')}-${updatedAt!.month.toString().padLeft(2, '0')}-${updatedAt!.day.toString().padLeft(2, '0')}",
        "driver": driver,
        "passenger": passenger,
        "ride": ride,
      };
}
