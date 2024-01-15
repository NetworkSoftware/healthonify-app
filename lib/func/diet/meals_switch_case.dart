class MealSwitchCase {
  String upperToLower(String value) {
    String result;
    switch (value) {
      case "Breakfast":
        result = "breakfast";
        break;
      case "Morning Snack":
        result = "morningSnack";
        break;
      case "Lunch":
        result = "lunch";
        break;
      case "Afternoon Snack":
        result = "afternoonSnack";
        break;
      case "Dinner":
        result = "dinner";
        break;
      default:
        result = "breakfast";
    }
    return result;
  }

  String lowerToUpper(String value) {
    String result;
    switch (value) {
      case "breakfast":
        result = "Breakfast";
        break;
      case "morningSnack":
        result = "Morning Snack";
        break;
      case "lunch":
        result = "Lunch";
        break;
      case "afternoonSnack":
        result = "Afternoon Snack";
        break;
      case "dinner":
        result = "Dinner";
        break;
      default:
        result = "Breakfast";
    }
    return result;
  }
}
