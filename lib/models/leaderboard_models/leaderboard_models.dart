import 'dart:convert';

LeaderboardData leaderboardDataFromJson(String str) =>
    LeaderboardData.fromJson(json.decode(str));

String leaderboardDataToJson(LeaderboardData data) =>
    json.encode(data.toJson());

class LeaderboardData {
  LeaderboardData({
    this.fitnessChallengeData,
    this.usersCount,
    this.usersdata,
  });

  FitnessChallengeData? fitnessChallengeData;
  int? usersCount;
  List<LeaderboardUsersData>? usersdata;

  factory LeaderboardData.fromJson(Map<String, dynamic> json) =>
      LeaderboardData(
        fitnessChallengeData:
            FitnessChallengeData.fromJson(json["fitnessChallengeData"]),
        usersCount: json["usersCount"],
        usersdata: List<LeaderboardUsersData>.from(
            json["usersdata"].map((x) => LeaderboardUsersData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "fitnessChallengeData": fitnessChallengeData!.toJson(),
        "usersCount": usersCount,
        "usersdata": List<dynamic>.from(usersdata!.map((x) => x.toJson())),
      };
}

class FitnessChallengeData {
  FitnessChallengeData({
    this.prize,
    this.isActive,
    this.needToDo,
    this.startTimeMs,
    this.endTimeMs,
    this.tips,
    this.id,
    this.name,
    this.mediaLink,
    this.shortDescription,
    this.description,
    this.startDate,
    this.challengeCategoryId,
    this.endDate,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  Prize? prize;
  bool? isActive;
  List<String>? needToDo;
  int? startTimeMs;
  int? endTimeMs;
  List<String>? tips;
  String? id;
  String? name;
  String? mediaLink;
  String? shortDescription;
  String? description;
  String? startDate;
  ChallengeCategoryId? challengeCategoryId;
  String? endDate;
  String? createdAt;
  String? updatedAt;
  int? v;

  factory FitnessChallengeData.fromJson(Map<String, dynamic> json) =>
      FitnessChallengeData(
        prize: Prize.fromJson(json["prize"]),
        isActive: json["isActive"],
        needToDo: List<String>.from(json["needToDo"].map((x) => x)),
        startTimeMs: json["startTimeMs"],
        endTimeMs: json["endTimeMs"],
        tips: List<String>.from(json["tips"].map((x) => x)),
        id: json["_id"],
        name: json["name"],
        mediaLink: json["mediaLink"],
        shortDescription: json["shortDescription"],
        description: json["description"],
        startDate: json["startDate"],
        challengeCategoryId:
            ChallengeCategoryId.fromJson(json["challengeCategoryId"]),
        endDate: json["endDate"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "prize": prize!.toJson(),
        "isActive": isActive,
        "needToDo": List<dynamic>.from(needToDo!.map((x) => x)),
        "startTimeMs": startTimeMs,
        "endTimeMs": endTimeMs,
        "tips": List<dynamic>.from(tips!.map((x) => x)),
        "_id": id,
        "name": name,
        "mediaLink": mediaLink,
        "shortDescription": shortDescription,
        "description": description,
        "startDate": startDate!,
        "challengeCategoryId": challengeCategoryId!.toJson(),
        "endDate": endDate!,
        "created_at": createdAt!,
        "updated_at": updatedAt!,
        "__v": v,
      };
}

class ChallengeCategoryId {
  ChallengeCategoryId({
    this.id,
    this.name,
    this.measuredAs,
  });

  String? id;
  String? name;
  String? measuredAs;

  factory ChallengeCategoryId.fromJson(Map<String, dynamic> json) =>
      ChallengeCategoryId(
        id: json["_id"],
        name: json["name"],
        measuredAs: json["measuredAs"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "measuredAs": measuredAs,
      };
}

class Prize {
  Prize({
    this.prizeType,
    this.prizeValue,
    this.details,
    this.mediaLink,
  });

  String? prizeType;
  String? prizeValue;
  String? details;
  String? mediaLink;

  factory Prize.fromJson(Map<String, dynamic> json) => Prize(
        prizeType: json["prizeType"],
        prizeValue: json["prizeValue"],
        details: json["details"],
        mediaLink: json["mediaLink"],
      );

  Map<String, dynamic> toJson() => {
        "prizeType": prizeType,
        "prizeValue": prizeValue,
        "details": details,
        "mediaLink": mediaLink,
      };
}

class LeaderboardUsersData {
  LeaderboardUsersData({
    this.id,
    this.userId,
    this.fitnessChallengeId,
    this.challengeCategoryId,
    this.enrollDate,
    this.meditationActivity,
    this.foodImagesActivity,
    this.foodImagesCount,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.totalPlants,
    this.totalVideosWatched,
    this.rank,
    this.stepsCount,
  });

  String? id;
  UserId? userId;
  String? fitnessChallengeId;
  String? challengeCategoryId;
  String? enrollDate;
  int? foodImagesCount;
  List<MeditationActivity>? meditationActivity;
  List<dynamic>? foodImagesActivity;
  String? createdAt;
  String? updatedAt;
  int? v;
  int? totalPlants;
  int? totalVideosWatched;
  int? rank;
  int? stepsCount;

  factory LeaderboardUsersData.fromJson(Map<String, dynamic> json) =>
      LeaderboardUsersData(
          id: json["_id"],
          userId: json["userId"] != null ? UserId.fromJson(json["userId"]) : null,
          fitnessChallengeId: json["fitnessChallengeId"],
          challengeCategoryId: json["challengeCategoryId"],
          enrollDate: json["enrollDate"],
          meditationActivity: List<MeditationActivity>.from(
              json["meditationActivity"]
                  .map((x) => MeditationActivity.fromJson(x))),
          foodImagesActivity:
              List<dynamic>.from(json["foodImagesActivity"].map((x) => x)),
          foodImagesCount: json['foodImagesCount'],
          createdAt: json["created_at"],
          updatedAt: json["updated_at"],
          v: json["__v"],
          totalPlants: json["totalPlants"],
          totalVideosWatched: json["totalVideosWatched"],
          rank: json["rank"],
          stepsCount: json["stepsCount"]);

  Map<String, dynamic> toJson() => {
        "_id": id,
        "userId": userId!.toJson(),
        "fitnessChallengeId": fitnessChallengeId,
        "challengeCategoryId": challengeCategoryId,
        "enrollDate": enrollDate!,
        "meditationActivity":
            List<dynamic>.from(meditationActivity!.map((x) => x.toJson())),
        "foodImagesActivity":
            List<dynamic>.from(foodImagesActivity!.map((x) => x)),
        "created_at": createdAt!,
        "updated_at": updatedAt!,
        "__v": v,
        "totalPlants": totalPlants,
        "totalVideosWatched": totalVideosWatched,
        "rank": rank,
        "stepsCount": stepsCount,
      };
}

class MeditationActivity {
  MeditationActivity({
    this.id,
    this.playlistId,
    this.contents,
  });

  String? id;
  String? playlistId;
  List<Content>? contents;

  factory MeditationActivity.fromJson(Map<String, dynamic> json) =>
      MeditationActivity(
        id: json["_id"],
        playlistId: json["playlistId"],
        contents: List<Content>.from(
            json["contents"].map((x) => Content.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "playlistId": playlistId,
        "contents": List<dynamic>.from(contents!.map((x) => x.toJson())),
      };
}

class Content {
  Content({
    this.id,
    this.contentId,
    this.status,
  });

  String? id;
  String? contentId;
  String? status;

  factory Content.fromJson(Map<String, dynamic> json) => Content(
        id: json["_id"],
        contentId: json["contentId"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "contentId": contentId,
        "status": status,
      };
}

class UserId {
  UserId({
    this.id,
    this.firstName,
    this.lastName,
    this.imageUrl,
  });

  String? id;
  String? firstName;
  String? lastName;
  String? imageUrl;

  factory UserId.fromJson(Map<String, dynamic> json) => UserId(
        id: json["_id"],
        firstName: json["firstName"],
        lastName: json["lastName"],
        imageUrl: json["imageUrl"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "firstName": firstName,
        "lastName": lastName,
        "imageUrl": imageUrl,
      };
}
