class AllTrackers {
  int? totalSleepGoal,
      userSleepCount,
      totalStepsGoal,
      userStepsCount,
      totalWaterGoal,
      userWaterGlassCount,
      caloriesGoal,
      totalFoodCalories,
      totalWorkoutCalories,
      remainingCalories;

  Map<String, dynamic>? calorieProgress;
  List<dynamic>? bloodPressureLogs;
  List<dynamic>? hba1cLogs;
  List<dynamic>? bloodGlucoseLogs;

  AllTrackers({
    this.totalSleepGoal,
    this.userSleepCount,
    this.totalStepsGoal,
    this.userStepsCount,
    this.totalWaterGoal,
    this.userWaterGlassCount,
    this.caloriesGoal,
    this.totalFoodCalories,
    this.totalWorkoutCalories,
    this.remainingCalories,
    this.calorieProgress,
    this.bloodPressureLogs,
    this.hba1cLogs,
    this.bloodGlucoseLogs,
  });
}

class WeeklyWorkoutsModel {
  WeeklyWorkoutsModel({
    this.weeklyDurationInMinutes,
    this.weeklyData,
  });

  int? weeklyDurationInMinutes;
  List<WeeklyData>? weeklyData;

  factory WeeklyWorkoutsModel.fromJson(Map<String, dynamic> json) =>
      WeeklyWorkoutsModel(
        weeklyDurationInMinutes: json["weeklyDurationInMinutes"],
        weeklyData: List<WeeklyData>.from(
            json["weeklyData"].map((x) => WeeklyData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "weeklyDurationInMinutes": weeklyDurationInMinutes,
        "weeklyData": List<dynamic>.from(weeklyData!.map((x) => x.toJson())),
      };
}

class WeeklyData {
  WeeklyData({
    this.date,
    this.durationInMinutes,
    this.checkedIn,
  });

  String? date;
  int? durationInMinutes;
  bool? checkedIn;

  factory WeeklyData.fromJson(Map<String, dynamic> json) => WeeklyData(
        date: json["date"],
        durationInMinutes: json["durationInMinutes"],
        checkedIn: json["checkedIn"],
      );

  Map<String, dynamic> toJson() => {
        "date": date,
        "durationInMinutes": durationInMinutes,
        "checkedIn": checkedIn,
      };
}
