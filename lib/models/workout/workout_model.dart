class WorkoutModel {
  WorkoutModel({
    this.id,
    this.name,
    this.daysInweek,
    this.validityInDays,
    this.schedule,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.datumId,
    this.description,
    this.goal,
    this.level,
    this.price,
  });

  String? id;
  String? name;
  String? daysInweek;
  String? validityInDays;
  List<Schedule>? schedule;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? v;
  String? datumId;
  String? description;
  String? goal;
  String? level;
  String? price;
}

class Schedule {
  Schedule({
    this.id,
    this.day,
    this.exercises,
    this.note,
    this.order,
  });

  String? id;
  String? day;
  List<ExerciseWorkoutModel>? exercises;
  String? note;
  String? order;
  // String? group;

  factory Schedule.fromJson(Map<String, dynamic> scheduleData) => Schedule(
        id: scheduleData["_id"],
        day: scheduleData["day"],
        exercises: List<ExerciseWorkoutModel>.from(scheduleData["exercises"]
            .map((x) => ExerciseWorkoutModel.fromJson(x))),
        note: scheduleData["note"],
        order: scheduleData["order"].toString(),
      );

  Map<String, dynamic> scheduleJson() => {
        "_id": id,
        "day": day,
        "exercises":
            List<dynamic>.from(exercises!.map((x) => x.exerciseJson())),
        "note": note,
        "order": order,
      };
}

class ExerciseWorkoutModel {
  ExerciseWorkoutModel({
    this.id,
    this.round,
    this.group,
    this.exerciseId,
    this.setTypeId,
    this.bodyPartGroupId,
    this.setType,
    this.note,
    this.sets,
    this.bodyPartId,
  });

  String? id;
  String? round;
  String? group;
  Map<String, dynamic>? exerciseId;
  Map<String, dynamic>? setTypeId;
  Map<String, dynamic>? bodyPartGroupId;
  String? setType;
  String? note;
  List<Set>? sets;
  Map<String, dynamic>? bodyPartId;

  factory ExerciseWorkoutModel.fromJson(Map<String, dynamic> exerciseData) =>
      ExerciseWorkoutModel(
        id: exerciseData["_id"],
        round: exerciseData["round"].toString(),
        exerciseId: exerciseData["exerciseId"],
        setTypeId: exerciseData["setTypeId"],
        group: exerciseData["group"],
        bodyPartGroupId: exerciseData["bodyPartGroupId"],
        //bodyPartId: exerciseData["bodyPartId"],
        setType: exerciseData["setType"],
        note: exerciseData["note"],
        sets: List<Set>.from(exerciseData["sets"].map((x) => Set.fromJson(x))),
      );

  Map<String, dynamic> exerciseJson() => {
        "_id": id,
        "round": round,
        "exerciseId": exerciseId,
        "setTypeId": setTypeId,
        "bodyPartGroupId": bodyPartGroupId,
        "note": note,
        "group": group,
        "bodyPartId": bodyPartId,
        "sets": List<dynamic>.from(sets!.map((x) => x.setJson())),
        "setType": setType,
      };
}

class Set {
  Set({
    this.id,
    this.weight,
    this.weightUnit,
    this.reps,
    this.distance,
    this.distanceUnit,
    this.time,
    this.timeUnit,
    this.speed,
    this.name,
    this.set,
  });

  String? id;
  String? weight;
  String? weightUnit;
  String? reps;
  String? distance;
  String? distanceUnit;
  String? time, timeUnit;
  String? speed;
  String? name;
  String? set;

  factory Set.fromJson(Map<String, dynamic> setData) => Set(
        id: setData["_id"],
        weight: setData["weight"].toString(),
        weightUnit: setData["weightUnit"].toString(),
        reps: setData["reps"].toString().toString(),
        distance: setData["distance"].toString(),
        distanceUnit: setData["distanceUnit"].toString(),
        time: setData["time"].toString(),
        timeUnit: setData["timeUnit"].toString(),
        speed: setData["speed"].toString(),
        name: setData["name"].toString(),
        set: setData["set"].toString(),
      );

  Map<String, dynamic> setJson() => {
        "_id": id,
        "weight": weight,
        "weightUnit": weightUnit,
        "reps": reps,
        "distance": distance,
        "distanceUnit": distanceUnit,
        "time": time,
        "timeUnit": timeUnit,
        "speed": speed,
        "name": name,
        "set": set
      };
}
