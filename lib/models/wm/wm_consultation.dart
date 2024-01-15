class WmConsultation {
  String? id;
  List<dynamic>? expert;
  List<dynamic>? expertiseId;
  String? startDate;
  String? startTime;
  List<dynamic>? userId;
  int? durationInMinutes;
  String? status;
  String? type;
  String? ticketNumber;
  String? flow;
  String? sessionType;
  String? sessionName;
  String? sessionNumber;
  String? benefits;
  String? description;
  List<dynamic>? comment;

  WmConsultation(
      {this.id,
      this.expert,
      this.startDate,
      this.startTime,
      this.userId,
      this.durationInMinutes,
      this.status,
      this.type,
      this.expertiseId,
      this.flow,
      this.ticketNumber,
      this.comment,
      this.sessionName,
      this.sessionNumber,
      this.sessionType,this.benefits,this.description});
}
