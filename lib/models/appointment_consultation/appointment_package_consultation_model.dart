class AppointmentPackageConsultation {
  String? id;
  String? paymentLink;
  String? status;
  Map<String, dynamic>? expertId;
  Map<String, dynamic>? userId;
  Map<String, dynamic>? packageId;
  List<dynamic>? serviceDetails;

  AppointmentPackageConsultation(
      {required this.userId,
      required this.expertId,required this.status,
      required this.packageId,
      required this.id,required this.paymentLink,required this.serviceDetails});
}
