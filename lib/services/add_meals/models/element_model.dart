class MealElementModel {
  String? name;
  num? calories, carbohydrates, protein, fat;

  MealElementModel({
    this.name,
    this.fat,
    this.protein,
    this.carbohydrates,
    this.calories,
  });
  static Map calculateTotalValues(
      String name, List<MealElementModel> elements) {
    num totalCalories = 0,
        totalCarbohydrates = 0,
        totalProtein = 0,
        totalFat = 0;
    for (var element in elements) {
      totalCalories += element.calories!;
      totalCarbohydrates += element.carbohydrates!;
      totalProtein += element.protein!;
      totalFat += element.fat!;
    }
    return {
      "name": name,
      "totalCalories": totalCalories,
      "totalCarbohydrates": totalCarbohydrates,
      "totalProtein": totalProtein,
      "totalFat": totalFat,
    };
  }
}
