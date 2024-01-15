import 'dart:convert';

FitnessFormModel fitnessFormFromJson(String str) =>
    FitnessFormModel.fromJson(json.decode(str));

String fitnessFormToJson(FitnessFormModel data) => json.encode(data.toJson());

class FitnessFormModel {
  FitnessFormModel({
    this.id,
    this.userId,
    this.questionId,
    this.answer,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  String? id;
  String? userId;
  QuestionId? questionId;
  String? answer;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;

  factory FitnessFormModel.fromJson(Map<String, dynamic> json) =>
      FitnessFormModel(
        id: json["_id"],
        userId: json["userId"],
        questionId: QuestionId.fromJson(json["questionId"]),
        answer: json["answer"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "userId": userId,
        "questionId": questionId!.toJson(),
        "answer": answer,
        "created_at": createdAt!.toIso8601String(),
        "updated_at": updatedAt!.toIso8601String(),
        "__v": v,
      };
}

class QuestionId {
  QuestionId({
    this.id,
    this.question,
    this.order,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  String? id;
  String? question;
  int? order;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;

  factory QuestionId.fromJson(Map<String, dynamic> json) => QuestionId(
        id: json["_id"],
        question: json["question"],
        order: json["order"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "question": question,
        "order": order,
        "created_at": createdAt!.toIso8601String(),
        "updated_at": updatedAt!.toIso8601String(),
        "__v": v,
      };
}
