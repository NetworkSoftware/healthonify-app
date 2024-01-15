class AddWorkoutModel {
  String? name, duration, noOfDays, note, goal, level;
  AddWorkoutModel({
    this.name,
    this.duration,
    this.noOfDays,
    this.note,
    this.level,
    this.goal,
  });
}

class AddSetsModel {
  int? sets;
  int? reps;

  AddSetsModel({
    this.sets,
    this.reps,
  });
}
