import 'dart:convert';

LifestyleModel lifestyleModelFromJson(String str) =>
    LifestyleModel.fromJson(json.decode(str));

String lifestyleModelToJson(LifestyleModel data) => json.encode(data.toJson());

class LifestyleModel {
  LifestyleModel({
    this.id,
    this.userId,
    this.v,
    this.createdAt,
    this.qna,
    this.updatedAt,
  });

  String? id;
  String? userId;
  int? v;
  DateTime? createdAt;
  List<Qna>? qna;
  DateTime? updatedAt;

  factory LifestyleModel.fromJson(Map<String, dynamic> json) => LifestyleModel(
        id: json["_id"],
        userId: json["userId"],
        v: json["__v"],
        createdAt: DateTime.parse(json["created_at"]),
        qna: List<Qna>.from(json["qna"].map((x) => Qna.fromJson(x))),
        updatedAt: DateTime.parse(
          json["updated_at"],
        ),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "userId": userId,
        "__v": v,
        "created_at": createdAt!.toIso8601String(),
        "qna": List<dynamic>.from(qna!.map((x) => x.toJson())),
        "updated_at": updatedAt!.toIso8601String(),
      };
}

class Qna {
  Qna({
    this.answer,
    this.id,
    this.question,
  });

  List<String>? answer;
  String? id;
  String? question;

  factory Qna.fromJson(Map<String, dynamic> json) => Qna(
        answer: List<String>.from(json["answer"].map((x) => x)),
        id: json["_id"],
        question: json["question"],
      );

  Map<String, dynamic> toJson() => {
        "answer": List<dynamic>.from(answer!.map((x) => x)),
        "_id": id,
        "question": question,
      };
}
