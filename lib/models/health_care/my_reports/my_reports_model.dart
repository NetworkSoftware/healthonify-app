import 'dart:convert';

MyLabReports myLabReportsFromJson(String str) =>
    MyLabReports.fromJson(json.decode(str));

String myLabReportsToJson(MyLabReports data) => json.encode(data.toJson());

class MyLabReports {
  MyLabReports({
    this.id,
    this.labTestId,
    this.v,
    this.createdAt,
    this.labId,
    this.referredBy,
    this.reportDate,
    this.reportTime,
    this.tests,
    this.updatedAt,
    this.userId,
    this.labReportUrl,
  });

  String? id;
  String? labTestId;
  int? v;
  DateTime? createdAt;
  String? labId;
  String? referredBy;
  DateTime? reportDate;
  String? reportTime;
  List<Test>? tests;
  DateTime? updatedAt;
  String? userId;
  String? labReportUrl;

  factory MyLabReports.fromJson(Map<String, dynamic> json) => MyLabReports(
        id: json["_id"],
        labTestId: json["labTestId"],
        v: json["__v"],
        createdAt: DateTime.parse(json["created_at"]),
        labId: json["labId"],
        referredBy: json["referredBy"],
        reportDate: DateTime.parse(json["reportDate"]),
        reportTime: json["reportTime"],
        tests: List<Test>.from(json["tests"].map((x) => Test.fromJson(x))),
        updatedAt: DateTime.parse(json["updated_at"]),
        userId: json["userId"],
        labReportUrl: json["labReportUrl"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "labTestId": labTestId,
        "__v": v,
        "created_at": createdAt!.toIso8601String(),
        "labId": labId,
        "referredBy": referredBy,
        "reportDate": reportDate!.toIso8601String(),
        "reportTime": reportTime,
        "tests": List<dynamic>.from(tests!.map((x) => x.toJson())),
        "updated_at": updatedAt!.toIso8601String(),
        "userId": userId,
        "labReportUrl": labReportUrl,
      };
}

class Test {
  Test({
    this.id,
    this.testName,
    this.units,
    this.value,
    this.reference,
  });

  String? id;
  String? testName;
  String? units;
  double? value;
  String? reference;

  factory Test.fromJson(Map<String, dynamic> json) => Test(
        id: json["_id"],
        testName: json["testName"],
        units: json["units"],
        value: json["value"].toDouble(),
        reference: json["reference"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "testName": testName,
        "units": units,
        "value": value,
        "reference": reference,
      };
}
