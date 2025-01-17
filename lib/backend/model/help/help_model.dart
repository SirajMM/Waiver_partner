// To parse this JSON data, do
//
//     final getHelpCategoriesResponseModel = getHelpCategoriesResponseModelFromJson(jsonString);

import 'dart:convert';

GetHelpCategoriesResponseModel getHelpCategoriesResponseModelFromJson(
        String str) =>
    GetHelpCategoriesResponseModel.fromJson(json.decode(str));

String getHelpCategoriesResponseModelToJson(
        GetHelpCategoriesResponseModel data) =>
    json.encode(data.toJson());

class GetHelpCategoriesResponseModel {
  int? status;
  String? message;
  List<HelpCategory>? data;

  GetHelpCategoriesResponseModel({
    this.status,
    this.message,
    this.data,
  });

  factory GetHelpCategoriesResponseModel.fromJson(Map<String, dynamic> json) =>
      GetHelpCategoriesResponseModel(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null
            ? []
            : List<HelpCategory>.from(
                json["data"]!.map((x) => HelpCategory.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class HelpCategory {
  String? id;
  String? title;
  String? content;
  String? icon;
  DateTime? createdAt;
  DateTime? updatedAt;

  HelpCategory({
    this.id,
    this.title,
    this.content,
    this.icon,
    this.createdAt,
    this.updatedAt,
  });

  factory HelpCategory.fromJson(Map<String, dynamic> json) => HelpCategory(
        id: json["id"],
        title: json["title"],
        content: json["content"],
        icon: json["icon"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "content": content,
        "icon": icon,
        "created_at":
            "${createdAt!.year.toString().padLeft(4, '0')}-${createdAt!.month.toString().padLeft(2, '0')}-${createdAt!.day.toString().padLeft(2, '0')}",
        "updated_at":
            "${updatedAt!.year.toString().padLeft(4, '0')}-${updatedAt!.month.toString().padLeft(2, '0')}-${updatedAt!.day.toString().padLeft(2, '0')}",
      };
}
