class HraModel {
  String? questionId;
  String? question;
  int? order;
  List<Options>? options;
  

  HraModel({
    this.options,
    this.order,
    this.question,
    this.questionId,
  });
}

class Options {
  String? id;
  String? optionValue;
  int? points;

  Options({
    this.id,
    this.optionValue,
    this.points,
  });

  factory Options.fromJson(Map<String, dynamic> json) => Options(
        id: json["_id"],
        optionValue: json["optionValue"],
        points: json["points"],
      );
}

class HraAnswerModel {
  String? id;
  String? userId;
  String? reportUrl;
  List<AnswersModel>? answers;
  int? hraScore;
  int? maxScore;
  String? createdAt;

  HraAnswerModel({
    this.id,
    this.userId,
    this.reportUrl,
    this.answers,
    this.hraScore,
    this.maxScore,
    this.createdAt,
  });
}

class AnswersModel {
  AnswersModel({
    this.points,
    this.id,
    this.questionId,
    this.answer,
  });

  int? points;
  String? id;
  QuestionId? questionId;
  String? answer;

  factory AnswersModel.fromJson(Map<String, dynamic> json) => AnswersModel(
        points: json["points"],
        id: json["_id"],
        questionId: QuestionId.fromJson(json["questionId"]),
        answer: json["answer"],
      );
}

class QuestionId {
  QuestionId({
    this.id,
    this.question,
  });

  String? id;
  String? question;

  factory QuestionId.fromJson(Map<String, dynamic> json) => QuestionId(
        id: json["_id"],
        question: json["question"],
      );
}
