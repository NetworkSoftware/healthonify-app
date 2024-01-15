class StepsModel {
  String? userId;
  String? date;
  int? stepsCount;
  int? goalCount;

  StepsModel({this.date, this.stepsCount, this.userId, this.goalCount});
}

class StepCounter {
  String? id;
  String? userId;
  String? date;
  String? time;
  int? goalCount;
  int? stepCount;
  int? overallStepCounter;

  StepCounter(
      {this.id,
      this.userId,
      this.date,
      this.time,
      this.stepCount,
      this.goalCount,this.overallStepCounter});
}
