class AppointmentConsultation {
  String? id;
  List<dynamic>? expert;
  List<dynamic>? expertiseId;
  List<dynamic>? comments;
  String? startDate;
  String? startTime;
  List<dynamic>? userId;
  List<dynamic>? subExpertiseId;
  int? durationInMinutes;
  String? status;
  String? type;
  String? flow;
  String? consultationCharge;
  String? ticketNumber;
  String? paymentLink;

  AppointmentConsultation(
      { this.id,
        this.expert,
        this.startDate,
        this.startTime,
        this.userId,
        this.durationInMinutes,
        this.status,
        this.type,
        this.expertiseId,
        this.ticketNumber,
        this.consultationCharge,
        this.flow,
        this.subExpertiseId,
        this.paymentLink,
        this.comments
      });
}
