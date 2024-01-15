class AppointmentSessionConsultation {
  String? id;
  String? sessionNumber;
  String? status;
  String? startDate;
  String? startTime;
  int order;
  List<dynamic>? comment;


  AppointmentSessionConsultation(
      {required this.status, required this.id, required this.sessionNumber,required this.startTime,required this.startDate,required this.order,required this.comment});
}
