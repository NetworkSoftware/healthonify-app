class BatchModel {
  String? id;
  String? expertId;
  String? name;
  String? capacity;
  String? gender;
  String? info;
  String? roomName;
  String? service;
  String? days;
  String? startTime;
  String? endTime;
  bool? isActive;
  List<String>? userIds;

  BatchModel({
    this.capacity,
    this.days,
    this.endTime,
    this.expertId,
    this.gender,
    this.id,
    this.info,
    this.isActive,
    this.name,
    this.roomName,
    this.service,
    this.startTime,
    this.userIds,
  });
}
