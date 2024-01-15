class Consultation {
  String? id;
  List<dynamic>? expertiseId;
  String? startTime;
  String? startDate;
  String? status;
  List<dynamic>? user;

  Map<String, dynamic>? expertId;

  Consultation({
    this.expertId,
    this.expertiseId,
    this.id,
    this.startTime,
    this.startDate,
    this.status,
    this.user,
  });
  // factory Consultation.fromJson(Map<String, dynamic> json) => Consultation(
  //       userId: List<String>.from(json["userId"].map((x) => x)),
  //       expertId: List<String>.from(json["expertId"].map((x) => x)),
  //       expertiseId: List<String>.from(json["expertiseId"].map((x) => x)),
  //       id: json["_id"],
  //       startTime: json["startTime"],
  //       startDate: json["startDate"],
  //       startTimeMiliseconds: json["startTimeMiliseconds"],
  //       createdAt: DateTime.parse(json["created_at"]),
  //       updatedAt: DateTime.parse(json["updated_at"]),
  //       v: json["__v"],
  //       meetingLink: json["meetingLink"],
  //       status: json["status"],
  //     );
}

class ConsultationDetails {
  String? sendbirdChannelId;
  String? meetingLink;
  String? userId;
  List<dynamic>? user;
  Map<String, dynamic>? expert;
}


class Enquiry{
  String? enquiryId;
  String? enquiryName;
  String? contactNumber;
  String? category;
  String? status;
  String? ticketNumber;
  String? flow;
  String? date;
  String? time;
  String? comments;

  Enquiry(
      { this.enquiryId,
        this.enquiryName,
        this.contactNumber,
        this.category,
        this.status,
        this.ticketNumber,
        this.flow,
        this.date,
        this.time,this.comments
      });
}