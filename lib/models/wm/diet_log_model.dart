import 'package:healthonify_mobile/models/wm/diet_plan_model.dart';

class DietLog {
  String? id;
  List<String>? mediaLink;
  String? date;
  int? timeInMs;
  String? mealTime;
  String? userId;
  List<GetDish>? dishes;
  String? mealName;

  DietLog({
    this.id,
    this.mediaLink,
    this.date,
    this.timeInMs,
    this.mealName,
    this.userId,
    this.dishes,
    this.mealTime,
  });

  factory DietLog.fromJson(Map<String, dynamic> json) => DietLog(
        id: json["_id"],
        mediaLink: json["mediaLink"] == null
            ? null
            : List<String>.from(json["mediaLink"].map((x) => x)),
        date: json["date"],
        timeInMs: json["timeInMs"],
        mealTime: json["mealTime"],
        userId: json["userId"],
        dishes:
            List<GetDish>.from(json["dishes"].map((x) => GetDish.fromJson(x))),
        mealName: json["mealName"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "mediaLink": List<dynamic>.from(mediaLink!.map((x) => x)),
        "date": date,
        "timeInMs": timeInMs,
        "mealTime": mealTime,
        "userId": userId,
        "dishes": List<dynamic>.from(dishes!.map((x) => x.toJson())),
        "mealName": mealName,
      };
}
