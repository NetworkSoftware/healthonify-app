import 'dart:convert';

import 'package:healthonify_mobile/models/womens_special_models/ws_flow_intensity_model.dart';

List<PeriodLogsModel> periodLogsFromJson(String str) =>
    List<PeriodLogsModel>.from(
        json.decode(str).map((x) => PeriodLogsModel.fromJson(x)));

String periodLogsToJson(List<PeriodLogsModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class PeriodLogsModel {
  PeriodLogsModel({
    required this.id,
    required this.flowIntensity,
    required this.moods,
    required this.symptoms,
    required this.userId,
    required this.menustralDate,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  String id;
  List<WSLogModel> flowIntensity;
  List<WSLogModel> moods;
  List<WSLogModel> symptoms;
  String userId;
  DateTime menustralDate;
  DateTime createdAt;
  DateTime updatedAt;
  int v;

  factory PeriodLogsModel.fromJson(Map<String, dynamic> json) =>
      PeriodLogsModel(
        id: json["_id"],
        flowIntensity: List<WSLogModel>.from(
            json["flowIntensity"].map((x) => WSLogModel.fromJson(x))),
        moods: List<WSLogModel>.from(
            json["moods"].map((x) => WSLogModel.fromJson(x))),
        symptoms: List<WSLogModel>.from(
            json["symptoms"].map((x) => WSLogModel.fromJson(x))),
        userId: json["userId"],
        menustralDate: DateTime.parse(json["menustralDate"]),
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "flowIntensity":
            List<dynamic>.from(flowIntensity.map((x) => x.toJson())),
        "moods": List<dynamic>.from(moods.map((x) => x.toJson())),
        "symptoms": List<dynamic>.from(symptoms.map((x) => x.toJson())),
        "userId": userId,
        "menustralDate": menustralDate.toIso8601String(),
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "__v": v,
      };
}

// class FlowIntensity {
//   FlowIntensity({
//     required this.id,
//     required this.name,
//     required this.mediaLink,
//   });

//   String id;
//   String name;
//   String mediaLink;

//   factory FlowIntensity.fromJson(Map<String, dynamic> json) => FlowIntensity(
//         id: json["_id"],
//         name: json["name"],
//         mediaLink: json["mediaLink"],
//       );

//   Map<String, dynamic> toJson() => {
//         "_id": id,
//         "name": name,
//         "mediaLink": mediaLink,
//       };
// }
