class SocialLoginModel {
  SocialLoginModel({
    this.email,
    this.id,
    this.picture,
    this.name,
  });

  String? email;
  String? id;
  Picture? picture;
  String? name;

  factory SocialLoginModel.fromJson(Map<String, dynamic> json) => SocialLoginModel(
        email: json["email"],
        id: json["id"],
        picture: Picture.fromJson(json["picture"]),
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "email": email,
        "id": id,
        "picture": picture!.toJson(),
        "name": name,
      };

}

class Picture {
  Picture({
    this.data,
  });

  Data? data;

  factory Picture.fromJson(Map<String, dynamic> json) => Picture(
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "data": data!.toJson(),
      };
}

class Data {
  Data({
    this.isSilhouette,
    this.height,
    this.url,
    this.width,
  });

  bool? isSilhouette;
  int? height;
  String? url;
  int? width;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        isSilhouette: json["is_silhouette"],
        height: json["height"],
        url: json["url"],
        width: json["width"],
      );

  Map<String, dynamic> toJson() => {
        "is_silhouette": isSilhouette,
        "height": height,
        "url": url,
        "width": width,
      };
}
