class WSLogModel {
  WSLogModel({
    required this.id,
    required this.name,
    required this.mediaLink,
  });

  String id;
  String name;
  String mediaLink;

  factory WSLogModel.fromJson(Map<String, dynamic> json) => WSLogModel(
        id: json["_id"],
        name: json["name"],
        mediaLink: json["mediaLink"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "mediaLink": mediaLink,
      };
}
