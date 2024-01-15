class HealthCareConsultations {
  HealthCareConsultations({
    this.id,
    this.expertiseId,
    this.startDate,
    this.startTime,
    this.userId,
    this.v,
    this.createdAt,
    this.description,
    this.expertId,
    this.startTimeMiliseconds,
    this.status,
    this.updatedAt,
    this.meetingLink,
    this.isActive,
  });

  String? id;
  List<ExpertiseId>? expertiseId;
  String? startDate;
  String? startTime;
  List<Id>? userId;
  int? v;
  DateTime? createdAt;
  String? description;
  List<Id>? expertId;
  int? startTimeMiliseconds;
  String? status;
  DateTime? updatedAt;
  String? meetingLink;
  bool? isActive;
}

class CompletedConsultations {
  String? userId;
  String? expertId;
  String? expertMobileNumber;
  String? expertEmail;
  String? expertFirstName;
  String? expertLastName;
  String? expertiseId;
  String? expertiseName;
  String? consultationId;
  String? startDate;
  String? startTime;
  String? description;
  String? status;
  String? meetingLink;

  CompletedConsultations({
    this.consultationId,
    this.description,
    this.expertEmail,
    this.expertFirstName,
    this.expertId,
    this.expertLastName,
    this.expertMobileNumber,
    this.expertiseId,
    this.expertiseName,
    this.meetingLink,
    this.startDate,
    this.startTime,
    this.status,
    this.userId,
  });
}

class Id {
  Id({
    this.id,
    this.mobileNo,
    this.email,
    this.firstName,
    this.lastName,
    this.imageUrl,
  });

  String? id;
  String? mobileNo;
  String? email;
  String? firstName;
  String? lastName;
  String? imageUrl;

  factory Id.fromJson(Map<String, dynamic> json) => Id(
        id: json["_id"],
        mobileNo: json["mobileNo"],
        email: json["email"],
        firstName: json["firstName"],
        lastName: json["lastName"],
        imageUrl: json["imageUrl"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "mobileNo": mobileNo,
        "email": email,
        "firstName": firstName,
        "lastName": lastName,
        "imageUrl": imageUrl,
      };
}

class ExpertiseId {
  ExpertiseId({
    this.id,
    this.name,
  });

  String? id;
  String? name;

  factory ExpertiseId.fromJson(Map<String, dynamic> json) => ExpertiseId(
        id: json["_id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
      };
}

class HealthCarePrescription {
  String? healthCarePrescriptionUrl;

  HealthCarePrescription({
    this.healthCarePrescriptionUrl,
  });
}
