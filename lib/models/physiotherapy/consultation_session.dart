class ConsultationSession {
  List<dynamic>? galleryIds;
  String? id;
  String? subscriptionId;
  int? order;
  String? status;
  String? startDate;
  String? startTime;
  int? startTimeMiliseconds;
  String? specialExpertId;
  String? videoCallLink;

  ConsultationSession({
    this.galleryIds,
    this.id,
    this.subscriptionId,
    this.order,
    this.status,
    this.startDate,
    this.startTime,
    this.startTimeMiliseconds,
    this.specialExpertId,
    this.videoCallLink,
  });
}

class Session {
  Map<String, dynamic> data;
  Session({required this.data});
}
