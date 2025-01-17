// To parse this JSON data, do
//
//     final getNotificationsResponseModel = getNotificationsResponseModelFromJson(jsonString);

import 'dart:convert';

GetNotificationsResponseModel getNotificationsResponseModelFromJson(
        String str) =>
    GetNotificationsResponseModel.fromJson(json.decode(str));

String getNotificationsResponseModelToJson(
        GetNotificationsResponseModel data) =>
    json.encode(data.toJson());

class GetNotificationsResponseModel {
  int? status;
  String? message;
  Data? data;

  GetNotificationsResponseModel({
    this.status,
    this.message,
    this.data,
  });

  factory GetNotificationsResponseModel.fromJson(Map<String, dynamic> json) =>
      GetNotificationsResponseModel(
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
  int? count;
  bool? next;
  bool? previous;
  List<NotificationModel>? results;

  Data({
    this.count,
    this.next,
    this.previous,
    this.results,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        count: json["count"],
        next: json["next"],
        previous: json["previous"],
        results: json["results"] == null
            ? []
            : List<NotificationModel>.from(
                json["results"]!.map((x) => NotificationModel.fromJson(x))),
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

class NotificationModel {
  String? id;
  String? title;
  String? content;
  DateTime? sendTime;
  String? notificationType;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? user;

  NotificationModel({
    this.id,
    this.title,
    this.content,
    this.sendTime,
    this.notificationType,
    this.createdAt,
    this.updatedAt,
    this.user,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      NotificationModel(
        id: json["id"],
        title: json["title"],
        content: json["content"],
        sendTime: json["send_time"] == null
            ? null
            : DateTime.parse(json["send_time"]),
        notificationType: json["notification_type"],
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
        "title": title,
        "content": content,
        "send_time": sendTime?.toIso8601String(),
        "notification_type": notificationType,
        "created_at":
            "${createdAt!.year.toString().padLeft(4, '0')}-${createdAt!.month.toString().padLeft(2, '0')}-${createdAt!.day.toString().padLeft(2, '0')}",
        "updated_at":
            "${updatedAt!.year.toString().padLeft(4, '0')}-${updatedAt!.month.toString().padLeft(2, '0')}-${updatedAt!.day.toString().padLeft(2, '0')}",
        "user": user,
      };
}
