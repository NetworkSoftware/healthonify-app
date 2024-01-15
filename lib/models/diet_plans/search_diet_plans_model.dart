import 'dart:convert';

SearchDietPlanModel searchDietPlanModelFromJson(String str) =>
    SearchDietPlanModel.fromJson(json.decode(str));

String searchDietPlanModelToJson(SearchDietPlanModel data) =>
    json.encode(data.toJson());

class SearchDietPlanModel {
  SearchDietPlanModel({
    this.id,
    this.userId,
    this.name,
    this.type,
    this.level,
    this.goal,
    this.planType,
    this.validity,
    this.regularDietDetails,
    this.weeklyDetails,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.note,
    this.searchDietPlanModelId,
  });

  String? id;
  String? userId;
  String? name;
  String? type;
  String? level;
  String? goal;
  String? planType;
  int? validity;
  List<RegularDietDetail>? regularDietDetails;
  List<dynamic>? weeklyDetails;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;
  String? note;
  String? searchDietPlanModelId;

  factory SearchDietPlanModel.fromJson(Map<String, dynamic> json) =>
      SearchDietPlanModel(
        id: json["_id"],
        userId: json["userId"],
        name: json["name"],
        type: json["type"],
        level: json["level"],
        goal: json["goal"],
        planType: json["planType"],
        validity: json["validity"],
        regularDietDetails: List<RegularDietDetail>.from(
            json["regularDetails"].map((x) => RegularDietDetail.fromJson(x))),
        weeklyDetails: List<dynamic>.from(json["weeklyDetails"].map((x) => x)),
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        v: json["__v"],
        note: json["note"],
        searchDietPlanModelId: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "userId": userId,
        "name": name,
        "type": type,
        "level": level,
        "goal": goal,
        "planType": planType,
        "validity": validity,
        "regularDetails":
            List<dynamic>.from(regularDietDetails!.map((x) => x.toJson())),
        "weeklyDetails": List<dynamic>.from(weeklyDetails!.map((x) => x)),
        "created_at": createdAt!.toIso8601String(),
        "updated_at": updatedAt!.toIso8601String(),
        "__v": v,
        "note": note,
        "id": searchDietPlanModelId,
      };
}

class RegularDietDetail {
  RegularDietDetail({
    this.id,
    this.day,
    this.meals,
  });

  String? id;
  String? day;
  List<Meal>? meals;

  factory RegularDietDetail.fromJson(Map<String, dynamic> json) =>
      RegularDietDetail(
        id: json["_id"],
        day: json["day"],
        meals: List<Meal>.from(json["meals"].map((x) => Meal.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "day": day,
        "meals": List<dynamic>.from(meals!.map((x) => x.toJson())),
      };
}

class Meal {
  Meal({
    this.id,
    this.mealOrder,
    this.mealTime,
    this.mealName,
    this.dishes,
  });

  String? id;
  int? mealOrder;
  String? mealTime;
  String? mealName;
  List<Dish>? dishes;

  factory Meal.fromJson(Map<String, dynamic> json) => Meal(
        id: json["_id"],
        mealOrder: json["mealOrder"],
        mealTime: json["mealTime"],
        mealName: json["mealName"],
        dishes: List<Dish>.from(json["dishes"].map((x) => Dish.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "mealOrder": mealOrder,
        "mealTime": mealTime,
        "mealName": mealName,
        "dishes": List<dynamic>.from(dishes!.map((x) => x.toJson())),
      };
}

class Dish {
  Dish({
    this.id,
    this.dishId,
    this.unit,
    this.alternateFood,
  });

  String? id;
  DishId? dishId;
  String? unit;
  List<dynamic>? alternateFood;

  factory Dish.fromJson(Map<String, dynamic> json) => Dish(
        id: json["_id"],
        dishId: DishId.fromJson(json["dishId"]),
        unit: json["unit"],
        alternateFood: List<dynamic>.from(json["alternateFood"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "dishId": dishId!.toJson(),
        "unit": unit,
        "alternateFood": List<dynamic>.from(alternateFood!.map((x) => x)),
      };
}

class DishId {
  DishId({
    this.perUnit,
    this.id,
    this.name,
    this.unit,
    this.vegNonVeg,
    this.nutrition,
    this.mediaLink,
    this.foodTypeId,
    this.updatedAt,
    this.foodCategoryId,
    this.foodSubCategoryId,
    this.dishIdId,
  });

  PerUnit? perUnit;
  String? id;
  String? name;
  int? unit;
  String? vegNonVeg;
  List<Nutrition>? nutrition;
  String? mediaLink;
  FoodId? foodTypeId;
  DateTime? updatedAt;
  FoodId? foodCategoryId;
  FoodId? foodSubCategoryId;
  String? dishIdId;

  factory DishId.fromJson(Map<String, dynamic> json) => DishId(
        perUnit: PerUnit.fromJson(json["perUnit"]),
        id: json["_id"],
        name: json["name"],
        unit: json["Unit"],
        vegNonVeg: json["Veg/NonVeg"],
        nutrition: List<Nutrition>.from(
            json["nutrition"].map((x) => Nutrition.fromJson(x))),
        mediaLink: json["mediaLink"],
        foodTypeId: FoodId.fromJson(json["foodTypeId"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        foodCategoryId: FoodId.fromJson(json["foodCategoryId"]),
        foodSubCategoryId: FoodId.fromJson(json["foodSubCategoryId"]),
        dishIdId: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "perUnit": perUnit!.toJson(),
        "_id": id,
        "name": name,
        "Unit": unit,
        "Veg/NonVeg": vegNonVeg,
        "nutrition": List<dynamic>.from(nutrition!.map((x) => x.toJson())),
        "mediaLink": mediaLink,
        "foodTypeId": foodTypeId!.toJson(),
        "updated_at": updatedAt!.toIso8601String(),
        "foodCategoryId": foodCategoryId!.toJson(),
        "foodSubCategoryId": foodSubCategoryId!.toJson(),
        "id": dishIdId,
      };
}

class FoodId {
  FoodId({
    this.id,
    this.name,
    this.foodIdId,
  });

  String? id;
  String? name;
  String? foodIdId;

  factory FoodId.fromJson(Map<String, dynamic> json) => FoodId(
        id: json["_id"],
        name: json["name"],
        foodIdId: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "id": foodIdId,
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

  Carbs? proteins;
  Carbs? carbs;
  Carbs? fats;
  Carbs? fiber;
  String? id;

  factory Nutrition.fromJson(Map<String, dynamic> json) => Nutrition(
        proteins: Carbs.fromJson(json["proteins"]),
        carbs: Carbs.fromJson(json["carbs"]),
        fats: Carbs.fromJson(json["fats"]),
        fiber: Carbs.fromJson(json["fiber"]),
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

class Carbs {
  Carbs({
    this.quantity,
  });

  double? quantity;

  factory Carbs.fromJson(Map<String, dynamic> json) => Carbs(
        quantity: json["quantity"].toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "quantity": quantity,
      };
}

class PerUnit {
  PerUnit({
    this.calories,
    this.quantity,
    this.weight,
  });

  int? calories;
  String? quantity;
  String? weight;

  factory PerUnit.fromJson(Map<String, dynamic> json) => PerUnit(
        calories: json["calories"],
        quantity: json["quantity"],
        weight: json["weight"],
      );

  Map<String, dynamic> toJson() => {
        "calories": calories,
        "quantity": quantity,
        "weight": weight,
      };
}
