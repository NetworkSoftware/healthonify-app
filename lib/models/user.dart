class User {
  List<String>? location;
  bool? isVerified;
  bool? isAdminApproved;
  List<dynamic>? roles;
  List<dynamic>? expertise;
  String? topLevelExpId;
  String? topLevelExpName;
  List<dynamic>? certificates;
  List<dynamic>? availability;
  String? id;
  String? firstName;
  String? lastName;
  String? gender;
  String? bmi;
  String? bodyFat;
  String? chest;
  String? hips;
  String? waistInCms;
  String? sleepTime;
  String? wakeupTime;
  String? mobile;
  String? email;
  String? imageUrl;
  List<dynamic>? consultTime;
  List<dynamic>? blockedSlots;
  String? address;
  String? city;
  String? state;
  int? pincode;
  String? country;
  String? about;
  String? consultationCharge;
  String? dob;
  String? dailyWaterGoal;
  int? dailyStepCountGoal;
  int? dailySleepGoalInSeconds;
  int? calorieIntake;
  int? breakfastGoal;
  int? morningSnacksGoal;
  int? lunchGoal;
  int? afternoonSnacksGoal;
  int? dinnerGoal;
  String? registrationNumber;
  String? topExpertise;

  User(
      {this.topExpertise,
      this.location,
      this.isVerified,
      this.isAdminApproved,
      this.roles,
      this.expertise,
      this.topLevelExpId,
      this.topLevelExpName,
      this.certificates,
      this.availability,
      this.id,
      this.firstName,
      this.gender,
      this.bmi,
      this.bodyFat,
      this.chest,
      this.hips,
      this.waistInCms,
      this.sleepTime,
      this.wakeupTime,
      this.lastName,
      this.mobile,
      this.email,
      this.imageUrl,
      this.consultTime,
      this.blockedSlots,
      this.address,
      this.city,
      this.state,
      this.pincode,
      this.country,
      this.about,
      this.consultationCharge,
      this.dob,
      this.calorieIntake,
      this.dailySleepGoalInSeconds,
      this.dailyStepCountGoal,
      this.dailyWaterGoal,
      this.afternoonSnacksGoal,
      this.breakfastGoal,
      this.dinnerGoal,
      this.lunchGoal,
      this.morningSnacksGoal,
      this.registrationNumber});
}

class UsersList {
  String? id, firstName, lastName;

  UsersList({
    this.id,
    this.firstName,
    this.lastName,
  });
}
