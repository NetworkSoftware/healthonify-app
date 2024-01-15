class Dishes {
  Dishes({
    this.id,
    this.name,
    this.foodTypeId,
    this.foodCategoryId,
    this.nutrition,
    this.nutritionInGm,
    this.mealTime,
    this.mediaLink,
    this.perUnit,
    this.unit,
    this.vegOrNonVeg,
    this.foodSubCategoryId,
  });

  String? id;
  String? name;
  FoodId? foodTypeId;
  FoodId? foodCategoryId;
  FoodId? foodSubCategoryId;
  List<Nutrition>? nutrition;
  NutritionInGm? nutritionInGm;
  String? mealTime;
  String? mediaLink;
  PerUnit? perUnit;
  int? unit;
  String? vegOrNonVeg;

  factory Dishes.fromJson(Map<String, dynamic> json) => Dishes(
        id: json["_id"],
        name: json["name"],
        foodTypeId: json["foodTypeId"] == null
            ? null
            : FoodId.fromJson(json["foodTypeId"]),
        foodCategoryId: json["foodCategoryId"] == null
            ? null
            : FoodId.fromJson(json["foodCategoryId"]),
        foodSubCategoryId: json["foodCategoryId"] == null
            ? null
            : FoodId.fromJson(json["foodCategoryId"]),
        nutrition: List<Nutrition>.from(
            json["nutrition"].map((x) => Nutrition.fromJson(x))),
        nutritionInGm: json["nutritionInGm"] == null
            ? null
            : NutritionInGm.fromJson(json["nutritionInGm"]),
        mealTime: json["mealTime"],
        mediaLink: json["mediaLink"],
        perUnit:
            json["perUnit"] == null ? null : PerUnit.fromJson(json["perUnit"]),
        unit: json["Unit"] ?? 0,
        vegOrNonVeg: json["Veg/NonVeg"],
      );

  Map<String, dynamic> dataJson() => {
        "_id": id,
        "name": name,
        "foodTypeId": foodTypeId!.perFoodIdJson(),
        "foodCategoryId": foodCategoryId!.perFoodIdJson(),
        "foodSubCategoryId": foodSubCategoryId!.perFoodIdJson(),
        "nutrition": List<dynamic>.from(nutrition!.map((x) => x.toJson())),
        "nutritionInGm": nutritionInGm!,
        "mealTime": mealTime,
        "mediaLink": mediaLink,
        "perUnit": perUnit!.perUnitJson(),
        "Unit": unit,
        "Veg/NonVeg": vegOrNonVeg,
      };
}

class Nutrition {
  Nutrition({
    this.proteins,
    this.carbs,
    this.fats,
    this.fiber,
    this.id,
  });

  NutrQuantity? proteins;
  NutrQuantity? carbs;
  NutrQuantity? fats;
  NutrQuantity? fiber;
  String? id;

  factory Nutrition.fromJson(Map<String, dynamic> json) => Nutrition(
        proteins: NutrQuantity.fromJson(json["proteins"]),
        carbs: NutrQuantity.fromJson(json["carbs"]),
        fats: NutrQuantity.fromJson(json["fats"]),
        fiber: NutrQuantity.fromJson(json["fiber"]),
        id: json["_id"],
      );

  Map<String, dynamic> toJson() => {
        "proteins": proteins!.toJson(),
        "carbs": carbs!.toJson(),
        "fats": fats!.toJson(),
        "fiber": fiber!.toJson(),
        "_id": id,
      };
}

class NutritionInGm {
  double? fats;
  double? proteins;
  double? fiber;
  double? carbs;

  NutritionInGm({this.fats, this.proteins, this.fiber, this.carbs});

  factory NutritionInGm.fromJson(Map<String, dynamic> json) => NutritionInGm(
        fats: double.parse(json['fats'].toString()),
        proteins:
            double.parse(json['proteins'].toString()),
        fiber: double.parse(json['fiber'].toString()),
        carbs: double.parse(json['carbs'].toString()),
      );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['fats'] = fats;
    data['proteins'] = proteins;
    data['fiber'] = fiber;
    data['carbs'] = carbs;
    return data;
  }
}

class NutrQuantity {
  NutrQuantity({
    this.quantity,
  });

  double? quantity;

  factory NutrQuantity.fromJson(Map<String, dynamic> json) => NutrQuantity(
        quantity:
            json["quantity"] != null ? double.parse(json["quantity"]) : 0.0,
      );

  Map<String, dynamic> toJson() => {
        "quantity": quantity,
      };
}

class PerUnit {
  PerUnit({
    this.quantity,
    this.weight,
    this.calories,
  });

  String? quantity;
  String? weight;
  double? calories;

  factory PerUnit.fromJson(Map<String, dynamic> json) => PerUnit(
        quantity: json["quantity"],
        calories: json["calories"].toDouble(),
        weight: json["weight"] ?? "0g",
      );

  Map<String, dynamic> perUnitJson() => {
        "calories": calories,
        "quantity": quantity,
        "weight": weight,
      };
}

class FoodId {
  FoodId({
    this.id,
    this.name,
  });

  String? id;
  String? name;

  factory FoodId.fromJson(Map<String, dynamic> json) => FoodId(
        id: json["_id"],
        name: json["name"],
      );

  Map<String, dynamic> perFoodIdJson() => {
        "id": id,
        "name": name,
      };
}
