class BMIModel {
  String? weight, height, age, gender, tool, neck, waist, hips;
  BMIModel({
    this.weight,
    this.height,
    this.age,
    this.gender,
    this.tool,
    this.neck,
    this.waist,
    this.hips,
  });
}

class MacroCalculator {
  String? totalCalories;
  String? proteinInGrams;
  String? carbInGrams;
  String? fatInGrams;
  MacroCalculator({
    this.carbInGrams,
    this.fatInGrams,
    this.proteinInGrams,
    this.totalCalories,
  });
}

class DietType {
  String? dietTypeName;
  String? dietId;

  DietType({
    this.dietId,
    this.dietTypeName,
  });
}

class CalorieIntakeModel {
  String? currentCaloriesPerDay;
  String? caloriesGoalPerDay;
  String? currentWeight;
  String? targetWeight;
  String? goal;
  String? activityLevel;

  CalorieIntakeModel({
    this.activityLevel,
    this.caloriesGoalPerDay,
    this.currentCaloriesPerDay,
    this.currentWeight,
    this.goal,
    this.targetWeight,
  });
}
