import 'dart:convert';

List<EnquiryFormModel> enquiryFormModelFromJson(String str) =>
    List<EnquiryFormModel>.from(
        json.decode(str).map((x) => EnquiryFormModel.fromJson(x)));

String enquiryFormModelToJson(List<EnquiryFormModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class EnquiryFormModel {
  EnquiryFormModel({
    required this.id,
    required this.source,
    required this.name,
    required this.email,
    required this.contactNumber,
    required this.message,
    required this.enquiryFor,
    required this.userId,
    required this.category,
    required this.ticketNumber,
    required this.v,
  });

  String? id;
  String? source;
  String? name;
  String? email;
  String? contactNumber;
  String? message;
  String? enquiryFor;
  String? userId;
  String? category;
  String? ticketNumber;

  int v;

  factory EnquiryFormModel.fromJson(Map<String, dynamic> json) =>
      EnquiryFormModel(
        id: json["_id"],
        source: json["source"],
        name: json["name"],
        email: json["email"],
        contactNumber: json["contactNumber"],
        message: json["message"],
        enquiryFor: json["enquiryFor"],
        userId: json["userId"],
        category: json["category"],
        ticketNumber: json["ticketNumber"],
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "source": source,
        "name": name,
        "email": email,
        "contactNumber": contactNumber,
        "message": message,
        "enquiryFor": enquiryFor,
        "userId": userId,
        "category": category,
        "ticketNumber": ticketNumber,
        "__v": v,
      };
}
