import 'dart:convert';

List<PillReminderModel> pillReminderModelFromJson(List str) =>
    List<PillReminderModel>.from(str.map((x) => PillReminderModel.fromJson(x)));

String pillReminderModelToJson(List<PillReminderModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class PillReminderModel {
  PillReminderModel({
    this.id,
    this.medicineName,
    this.time,
    this.userId,
  });

  String? id;
  String? medicineName;
  String? time;
  String? userId;

  factory PillReminderModel.fromJson(Map<String, dynamic> json) =>
      PillReminderModel(
        id: json["_id"],
        medicineName: json["medicineName"],
        time: json["time"],
        userId: json["userId"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "medicineName": medicineName,
        "time": time,
        "userId": userId,
      };
}
