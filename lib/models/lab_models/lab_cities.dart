import 'dart:convert';

class LabCity {
  String? id;
  String? name;

  LabCity({
    this.id,
    this.name,
  });
}

LabsAroundyouModel labsAroundyouModelFromJson(String str) =>
    LabsAroundyouModel.fromJson(json.decode(str));

String labsAroundyouModelToJson(LabsAroundyouModel data) =>
    json.encode(data.toJson());

class LabsAroundyouModel {
  LabsAroundyouModel({
    this.location,
    this.isApproved,
    this.labTestCategoryId,
    this.serviceType,
    this.status,
    this.id,
    this.vendorId,
    this.name,
    this.labEmail,
    this.labMobileNo,
    this.address,
    this.agreement,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.gstPercent,
    this.homeServicePercent,
    this.hplCommission,
    this.platformCostPercent,
    this.cityId,
    this.stateId,
    this.labsAroundyouModelId,
  });

  Location? location;
  bool? isApproved;
  List<Id>? labTestCategoryId;
  List<String>? serviceType;
  String? status;
  String? id;
  String? vendorId;
  String? name;
  String? labEmail;
  int? labMobileNo;
  String? address;
  String? agreement;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;
  int? gstPercent;
  int? homeServicePercent;
  int? hplCommission;
  int? platformCostPercent;
  Id? cityId;
  Id? stateId;
  String? labsAroundyouModelId;

  factory LabsAroundyouModel.fromJson(Map<String, dynamic> json) =>
      LabsAroundyouModel(
        location: Location.fromJson(json["location"]),
        isApproved: json["isApproved"],
        labTestCategoryId:
            List<Id>.from(json["labTestCategoryId"].map((x) => Id.fromJson(x))),
        serviceType: List<String>.from(json["serviceType"].map((x) => x)),
        status: json["status"],
        id: json["_id"],
        vendorId: json["vendorId"],
        name: json["name"],
        labEmail: json["labEmail"],
        labMobileNo: json["labMobileNo"],
        address: json["address"],
        agreement: json["agreement"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        v: json["__v"],
        gstPercent: json["gstPercent"],
        homeServicePercent: json["homeServicePercent"],
        hplCommission: json["hplCommission"],
        platformCostPercent: json["platformCostPercent"],
        cityId: Id.fromJson(json["cityId"]),
        stateId: Id.fromJson(json["stateId"]),
        labsAroundyouModelId: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "location": location!.toJson(),
        "isApproved": isApproved,
        "labTestCategoryId":
            List<dynamic>.from(labTestCategoryId!.map((x) => x.toJson())),
        "serviceType": List<dynamic>.from(serviceType!.map((x) => x)),
        "status": status,
        "_id": id,
        "vendorId": vendorId,
        "name": name,
        "labEmail": labEmail,
        "labMobileNo": labMobileNo,
        "address": address,
        "agreement": agreement,
        "created_at": createdAt!.toIso8601String(),
        "updated_at": updatedAt!.toIso8601String(),
        "__v": v,
        "gstPercent": gstPercent,
        "homeServicePercent": homeServicePercent,
        "hplCommission": hplCommission,
        "platformCostPercent": platformCostPercent,
        "cityId": cityId!.toJson(),
        "stateId": stateId!.toJson(),
        "id": labsAroundyouModelId,
      };
}

class Id {
  Id({
    this.id,
    this.name,
    this.country,
    this.idId,
    this.price,
  });

  String? id;
  String? name;
  String? country;
  String? idId;
  int? price;

  factory Id.fromJson(Map<String, dynamic> json) => Id(
        id: json["_id"],
        name: json["name"],
        country: json["country"],
        idId: json["id"],
        price: json["price"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "country": country,
        "id": idId,
      };
}

class Location {
  Location({
    this.type,
    this.coordinates,
  });

  String? type;
  List<double>? coordinates;

  factory Location.fromJson(Map<String, dynamic> json) => Location(
        type: json["type"],
        coordinates:
            List<double>.from(json["coordinates"].map((x) => x.toDouble())),
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        "coordinates": List<dynamic>.from(coordinates!.map((x) => x)),
      };
}
