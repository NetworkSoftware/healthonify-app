class WeightReps {
  String? weight, unit, reps;
  WeightReps({
    this.weight,
    this.unit,
    this.reps,
  });
}

class Reps {
  String? reps;
  Reps({
    this.reps,
  });
}

class Time {
  String? time, unit;
  Time({
    this.time,
    this.unit,
  });
}

class TimeDistance {
  String? time, distance, timeUnit, distanceUnit;
  TimeDistance({
    this.time,
    this.distance,
    this.timeUnit,
    this.distanceUnit,
  });
}

class ExNameReps {
  String? name, reps;
  ExNameReps({
    this.name,
    this.reps,
  });
}

class ExNameTime {
  String? name, time, timeUnit;
  ExNameTime({
    this.name,
    this.time,
    this.timeUnit,
  });
}

class ExNameRepsTime {
  String? name, time, timeUnit, reps;
  ExNameRepsTime({
    this.name,
    this.time,
    this.timeUnit,
    this.reps,
  });
}

class DistanceTimeSets {
  String? distance, time, sets, speed;
  String? distanceUnit, timeUnit;

  DistanceTimeSets({
    this.distance,
    this.sets,
    this.time,
    this.distanceUnit,
    this.timeUnit,
    this.speed,
  });
}

class DistanceSpeed {
  String? distance, speed, distanceUnit;

  DistanceSpeed({
    this.distance,
    this.speed,
    this.distanceUnit,
  });
}

class DistanceModel {
  String? distance, distanceUnit;

  DistanceModel({
    this.distance,
    this.distanceUnit,
  });
}

class TimeSpeedModel {
  String? time, speed, timeUnit;

  TimeSpeedModel({
    this.time,
    this.speed,
    this.timeUnit,
  });
}

class SetTypeData {
  String? from;
  dynamic data;
  SetTypeData({
    this.from,
    this.data,
  });
}
