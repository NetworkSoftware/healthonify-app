class DietPlan {
  DietPlan({
    this.id,
    this.expertId,
    this.name,
    this.type,
    this.level,
    this.goal,
    this.planType,
    this.validity,
    this.note,
    this.weeklyDetails,
  });

  String? id;
  String? expertId;
  String? name;
  String? type;
  String? level;
  String? goal;
  String? planType;
  int? validity;
  String? note;
  List<RegularDetail>? weeklyDetails;

  factory DietPlan.fromJson(Map<String, dynamic> json) => DietPlan(
        id: json["_id"],
        expertId: json["expertId"],
        name: json["name"],
        type: json["type"],
        level: json["level"],
        goal: json["goal"],
        planType: json["planType"],
        validity: json["validity"],
        note: json["note"],
        weeklyDetails: List<RegularDetail>.from(
            json["weeklyDetails"].map((x) => RegularDetail.fromJson(x))),
      );

  Map<String, dynamic> dietJson() => {
        "_id": id,
        "expertId": expertId,
        "name": name,
        "type": type,
        "level": level,
        "goal": goal,
        "planType": planType,
        "validity": validity,
        "note": note,
        "weeklyDetails":
            List<dynamic>.from(weeklyDetails!.map((x) => x.regularJson())),
      };
}

class RegularDetail {
  RegularDetail({
    this.id,
    this.day,
    this.meals,
  });

  String? id;
  String? day;
  List<GetMeal>? meals;

  factory RegularDetail.fromJson(Map<String, dynamic> json) => RegularDetail(
        id: json["_id"],
        day: json["day"],
        meals:
            List<GetMeal>.from(json["meals"].map((x) => GetMeal.fromJson(x))),
      );

  Map<String, dynamic> regularJson() => {
        "_id": id,
        "day": day,
        "meals": List<dynamic>.from(meals!.map((x) => x.toJson())),
      };
}

class GetMeal {
  GetMeal({
    this.id,
    this.mealOrder,
    this.mealTime,
    this.dishes,
    this.mealName,
  });

  String? id;
  int? mealOrder;
  String? mealTime;
  String? mealName;
  List<GetDish>? dishes;

  factory GetMeal.fromJson(Map<String, dynamic> json) => GetMeal(
        id: json["_id"],
        mealOrder: json["mealOrder"],
        mealTime: json["mealTime"],
        dishes:
            List<GetDish>.from(json["dishes"].map((x) => GetDish.fromJson(x))),
        mealName: json["mealName"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "mealOrder": mealOrder,
        "mealTime": mealTime,
        "dishes": List<dynamic>.from(dishes!.map((x) => x.toJson())),
        "mealName": mealName
      };
}

class GetDish {
  GetDish({
    this.id,
    this.dishId,
    this.unit,
    this.quantity,
    this.alternateFood,
  });

  String? id;
  DishId? dishId;
  String? unit;
  double? quantity;
  List<GetDish>? alternateFood;

  factory GetDish.fromJson(Map<String, dynamic> json) => GetDish(
        id: json["_id"],
        dishId: DishId.fromJson(json["dishId"]),
        unit: json["unit"].toString(),
        quantity: json["quantity"].runtimeType == int
            ? json["quantity"].toDouble()
            : double.parse("${json["quantity"]}"),
        alternateFood: json["alternateFood"] == null
            ? null
            : List<GetDish>.from(
                json["alternateFood"].map((x) => GetDish.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "dishId": dishId!.toJson(),
        "unit": unit ?? 0,
        "quantity": quantity,
        "alternateFood": alternateFood == null
            ? null
            : List<dynamic>.from(alternateFood!.map((x) => x.toJson())),
      };
}

class DishId {
  DishId({
    this.id,
    this.name,
    this.unit,
    this.vegNonVeg,
    this.nutrition,
    this.mediaLink,
    this.foodTypeId,
    this.perUnit,
    this.updatedAt,
    this.foodCategoryId,
    this.foodSubCategoryId,
    //this.nutritionInGm
  });

  String? id;
  String? name;
  int? unit;
  String? vegNonVeg;
  List<GetNutrition>? nutrition;
 // NutritionInGm? nutritionInGm;
  String? mediaLink;
  Map<String, dynamic>? foodTypeId;
  GetPerUnit? perUnit;
  DateTime? updatedAt;
  Map<String, dynamic>? foodCategoryId;
  Map<String, dynamic>? foodSubCategoryId;

  factory DishId.fromJson(Map<String, dynamic> json) => DishId(
        id: json["_id"],
        name: json["name"],
        unit: json["Unit"],
        vegNonVeg: json["Veg/NonVeg"],
        nutrition: List<GetNutrition>.from(
            json["nutrition"].map((x) => GetNutrition.fromJson(x))),
        mediaLink: json["mediaLink"],
        foodTypeId: json["foodTypeId"],
        perUnit: GetPerUnit.fromJson(json["perUnit"]),
   // nutritionInGm: NutritionInGm.fromJson(json["nutritionInGm"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        foodCategoryId: json["foodCategoryId"],
        foodSubCategoryId: json["foodSubCategoryId"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "Unit": unit,
        "Veg/NonVeg": vegNonVeg,
        "nutrition": List<dynamic>.from(nutrition!.map((x) => x.toJson())),
        "mediaLink": mediaLink,
        "foodTypeId": foodTypeId,
        "perUnit": perUnit!.toJson(),
        //"nutritionInGm": nutritionInGm!.toJson(),
        "updated_at": updatedAt!.toIso8601String(),
        "foodCategoryId": foodCategoryId,
        "foodSubCategoryId": foodSubCategoryId,
      };
}

class GetNutrition {
  GetNutrition({
    this.id,
    this.proteins,
    this.carbs,
    this.fats,
    this.fiber,
  });

  String? id;
  NutritionDetails? proteins;
  NutritionDetails? carbs;
  NutritionDetails? fats;
  NutritionDetails? fiber;

  factory GetNutrition.fromJson(Map<String, dynamic> json) => GetNutrition(
        id: json["_id"],
        proteins: NutritionDetails.fromJson(json["proteins"]),
        carbs: NutritionDetails.fromJson(json["carbs"]),
        fats: NutritionDetails.fromJson(json["fats"]),
        fiber: NutritionDetails.fromJson(json["fiber"]),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "proteins": proteins!.toJson(),
        "carbs": carbs!.toJson(),
        "fats": fats!.toJson(),
        "fiber": fiber!.toJson(),
      };
}

class NutritionDetails {
  NutritionDetails({
    this.quantity,
  });

  double? quantity;

  factory NutritionDetails.fromJson(Map<String, dynamic> json) =>
      NutritionDetails(
        quantity: double.parse(json["quantity"]),
      );

  Map<String, dynamic> toJson() => {
        "quantity": quantity,
      };
}

class GetPerUnit {
  GetPerUnit({
    this.calories,
    this.quantity,
    this.weight,
  });

  double? calories;
  String? quantity;
  String? weight;

  factory GetPerUnit.fromJson(Map<String, dynamic> json) => GetPerUnit(
        calories: json["calories"].toDouble(),
        quantity: json["quantity"],
        weight: json["weight"],
      );

  Map<String, dynamic> toJson() => {
        "calories": calories,
        "quantity": quantity,
        "weight": weight,
      };
}

class NutritionInGm {
  double? fats;
  double? proteins;
  double? fiber;
  double? carbs;

  NutritionInGm({this.fats, this.proteins, this.fiber, this.carbs});

  NutritionInGm.fromJson(Map<String, dynamic> json) {
    fats = json['fats'];
    proteins = json['proteins'];
    fiber = json['fiber'];
    carbs = json['carbs'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['fats'] = fats;
    data['proteins'] = proteins;
    data['fiber'] = fiber;
    data['carbs'] = carbs;
    return data;
  }
}