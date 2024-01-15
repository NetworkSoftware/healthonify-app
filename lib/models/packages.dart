class PhysioPackage {
  List<dynamic>? bodyPart;
  List<dynamic>? healthCondition;
  String? id;
  String? name;
  String? expertId;
  String? expertiseId;
  String? price;
  int? packageDurationInWeeks;
  String? sessionCount;
  String? description;
  String? benefits;
  bool? isActive;
  String? frequency;

  PhysioPackage({
    this.bodyPart,
    this.healthCondition,
    this.id,
    this.name,
    this.expertId,
    this.expertiseId,
    this.price,
    this.packageDurationInWeeks,
    this.sessionCount,
    this.description,
    this.benefits,
    this.isActive,
    this.frequency,
  });
}
