import 'dart:convert';

DietAnalysis? dietAnalysisFromJson(String str) =>
    DietAnalysis.fromJson(json.decode(str));

String dietAnalysisToJson(DietAnalysis? data) => json.encode(data!.toJson());

class DietAnalysis {
  DietAnalysis({
    this.totalCalories,
    this.dietPercentagesData,
  });

  int? totalCalories;
  List<DietPercentagesDatum?>? dietPercentagesData;

  factory DietAnalysis.fromJson(Map<String, dynamic> json) => DietAnalysis(
        totalCalories: json["totalCalories"],
        dietPercentagesData: json["dietPercentagesData"] == null
            ? []
            : List<DietPercentagesDatum?>.from(json["dietPercentagesData"]!
                .map((x) => DietPercentagesDatum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "totalCalories": totalCalories,
        "dietPercentagesData": dietPercentagesData == null
            ? []
            : List<dynamic>.from(dietPercentagesData!.map((x) => x!.toJson())),
      };
}

class DietPercentagesDatum {
  DietPercentagesDatum({
    this.name,
    this.caloriesCount,
    this.percentage,
  });

  String? name;
  int? caloriesCount;
  String? percentage;

  factory DietPercentagesDatum.fromJson(Map<String, dynamic> json) =>
      DietPercentagesDatum(
        name: json["name"],
        caloriesCount: json["caloriesCount"],
        percentage: json["percentage"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "caloriesCount": caloriesCount,
        "percentage": percentage,
      };
}
