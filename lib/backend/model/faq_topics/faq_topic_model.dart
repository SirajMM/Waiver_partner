// To parse this JSON data, do
//
//     final faqResponseModel = faqResponseModelFromJson(jsonString);

import 'dart:convert';

FaqResponseModel faqResponseModelFromJson(String str) =>
    FaqResponseModel.fromJson(json.decode(str));

String faqResponseModelToJson(FaqResponseModel data) =>
    json.encode(data.toJson());

class FaqResponseModel {
  int? status;
  String? message;
  List<FaqModel>? data;

  FaqResponseModel({
    this.status,
    this.message,
    this.data,
  });

  factory FaqResponseModel.fromJson(Map<String, dynamic> json) =>
      FaqResponseModel(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null
            ? []
            : List<FaqModel>.from(
                json["data"]!.map((x) => FaqModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class FaqModel {
  String? id;
  List<Faq>? faqs;
  String? title;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? category;

  FaqModel({
    this.id,
    this.faqs,
    this.title,
    this.createdAt,
    this.updatedAt,
    this.category,
  });

  factory FaqModel.fromJson(Map<String, dynamic> json) => FaqModel(
        id: json["id"],
        faqs: json["faqs"] == null
            ? []
            : List<Faq>.from(json["faqs"]!.map((x) => Faq.fromJson(x))),
        title: json["title"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        category: json["category"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "faqs": faqs == null
            ? []
            : List<dynamic>.from(faqs!.map((x) => x.toJson())),
        "title": title,
        "created_at":
            "${createdAt!.year.toString().padLeft(4, '0')}-${createdAt!.month.toString().padLeft(2, '0')}-${createdAt!.day.toString().padLeft(2, '0')}",
        "updated_at":
            "${updatedAt!.year.toString().padLeft(4, '0')}-${updatedAt!.month.toString().padLeft(2, '0')}-${updatedAt!.day.toString().padLeft(2, '0')}",
        "category": category,
      };
}

class Faq {
  String? id;
  String? question;
  String? answer;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? category;

  Faq({
    this.id,
    this.question,
    this.answer,
    this.createdAt,
    this.updatedAt,
    this.category,
  });

  factory Faq.fromJson(Map<String, dynamic> json) => Faq(
        id: json["id"],
        question: json["question"],
        answer: json["answer"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        category: json["category"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "question": question,
        "answer": answer,
        "created_at":
            "${createdAt!.year.toString().padLeft(4, '0')}-${createdAt!.month.toString().padLeft(2, '0')}-${createdAt!.day.toString().padLeft(2, '0')}",
        "updated_at":
            "${updatedAt!.year.toString().padLeft(4, '0')}-${updatedAt!.month.toString().padLeft(2, '0')}-${updatedAt!.day.toString().padLeft(2, '0')}",
        "category": category,
      };
}
