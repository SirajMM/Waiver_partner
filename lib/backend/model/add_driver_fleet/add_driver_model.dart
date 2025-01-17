class AddDriverResponseModel {
  int? status;
  String? message;
  Data? data;

  AddDriverResponseModel({this.status, this.message, this.data});

  AddDriverResponseModel.fromJson(Map<String, dynamic> json) {
    if (json["status"] is int) {
      status = json["status"];
    }
    if (json["message"] is String) {
      message = json["message"];
    }
    if (json["data"] is Map) {
      data = json["data"] == null ? null : Data.fromJson(json["data"]);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["status"] = status;
    _data["message"] = message;
    if (data != null) {
      _data["data"] = data?.toJson();
    }
    return _data;
  }
}

class Data {
  String? id;
  String? createdAt;
  String? updatedAt;
  String? vehicle;
  String? driver;

  Data({this.id, this.createdAt, this.updatedAt, this.vehicle, this.driver});

  Data.fromJson(Map<String, dynamic> json) {
    if (json["id"] is String) {
      id = json["id"];
    }
    if (json["created_at"] is String) {
      createdAt = json["created_at"];
    }
    if (json["updated_at"] is String) {
      updatedAt = json["updated_at"];
    }
    if (json["vehicle"] is String) {
      vehicle = json["vehicle"];
    }
    if (json["driver"] is String) {
      driver = json["driver"];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["id"] = id;
    _data["created_at"] = createdAt;
    _data["updated_at"] = updatedAt;
    _data["vehicle"] = vehicle;
    _data["driver"] = driver;
    return _data;
  }
}
