import 'dart:convert';

WorkoutAnalysisModel workoutAnalysisFromJson(String str) =>
    WorkoutAnalysisModel.fromJson(json.decode(str));

String workoutAnalysisToJson(WorkoutAnalysisModel data) =>
    json.encode(data.toJson());

class WorkoutAnalysisModel {
  WorkoutAnalysisModel({
    this.totalCalories,
    this.totalSets,
    this.totalReps,
    this.totalVolumeInKgs,
    this.totalWorkouts,
    this.workoutPercentagesData,
  });

  double? totalCalories;
  int? totalSets;
  int? totalReps;
  int? totalVolumeInKgs;
  int? totalWorkouts;
  List<WorkoutPercentagesDatum>? workoutPercentagesData;

  factory WorkoutAnalysisModel.fromJson(Map<String, dynamic> json) =>
      WorkoutAnalysisModel(
        totalCalories: json["totalCalories"],
        totalSets: json["totalSets"],
        totalReps: json["totalReps"],
        totalVolumeInKgs: json["totalVolumeInKgs"],
        totalWorkouts: json["totalWorkouts"],
        workoutPercentagesData: List<WorkoutPercentagesDatum>.from(
            json["workoutPercentagesData"]
                .map((x) => WorkoutPercentagesDatum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "totalCalories": totalCalories,
        "totalSets": totalSets,
        "totalReps": totalReps,
        "totalVolumeInKgs": totalVolumeInKgs,
        "totalWorkouts": totalWorkouts,
        "workoutPercentagesData":
            List<dynamic>.from(workoutPercentagesData!.map((x) => x.toJson())),
      };
}

class WorkoutPercentagesDatum {
  WorkoutPercentagesDatum({
    this.name,
    this.count,
    this.percentage,
  });

  String? name;
  int? count;
  String? percentage;

  factory WorkoutPercentagesDatum.fromJson(Map<String, dynamic> json) =>
      WorkoutPercentagesDatum(
        name: json["name"],
        count: json["count"],
        percentage: json["percentage"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "count": count,
        "percentage": percentage,
      };
}
