class MealElementModel {
  String? name;
  num? calories, carbohydrates, protein, fat;
  static Map calculateTotalValues(List<MealElementModel> elements) {
    num totalCalories = 0, totalCarbohydrates = 0, totalProtein = 0, totalFat = 0;
    elements.forEach((element) {
      totalCalories += element.calories!;
      totalCarbohydrates += element.carbohydrates!;
      totalProtein += element.protein!;
      totalFat += element.fat!;
    });
    return {
      "totalCalories": totalCalories,
      "totalCarbohydrates": totalCarbohydrates,
      "totalProtein": totalProtein,
      "totalFat": totalFat,
    };
  }
}
