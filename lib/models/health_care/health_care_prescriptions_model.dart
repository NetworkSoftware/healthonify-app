class HealthCarePrescriptionModel {
  String? id;
  String? userId;
  String? hcMediaLink;
  String? reportName;
  String? reportType;
  DateTime? date;
  String? stringTime;
  DateTime? time;

  HealthCarePrescriptionModel({
    this.id,
    this.userId,
    this.hcMediaLink,
    this.reportName,
    this.reportType,
    this.date,
    this.time,this.stringTime
  });
}
