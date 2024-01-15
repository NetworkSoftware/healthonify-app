class FamilyMemberModel {
  String? id;
  String? relativeFirstName;
  String? relativeLastName;
  String? mobileNo;
  FamilyMemberRelatesTo? relatesTo;
  String? email;
  int? age;
  String? dob;
  String? gender;

  FamilyMemberModel({
    this.age,
    this.dob,
    this.email,
    this.id,
    this.mobileNo,
    this.relatesTo,
    this.relativeFirstName,
    this.relativeLastName,
    this.gender,
  });
}

class FamilyMemberRelatesTo {
  String? id;
  String? email;
  String? firstName;
  String? lastName;
  String? imageUrl;

  FamilyMemberRelatesTo({
    this.email,
    this.firstName,
    this.id,
    this.imageUrl,
    this.lastName,
  });

  factory FamilyMemberRelatesTo.fromJson(Map<String, dynamic> json) =>
      FamilyMemberRelatesTo(
        id: json["_id"],
        email: json["email"],
        firstName: json["firstName"],
        lastName: json["lastName"],
        imageUrl: json["imageUrl"],
      );
}
