import 'dart:convert';

HomeTrackerModel homeTrackerModelFromJson(String str) =>
    HomeTrackerModel.fromJson(json.decode(str));

String homeTrackerModelToJson(HomeTrackerModel data) =>
    json.encode(data.toJson());

class HomeTrackerModel {
  HomeTrackerModel({
    this.sleepProgress,
    this.stepsProgress,
    this.waterProgress,
    this.calorieProgress,
    this.bloodPressureLogs,
    this.hba1CLogs,
    this.bloodGlucoseLogs,
  });

  SleepProgress? sleepProgress;
  StepsProgress? stepsProgress;
  WaterProgress? waterProgress;
  CalorieProgress? calorieProgress;
  List<BloodPressureLog>? bloodPressureLogs;
  List<Hba1CLog>? hba1CLogs;
  List<BloodGlucoseLog>? bloodGlucoseLogs;

  factory HomeTrackerModel.fromJson(Map<String, dynamic> json) =>
      HomeTrackerModel(
        sleepProgress: SleepProgress.fromJson(json["sleepProgress"]),
        stepsProgress: StepsProgress.fromJson(json["stepsProgress"]),
        waterProgress: WaterProgress.fromJson(json["waterProgress"]),
        calorieProgress: CalorieProgress.fromJson(json["calorieProgress"]),
        bloodPressureLogs: List<BloodPressureLog>.from(
            json["bloodPressureLogs"].map((x) => BloodPressureLog.fromJson(x))),
        hba1CLogs: List<Hba1CLog>.from(
            json["hba1cLogs"].map((x) => Hba1CLog.fromJson(x))),
        bloodGlucoseLogs: List<BloodGlucoseLog>.from(
            json["bloodGlucoseLogs"].map((x) => BloodGlucoseLog.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "sleepProgress": sleepProgress!.toJson(),
        "stepsProgress": stepsProgress!.toJson(),
        "waterProgress": waterProgress!.toJson(),
        "calorieProgress": calorieProgress!.toJson(),
        "bloodPressureLogs":
            List<dynamic>.from(bloodPressureLogs!.map((x) => x.toJson())),
        "hba1cLogs": List<dynamic>.from(hba1CLogs!.map((x) => x.toJson())),
        "bloodGlucoseLogs":
            List<dynamic>.from(bloodGlucoseLogs!.map((x) => x.toJson())),
      };
}

class BloodGlucoseLog {
  BloodGlucoseLog({
    this.id,
    this.date,
    this.userId,
    this.bloodGlucoseLevel,
    this.mealType,
    this.testType,
    this.time,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.bloodGlucoseLogId,
  });

  String? id;
  String? date;
  String? userId;
  String? bloodGlucoseLevel;
  String? mealType;
  String? testType;
  String? time;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;
  String? bloodGlucoseLogId;

  factory BloodGlucoseLog.fromJson(Map<String, dynamic> json) =>
      BloodGlucoseLog(
        id: json["_id"],
        date: json["date"],
        userId: json["userId"],
        bloodGlucoseLevel: json["bloodGlucoseLevel"],
        mealType: json["mealType"],
        testType: json["testType"],
        time: json["time"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        v: json["__v"],
        bloodGlucoseLogId: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "date": date,
        "userId": userId,
        "bloodGlucoseLevel": bloodGlucoseLevel,
        "mealType": mealType,
        "testType": testType,
        "time": time,
        "created_at": createdAt!.toIso8601String(),
        "updated_at": updatedAt!.toIso8601String(),
        "__v": v,
        "id": bloodGlucoseLogId,
      };
}

class BloodPressureLog {
  BloodPressureLog({
    this.id,
    this.date,
    this.userId,
    this.systolic,
    this.diastolic,
    this.pulse,
    this.time,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.bloodPressureLogId,
  });

  String? id;
  String? date;
  String? userId;
  String? systolic;
  String? diastolic;
  String? pulse;
  String? time;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;
  String? bloodPressureLogId;

  factory BloodPressureLog.fromJson(Map<String, dynamic> json) =>
      BloodPressureLog(
        id: json["_id"],
        date: json["date"],
        userId: json["userId"],
        systolic: json["systolic"],
        diastolic: json["diastolic"],
        pulse: json["pulse"],
        time: json["time"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        v: json["__v"],
        bloodPressureLogId: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "date": date,
        "userId": userId,
        "systolic": systolic,
        "diastolic": diastolic,
        "pulse": pulse,
        "time": time,
        "created_at": createdAt!.toIso8601String(),
        "updated_at": updatedAt!.toIso8601String(),
        "__v": v,
        "id": bloodPressureLogId,
      };
}

class CalorieProgress {
  CalorieProgress({
    this.caloriesGoal,
    this.totalFoodCalories,
    this.totalWorkoutCalories,
    this.remainingCalories,
  });

  String? caloriesGoal;
  String? totalFoodCalories;
  String? totalWorkoutCalories;
  String? remainingCalories;

  factory CalorieProgress.fromJson(Map<String, dynamic> json) =>
      CalorieProgress(
        caloriesGoal: json["caloriesGoal"],
        totalFoodCalories: json["totalFoodCalories"],
        totalWorkoutCalories: json["totalWorkoutCalories"],
        remainingCalories: json["remainingCalories"],
      );

  Map<String, dynamic> toJson() => {
        "caloriesGoal": caloriesGoal,
        "totalFoodCalories": totalFoodCalories,
        "totalWorkoutCalories": totalWorkoutCalories,
        "remainingCalories": remainingCalories,
      };
}

class Hba1CLog {
  Hba1CLog({
    this.id,
    this.date,
    this.userId,
    this.hba1CLevel,
    this.time,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.hba1CLogId,
  });

  String? id;
  String? date;
  String? userId;
  String? hba1CLevel;
  String? time;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;
  String? hba1CLogId;

  factory Hba1CLog.fromJson(Map<String, dynamic> json) => Hba1CLog(
        id: json["_id"],
        date: json["date"],
        userId: json["userId"],
        hba1CLevel: json["hba1cLevel"],
        time: json["time"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        v: json["__v"],
        hba1CLogId: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "date": date,
        "userId": userId,
        "hba1cLevel": hba1CLevel,
        "time": time,
        "created_at": createdAt!.toIso8601String(),
        "updated_at": updatedAt!.toIso8601String(),
        "__v": v,
        "id": hba1CLogId,
      };
}

class SleepProgress {
  SleepProgress({
    this.totalSleepGoal,
    this.userSleepCount,
  });

  String? totalSleepGoal;
  String? userSleepCount;

  factory SleepProgress.fromJson(Map<String, dynamic> json) => SleepProgress(
        totalSleepGoal: json["totalSleepGoal"],
        userSleepCount: json["userSleepCount"],
      );

  Map<String, dynamic> toJson() => {
        "totalSleepGoal": totalSleepGoal,
        "userSleepCount": userSleepCount,
      };
}

class StepsProgress {
  StepsProgress({
    this.totalStepsGoal,
    this.userStepsCount,
  });

  String? totalStepsGoal;
  String? userStepsCount;

  factory StepsProgress.fromJson(Map<String, dynamic> json) => StepsProgress(
        totalStepsGoal: json["totalStepsGoal"],
        userStepsCount: json["userStepsCount"],
      );

  Map<String, dynamic> toJson() => {
        "totalStepsGoal": totalStepsGoal,
        "userStepsCount": userStepsCount,
      };
}

class WaterProgress {
  WaterProgress({
    this.totalWaterGoal,
    this.userWaterGlassCount,
  });

  String? totalWaterGoal;
  String? userWaterGlassCount;

  factory WaterProgress.fromJson(Map<String, dynamic> json) => WaterProgress(
        totalWaterGoal: json["totalWaterGoal"],
        userWaterGlassCount: json["userWaterGlassCount"],
      );

  Map<String, dynamic> toJson() => {
        "totalWaterGoal": totalWaterGoal,
        "userWaterGlassCount": userWaterGlassCount,
      };
}
