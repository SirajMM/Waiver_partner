// To parse this JSON data, do
//
//     final getReviewStatusResponseModel = getReviewStatusResponseModelFromJson(jsonString);

import 'dart:convert';

GetReviewStatusResponseModel getReviewStatusResponseModelFromJson(String str) =>
    GetReviewStatusResponseModel.fromJson(json.decode(str));

String getReviewStatusResponseModelToJson(GetReviewStatusResponseModel data) =>
    json.encode(data.toJson());

class GetReviewStatusResponseModel {
  int? status;
  String? message;
  ReviewData? data;

  GetReviewStatusResponseModel({
    this.status,
    this.message,
    this.data,
  });

  factory GetReviewStatusResponseModel.fromJson(Map<String, dynamic> json) =>
      GetReviewStatusResponseModel(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null ? null : ReviewData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data?.toJson(),
      };
}

class ReviewData {
  double? rating;
  double? acceptance;
  double? cancellation;

  ReviewData({
    this.rating,
    this.acceptance,
    this.cancellation,
  });

  factory ReviewData.fromJson(Map<String, dynamic> json) => ReviewData(
        rating: json["rating"],
        acceptance: json["acceptance"],
        cancellation: json["cancellation"],
      );

  Map<String, dynamic> toJson() => {
        "rating": rating,
        "acceptance": acceptance,
        "cancellation": cancellation,
      };
}

class RatingItemsModel {
  int starRating;
  String review;
  DateTime date;
  RatingItemsModel({
    required this.date,
    required this.review,
    required this.starRating,
  });
}

// To parse this JSON data, do
//
//     final getReviewResponseModel = getReviewResponseModelFromJson(jsonString);

GetReviewResponseModel getReviewResponseModelFromJson(String str) =>
    GetReviewResponseModel.fromJson(json.decode(str));

String getReviewResponseModelToJson(GetReviewResponseModel data) =>
    json.encode(data.toJson());

class GetReviewResponseModel {
  int? status;
  String? message;
  ReviewItemData? data;

  GetReviewResponseModel({
    this.status,
    this.message,
    this.data,
  });

  factory GetReviewResponseModel.fromJson(Map<String, dynamic> json) =>
      GetReviewResponseModel(
        status: json["status"],
        message: json["message"],
        data:
            json["data"] == null ? null : ReviewItemData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data?.toJson(),
      };
}

class ReviewItemData {
  int? count;
  bool? next;
  bool? previous;
  List<ReviewModel>? results;

  ReviewItemData({
    this.count,
    this.next,
    this.previous,
    this.results,
  });

  factory ReviewItemData.fromJson(Map<String, dynamic> json) => ReviewItemData(
        count: json["count"],
        next: json["next"],
        previous: json["previous"],
        results: json["results"] == null
            ? []
            : List<ReviewModel>.from(
                json["results"]!.map((x) => ReviewModel.fromJson(x))),
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

class ReviewModel {
  String? id;
  String? review;
  int? rating;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? driver;
  String? passenger;
  String? ride;

  ReviewModel({
    this.id,
    this.review,
    this.rating,
    this.createdAt,
    this.updatedAt,
    this.driver,
    this.passenger,
    this.ride,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) => ReviewModel(
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
