class UpcomingSessions {
  String? packageName;
  String? clientName;
  String? expertName;
  String? id;
  int? order;
  Map<String, dynamic>? subscription;
  String? benefits;
  String? description;
  int? durationInMinutes;
  String? name;
  String? specialExpertId;
  String? startDate;
  String? startTime;
  int? startTimeMiliseconds;
  String? status;
  String? videoCallLink;
  Map<String, dynamic>? consultation;

  UpcomingSessions({
    this.packageName,
    this.clientName,
    this.expertName,
    this.id,
    this.order,
    this.subscription,
    this.benefits,
    this.description,
    this.durationInMinutes,
    this.name,
    this.specialExpertId,
    this.startDate,
    this.startTime,
    this.startTimeMiliseconds,
    this.status,
    this.videoCallLink,
    this.consultation,
  });
}
