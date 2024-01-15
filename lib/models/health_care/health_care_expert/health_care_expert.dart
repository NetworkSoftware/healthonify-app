class HealthCareExpert {
  String? id;
  String? mobileNo;
  String? email;
  String? firstName;
  String? lastName;
  bool? isVerified;
  String? topExpertiseId;
  String? topExpertiseName;
  String? topExpertiseFlow;
  String? state;
  String? city;
  String? about;
  String? imageUrl;
  List<dynamic>? certificates;

  HealthCareExpert({
    this.email,
    this.firstName,
    this.id,
    this.isVerified,
    this.lastName,
    this.mobileNo,
    this.topExpertiseId,
    this.topExpertiseName,
    this.topExpertiseFlow,
    this.city,
    this.state,
    this.about,
    this.imageUrl,
    this.certificates,
  });
}
