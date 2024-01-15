// To parse this JSON data, do
//
//     final callingList = callingListFromJson(jsonString);

import 'dart:convert';

List<ExerciseLogList> callingListFromJson(List data) =>
    List<ExerciseLogList>.from(data.map((x) => ExerciseLogList.fromJson(x)));

String exerciseLogListToJson(List<ExerciseLogList> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ExerciseLogList {
  ExerciseLogList({
    this.id,
    this.userId,
    this.exerciseId,
    this.weight,
    this.date,
    this.sets,
    this.totalCaloriesBurnt,
    this.durationInMinutes,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  String? id;
  String? userId;
  ExerciseId? exerciseId;
  String? weight;
  String? date;
  List<dynamic>? sets;
  double? totalCaloriesBurnt;
  String? durationInMinutes;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;

  factory ExerciseLogList.fromJson(Map<String, dynamic> json) =>
      ExerciseLogList(
        id: json["_id"],
        userId: json["userId"],
        exerciseId: json["exerciseId"] == null
            ? null
            : ExerciseId.fromJson(json["exerciseId"]),
        weight: json["weight"],
        date: json["date"],
        sets: json["sets"] == null
            ? []
            : List<dynamic>.from(json["sets"]!.map((x) => x)),
        totalCaloriesBurnt: double.parse(json["totalCaloriesBurnt"]),
        durationInMinutes: json["durationInMinutes"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "userId": userId,
        "exerciseId": exerciseId?.toJson(),
        "weight": weight,
        "date": date,
        "sets": sets == null ? [] : List<dynamic>.from(sets!.map((x) => x)),
        "totalCaloriesBurnt": totalCaloriesBurnt,
        "durationInMinutes": durationInMinutes,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "__v": v,
      };
}

class ExerciseId {
  ExerciseId({
    this.id,
    this.updatedAt,
    this.exerciseType,
    this.calorieFactor,
    this.name,
    this.weightUnit,
    this.bodyPartGroupId,
    this.bodyPartId,
  });

  String? id;
  DateTime? updatedAt;
  String? exerciseType;
  double? calorieFactor;
  String? name;
  String? weightUnit;
  List<BodyPartId>? bodyPartGroupId;
  List<BodyPartId>? bodyPartId;

  factory ExerciseId.fromJson(Map<String, dynamic> json) => ExerciseId(
        id: json["_id"],
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        exerciseType: json["exerciseType"],
        calorieFactor: json["calorieFactor"]?.toDouble(),
        name: json["name"],
        weightUnit: json["weightUnit"],
        bodyPartGroupId: json["bodyPartGroupId"] == null
            ? []
            : List<BodyPartId>.from(
                json["bodyPartGroupId"]!.map((x) => BodyPartId.fromJson(x))),
        bodyPartId: json["bodyPartId"] == null
            ? []
            : List<BodyPartId>.from(
                json["bodyPartId"]!.map((x) => BodyPartId.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "updated_at": updatedAt?.toIso8601String(),
        "exerciseType": exerciseType,
        "calorieFactor": calorieFactor,
        "name": name,
        "weightUnit": weightUnit,
        "bodyPartGroupId": bodyPartGroupId == null
            ? []
            : List<dynamic>.from(bodyPartGroupId!.map((x) => x.toJson())),
        "bodyPartId": bodyPartId == null
            ? []
            : List<dynamic>.from(bodyPartId!.map((x) => x.toJson())),
      };
}

class BodyPartId {
  BodyPartId({
    this.id,
    this.name,
  });

  String? id;
  String? name;

  factory BodyPartId.fromJson(Map<String, dynamic> json) => BodyPartId(
        id: json["_id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
      };
}
