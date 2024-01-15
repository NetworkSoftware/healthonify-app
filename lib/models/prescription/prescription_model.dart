class PrescriptionConsultation {
  String? id;
  String? expertId;
  String? advices;
  List<dynamic>? medicines;
  String? userId;
  String? date;
  String? gender;
  String? chiefComplaints;
  String? reportType;
  String? ticketNumber;
  String? prescriptionUrl;

  PrescriptionConsultation(
      {this.id,
      this.expertId,
      this.ticketNumber,
      this.userId,
      this.date,
      this.advices,
      this.chiefComplaints,
      this.gender,
      this.medicines,
      this.prescriptionUrl,
      this.reportType});
}
