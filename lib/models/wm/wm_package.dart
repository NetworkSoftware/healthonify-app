class WmPackage {
  WmPackage({
    this.bodyPart,
    this.healthCondition,
    this.id,
    this.expertId,
    this.expertiseId,
    this.packageTypeId,
    this.name,
    this.description,
    this.benefits,
    this.price,
    this.isActive,
    this.durationInDays,
    this.frequency,
    this.sessionCount,
    this.doctorSessionCount,
    this.dietSessionCount,
    this.fitnessGroupSessionCount,
    this.immunityBoosterCounselling,
    this.customizedDietPlan,
    this.fitnessPlan,
    this.freeGroupSessionAccess,
  });

  List<dynamic>? bodyPart;
  List<dynamic>? healthCondition;
  String? id;
  String? expertId;
  String? expertiseId;
  String? packageTypeId;
  String? name;
  String? description;
  String? benefits;
  String? price;
  bool? isActive;
  String? durationInDays;
  String? frequency;
  String? sessionCount;
  String? doctorSessionCount;
  String? dietSessionCount;
  String? fitnessGroupSessionCount;
  String? immunityBoosterCounselling;
  String? customizedDietPlan;
  String? fitnessPlan;
  bool? freeGroupSessionAccess;
}
