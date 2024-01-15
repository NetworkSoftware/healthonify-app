class BodyMeasurements {
  BodyMeasurements({
    this.mediaLinks,
    this.measurements,
    this.id,
    this.date,
    this.userId,
    this.v,
    this.bloodPressure,
    this.bmi,
    this.bmr,
    this.bodyFat,
    this.bodyMetabolicAge,
    this.createdAt,
    this.heartRate,
    this.muscleMass,
    this.note,
    this.subCutaneous,
    this.updatedAt,
    this.visceralFat,
    this.weightInKg,
    this.totalheight,
    this.bodyMeasurementsId,
  });

  MediaLinks? mediaLinks;
  Measurements? measurements;
  String? id;
  DateTime? date;
  String? userId;
  int? v;
  String? bloodPressure;
  int? bmi;
  int? bmr;
  int? bodyFat;
  int? bodyMetabolicAge;
  DateTime? createdAt;
  int? heartRate;
  int? muscleMass;
  String? note;
  int? subCutaneous;
  DateTime? updatedAt;
  int? visceralFat;
  int? weightInKg;
  int? totalheight;
  String? bodyMeasurementsId;

  Map<String, dynamic> toJson() => {
        "mediaLinks": mediaLinks!.toJson(),
        "measurements": measurements!.toJson(),
        "_id": id,
        "date": date!.toIso8601String(),
        "userId": userId,
        "__v": v,
        "bloodPressure": bloodPressure,
        "bmi": bmi,
        "bmr": bmr,
        "bodyFat": bodyFat,
        "bodyMetabolicAge": bodyMetabolicAge,
        "created_at": createdAt!.toIso8601String(),
        "heartRate": heartRate,
        "muscleMass": muscleMass,
        "note": note,
        "subCutaneous": subCutaneous,
        "updated_at": updatedAt!.toIso8601String(),
        "visceralFat": visceralFat,
        "weightInKg": weightInKg,
        "totalheight": totalheight,
        "id": bodyMeasurementsId,
      };
}

class Measurements {
  Measurements({
    this.measurementUnits,
    this.bust,
    this.chest,
    this.waist,
    this.hips,
    this.midway,
    this.thighs,
    this.knees,
    this.calves,
    this.upperArms,
    this.foreArms,
    this.neck,
    this.shoulder,
    this.wrist,
    this.upperAbdomen,
    this.lowerAbdomen,
  });

  String? measurementUnits;
  int? bust;
  int? chest;
  int? waist;
  int? hips;
  int? midway;
  int? thighs;
  int? knees;
  int? calves;
  int? upperArms;
  int? foreArms;
  int? neck;
  int? shoulder;
  int? wrist;
  int? upperAbdomen;
  int? lowerAbdomen;

  factory Measurements.fromJson(Map<String, dynamic> json) => Measurements(
        measurementUnits: json["measurementUnits"],
        bust: json["bust"],
        chest: json["chest"],
        waist: json["waist"],
        hips: json["hips"],
        midway: json["midway"],
        thighs: json["thighs"],
        knees: json["knees"],
        calves: json["calves"],
        upperArms: json["upperArms"],
        foreArms: json["foreArms"],
        neck: json["neck"],
        shoulder: json["shoulder"],
        wrist: json["wrist"],
        upperAbdomen: json["upperAbdomen"],
        lowerAbdomen: json["lowerAbdomen"],
      );

  Map<String, dynamic> toJson() => {
        "measurementUnits": measurementUnits,
        "bust": bust,
        "chest": chest,
        "waist": waist,
        "hips": hips,
        "midway": midway,
        "thighs": thighs,
        "knees": knees,
        "calves": calves,
        "upperArms": upperArms,
        "foreArms": foreArms,
        "neck": neck,
        "shoulder": shoulder,
        "wrist": wrist,
        "upperAbdomen": upperAbdomen,
        "lowerAbdomen": lowerAbdomen,
      };
}

class MediaLinks {
  MediaLinks({
    this.frontImage,
    this.sideImage,
    this.backImage,
  });

  String? frontImage;
  String? sideImage;
  String? backImage;

  factory MediaLinks.fromJson(Map<String, dynamic> json) => MediaLinks(
        frontImage: json["frontImage"],
        sideImage: json["sideImage"],
        backImage: json["backImage"],
      );

  Map<String, dynamic> toJson() => {
        "frontImage": frontImage,
        "sideImage": sideImage,
        "backImage": backImage,
      };
}
