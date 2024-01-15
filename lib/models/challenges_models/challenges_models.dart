class ChallengesModel {
  String? id;
  bool? isActive;
  int? startTimeMs;
  int? endTimeMs;
  String? name;
  String? mediaLink;
  String? shortDescription;
  String? description;
  String? prizeType;
  String? prizeValue;
  String? challengeCategoryId;
  String? startDate;
  String? endDate;
  List<dynamic>? needToDo;

  ChallengesModel({
    this.id,
    this.challengeCategoryId,
    this.description,
    this.endDate,
    this.endTimeMs,
    this.isActive,
    this.mediaLink,
    this.name,
    this.shortDescription,
    this.prizeType,
    this.prizeValue,
    this.startDate,
    this.startTimeMs,
    this.needToDo,
  });
}

class JoinedChallenges {
  String? fitnessChallengeId;
  String? challengeCategoryId;
  String? name;

  JoinedChallenges({
    this.challengeCategoryId,
    this.fitnessChallengeId,
    this.name,
  });
}

class FoodChallengeImages {
  String? date;
  List<dynamic>? mediaLinks;

  FoodChallengeImages({
    this.date,
    this.mediaLinks,
  });
}
