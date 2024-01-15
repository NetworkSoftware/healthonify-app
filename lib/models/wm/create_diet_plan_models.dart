import 'package:healthonify_mobile/models/wm/dish_model.dart';

class Meal {
  Meal({
    this.id,
    this.mealOrder,
    this.mealTime,
    this.dishes,
    this.mealName,
  });

  String? id;
  int? mealOrder;
  String? mealTime;
  List<CreateDietDish>? dishes;
  String? mealName;

  factory Meal.fromJson(Map<String, dynamic> json) => Meal(
        id: json["_id"],
        mealOrder: json["mealOrder"],
        mealTime: json["mealTime"],
        dishes: List<CreateDietDish>.from(
            json["dishes"].map((x) => CreateDietDish.fromJson(x))),
        mealName: json["mealName"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "mealOrder": mealOrder,
        "mealTime": mealTime,
        "dishes": List<dynamic>.from(dishes!.map((x) => x.dishJson())),
        "mealName": mealName,
      };
}

class CreateDietPlanModel {
  String? userId, name, type, level, goal, planType, validity, note;
  List<CreateDietDays>? dietDaysDetails;
  List<CreateDietDays>? weeklyDetails;
  CreateDietPlanModel(
      {this.userId,
      this.name,
      this.type,
      this.level,
      this.goal,
      this.planType,
      this.validity,
      this.note,
      this.dietDaysDetails});
}

class CreateDietDays {
  String? day;
  List<Meal>? meal;
  CreateDietDays({
    this.day,
    this.meal,
  });
}

class CreateDietDish {
  CreateDietDish({
    this.dishId,
    this.unit,
    this.quantity,
    this.alternateFood,
    this.name,
    this.nutrition,
    this.perUnit,
  });

  String? dishId;
  String? unit;
  double? quantity;
  List<CreateDietDish>? alternateFood;
  String? name;
  List<Nutrition>? nutrition;
  PerUnit? perUnit;

  factory CreateDietDish.fromJson(Map<String, dynamic> json) => CreateDietDish(
        dishId: json["dishId"],
        unit: json["unit"],
        quantity: json["quantity"],
        name: json['name'],
        nutrition: List<Nutrition>.from(
            json["nutrition"].map((x) => Nutrition.fromJson(x))),
        alternateFood: json["alternateFood"] == null
            ? null
            : List<CreateDietDish>.from(
                json["alternateFood"].map(
                  (x) => CreateDietDish.fromJson(x),
                ),
              ),
        perUnit:
            json["perUnit"] == null ? null : PerUnit.fromJson(json["perUnit"]),
      );

  Map<String, dynamic> dishJson() => {
        "dishId": dishId,
        "unit": unit,
        "quantity": quantity,
        "alternateFood": alternateFood,
        "nutrition": List<dynamic>.from(nutrition!.map((x) => x.toJson())),
        "name": name,
        "perUnit": perUnit!.perUnitJson(),
      };
}


// {
//     "userId":"628e07c3295cbb2a64996d2d",     //userId or expertId
//     "name":"Teja Personal Diet Plan",
//     "type":"individual",                   //individual or free or paid
//     "level":"beginner",
//     "goal":"weightLoss",
//     "planType":"regular",
//     "validity":30,
//     "note":"Dummy note",
//     "regularDetails":[{
//         "day":"monday",
//         "meals":[{
//             "mealOrder":1,
//             "mealTime":"08:00 AM",
//             "mealName":"Dal Tadka",
//             "dishes":[{
//                 "dishId":"632abb9e9ff2750d6473df7e",
//                 "unit":"grams",
//                 "quantity":1,
//                 "alternateFood":[{
//                     "dishId":"632abb9e9ff2750d6473df7f",
//                     "unit":"grams",
//                     "quantity":1
//                 }]
//             }]
//         }]
//     }]
// }
