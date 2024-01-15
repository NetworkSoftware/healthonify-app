class TopLevelExpertise {
  String? id;
  String? name;
  String? parentExpertiseId;
  TopLevelExpertise({this.id, this.name, this.parentExpertiseId});
}

class Expertise {
  String? id, name, parentExpertiseId;
  Expertise({
    this.id,
    this.name,
    this.parentExpertiseId,
  });
}
