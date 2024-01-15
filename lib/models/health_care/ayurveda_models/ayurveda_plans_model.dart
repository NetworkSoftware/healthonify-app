import 'dart:convert';

List<AyurvedaPlansModel> ayurvedaPlansFromJson(List str) => List<AyurvedaPlansModel>.from(str.map((x) => AyurvedaPlansModel.fromJson(x)));

String ayurvedaPlansToJson(List<AyurvedaPlansModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class AyurvedaPlansModel {
    AyurvedaPlansModel({
        this.id,
        this.name,
        this.v,
        this.conditionId,
        this.createdAt,
        this.description,
        this.included,
        this.isActive,
        this.mediaLink,
        this.price,
        this.sessionsCount,
        this.updatedAt,
        this.validityInDays,
    });

    String? id;
    String? name;
    int? v;
    String? conditionId;
    DateTime? createdAt;
    String? description;
    List<String>? included;
    bool? isActive;
    String? mediaLink;
    int? price;
    int? sessionsCount;
    DateTime? updatedAt;
    int? validityInDays;

    factory AyurvedaPlansModel.fromJson(Map<String, dynamic> json) => AyurvedaPlansModel(
        id: json["_id"],
        name: json["name"],
        v: json["__v"],
        conditionId: json["conditionId"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        description: json["description"],
        included: json["included"] == null ? [] : List<String>.from(json["included"]!.map((x) => x)),
        isActive: json["isActive"],
        mediaLink: json["mediaLink"],
        price: json["price"],
        sessionsCount: json["sessionsCount"],
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
        validityInDays: json["validityInDays"],
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "__v": v,
        "conditionId": conditionId,
        "created_at": createdAt?.toIso8601String(),
        "description": description,
        "included": included == null ? [] : List<dynamic>.from(included!.map((x) => x)),
        "isActive": isActive,
        "mediaLink": mediaLink,
        "price": price,
        "sessionsCount": sessionsCount,
        "updated_at": updatedAt?.toIso8601String(),
        "validityInDays": validityInDays,
    };
}
