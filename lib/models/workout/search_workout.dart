import 'dart:convert';

SearchWorkoutPlanModel searchWorkoutPlanFromJson(String str) =>
    SearchWorkoutPlanModel.fromJson(json.decode(str));

String searchWorkoutPlanToJson(SearchWorkoutPlanModel data) =>
    json.encode(data.toJson());

class SearchWorkoutPlanModel {
  SearchWorkoutPlanModel({
    this.id,
    this.name,
    this.daysInweek,
    this.validityInDays,
    this.description,
    this.goal,
    this.level,
    this.userId,
    this.type,
    this.schedule,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.welcomeId,
  });

  String? id;
  String? name;
  String? daysInweek;
  String? validityInDays;
  String? description;
  String? goal;
  String? level;
  String? userId;
  String? type;
  List<WorkoutSchedule>? schedule;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;
  String? welcomeId;

  factory SearchWorkoutPlanModel.fromJson(Map<String, dynamic> json) =>
      SearchWorkoutPlanModel(
        id: json["_id"],
        name: json["name"],
        daysInweek: json["daysInweek"],
        validityInDays: json["validityInDays"],
        description: json["description"],
        goal: json["goal"],
        level: json["level"],
        userId: json["userId"],
        type: json["type"],
        schedule: List<WorkoutSchedule>.from(
            json["schedule"].map((x) => WorkoutSchedule.fromJson(x))),
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        v: json["__v"],
        welcomeId: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "daysInweek": daysInweek,
        "validityInDays": validityInDays,
        "description": description,
        "goal": goal,
        "level": level,
        "userId": userId,
        "type": type,
        "schedule": List<dynamic>.from(schedule!.map((x) => x.toJson())),
        "created_at": createdAt!.toIso8601String(),
        "updated_at": updatedAt!.toIso8601String(),
        "__v": v,
        "id": welcomeId,
      };
}

class WorkoutSchedule {
  WorkoutSchedule({
    this.id,
    this.day,
    this.exercises,
    this.order,
  });

  String? id;
  String? day;
  List<Exercise>? exercises;
  String? order;

  factory WorkoutSchedule.fromJson(Map<String, dynamic> json) =>
      WorkoutSchedule(
        id: json["_id"],
        day: json["day"],
        exercises: List<Exercise>.from(
            json["exercises"].map((x) => Exercise.fromJson(x))),
        order: json["order"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "day": day,
        "exercises": List<dynamic>.from(exercises!.map((x) => x.toJson())),
        "order": order,
      };
}

class Exercise {
  Exercise({
    this.id,
    this.round,
    this.group,
    this.exerciseId,
    this.setTypeId,
    this.bodyPartGroupId,
    this.bodyPartId,
    this.setType,
    this.note,
    this.sets,
  });

  String? id;
  String? round;
  String? group;
  Id? exerciseId;
  String? setTypeId;
  Id? bodyPartGroupId;
  BodyPartId? bodyPartId;
  String? setType;
  String? note;
  List<Set>? sets;

  factory Exercise.fromJson(Map<String, dynamic> json) => Exercise(
        id: json["_id"],
        round: json["round"],
        group: json["group"],
        exerciseId: Id.fromJson(json["exerciseId"]),
        setTypeId: json["setTypeId"],
        bodyPartGroupId: Id.fromJson(json["bodyPartGroupId"]),
        bodyPartId: BodyPartId.fromJson(json["bodyPartId"]),
        setType: json["setType"],
        note: json["note"],
        sets: List<Set>.from(json["sets"].map((x) => Set.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "round": round,
        "group": group,
        "exerciseId": exerciseId!.toJson(),
        "setTypeId": setTypeId,
        "bodyPartGroupId": bodyPartGroupId!.toJson(),
        "bodyPartId": bodyPartId!.toJson(),
        "setType": setType,
        "note": note,
        "sets": List<dynamic>.from(sets!.map((x) => x.toJson())),
      };
}

class Id {
  Id({
    this.id,
    this.name,
    this.mediaLink,
    this.idId,
  });

  String? id;
  String? name;
  String? mediaLink;
  String? idId;

  factory Id.fromJson(Map<String, dynamic> json) => Id(
        id: json["_id"],
        name: json["name"],
        mediaLink: json["mediaLink"],
        idId: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "mediaLink": mediaLink,
        "id": idId,
      };
}

class BodyPartId {
  BodyPartId({
    this.id,
    this.name,
    this.bodyPartImage,
  });

  String? id;
  String? name;
  String? bodyPartImage;

  factory BodyPartId.fromJson(Map<String, dynamic> json) => BodyPartId(
        id: json["_id"],
        name: json["name"],
        bodyPartImage: json["bodyPartImage"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "bodyPartImage": bodyPartImage,
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
    this.setSet,
  });

  String? id;
  String? weight;
  String? weightUnit;
  String? reps;
  String? distance;
  String? distanceUnit;
  String? time;
  String? timeUnit;
  String? speed;
  String? name;
  String? setSet;

  factory Set.fromJson(Map<String, dynamic> json) => Set(
        id: json["_id"],
        weight: json["weight"],
        weightUnit: json["weightUnit"],
        reps: json["reps"],
        distance: json["distance"],
        distanceUnit: json["distanceUnit"],
        time: json["time"],
        timeUnit: json["timeUnit"],
        speed: json["speed"],
        name: json["name"],
        setSet: json["set"],
      );

  Map<String, dynamic> toJson() => {
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
        "set": setSet,
      };
}
