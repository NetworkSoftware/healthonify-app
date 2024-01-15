class FamilyHistoryModel {
  String? userId;
  String? condition;
  String? relation;
  String? sinceWhen;
  String? comments;

  FamilyHistoryModel({
    this.comments,
    this.condition,
    this.relation,
    this.sinceWhen,
    this.userId,
  });
}

class AllergicHistoryModel {
  String? userId;
  String? name;
  String? type;
  String? sinceFrom;
  String? description;

  AllergicHistoryModel({
    this.description,
    this.name,
    this.sinceFrom,
    this.type,
    this.userId,
  });
}

class MajorIllnessModel {
  String? userId;
  String? condition;
  String? sinceWhen;
  String? comments;
  bool? onMedication;

  MajorIllnessModel({
    this.comments,
    this.condition,
    this.sinceWhen,
    this.userId,
    this.onMedication,
  });
}

class SurgicalHistoryModel {
  String? userId;
  String? name;
  String? date;
  String? hospitalNameOrDoctorName;
  String? comments;

  SurgicalHistoryModel({
    this.comments,
    this.date,
    this.hospitalNameOrDoctorName,
    this.name,
    this.userId,
  });
}

class SocialHabitsModel {
  String? userId;
  String? socialHabit;
  String? frequency;
  String? comments;
  String? havingFrom;

  SocialHabitsModel({
    this.comments,
    this.frequency,
    this.havingFrom,
    this.socialHabit,
    this.userId,
  });
}
