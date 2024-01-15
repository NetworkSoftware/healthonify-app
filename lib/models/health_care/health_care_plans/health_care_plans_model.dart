import 'dart:convert';

HealthCarePlansModel healthCarePlansModelFromJson(String str) =>
    HealthCarePlansModel.fromJson(json.decode(str));

String healthCarePlansModelToJson(HealthCarePlansModel data) =>
    json.encode(data.toJson());

class HealthCarePlansModel {
  HealthCarePlansModel({
    this.id,
    this.bodyPart,
    this.healthCondition,
    this.name,
    this.description,
    this.benefits,
    this.price,
    this.sessionCount,
    this.flow,
    this.isActive,
    this.expertiseId,
    this.durationInDays,
    this.services,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.mediaLink
  });

  String? id;
  List<dynamic>? bodyPart;
  List<dynamic>? healthCondition;
  String? name;
  String? description;
  String? benefits;
  String? price;
  String? sessionCount;
  String? flow;
  String? mediaLink;
  bool? isActive;
  ExpertiseId? expertiseId;
  int? durationInDays;
  List<Service>? services;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;

  factory HealthCarePlansModel.fromJson(Map<String, dynamic> json) =>
      HealthCarePlansModel(
        id: json["_id"],
        bodyPart: List<dynamic>.from(json["bodyPart"].map((x) => x)),
        healthCondition:
            List<dynamic>.from(json["healthCondition"].map((x) => x)),
        name: json["name"],
        description: json["description"],
        benefits: json["benefits"],
        price: json["price"],
        sessionCount: json["sessionCount"],
        flow: json["flow"],
        mediaLink: json["mediaLink"],
        isActive: json["isActive"],
        expertiseId: json["expertiseId"],
        durationInDays: json["durationInDays"],
        services: List<Service>.from(
            json["services"].map((x) => Service.fromJson(x))),
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "bodyPart": List<dynamic>.from(bodyPart!.map((x) => x)),
        "healthCondition": List<dynamic>.from(healthCondition!.map((x) => x)),
        "name": name,
        "description": description,
        "benefits": benefits,
        "price": price,
        "sessionCount": sessionCount,
        "flow": flow,
        "mediaLink": mediaLink,
        "isActive": isActive,
        "expertiseId": expertiseId,
        "durationInDays": durationInDays,
        "services": List<dynamic>.from(services!.map((x) => x.toJson())),
        "created_at": createdAt!.toIso8601String(),
        "updated_at": updatedAt!.toIso8601String(),
        "__v": v,
      };
}

class Service {
  Service({
    this.id,
    this.serviceName,
    this.count,
    this.mode,
  });

  String? id;
  String? serviceName;
  int? count;
  String? mode;

  factory Service.fromJson(Map<String, dynamic> json) => Service(
        id: json["_id"],
        serviceName: json["serviceName"],
        count: json["count"],
        mode: json["mode"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "serviceName": serviceName,
        "count": count,
        "mode": mode,
      };
}


class ExpertiseId {
  String? sId;
  String? name;
  String? parentExpertiseId;
  String? createdAt;
  String? updatedAt;
  int? iV;

  ExpertiseId(
      {this.sId,
        this.name,
        this.parentExpertiseId,
        this.createdAt,
        this.updatedAt,
        this.iV});

  ExpertiseId.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    parentExpertiseId = json['parentExpertiseId'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['name'] = name;
    data['parentExpertiseId'] = parentExpertiseId;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['__v'] = iV;
    return data;
  }
}