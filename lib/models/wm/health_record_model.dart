class HealthRecord {
  String? id;
  String? userId;
  String? mediaLink;
  DateTime? date;
  String? time;
  String? reportName;
  String? reportType;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? dataId;

  HealthRecord({
    this.id,
    this.userId,
    this.mediaLink,
    this.date,
    this.time,
    this.reportName,
    this.reportType,
    this.createdAt,
    this.updatedAt,
    this.dataId,
  });
}
