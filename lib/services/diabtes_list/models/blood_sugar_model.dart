class BloodSugarItemModel {
  int id;
  String sugarConcentration;
  String measureDescription;
  DateTime date;
  String note;

  BloodSugarItemModel({
    required this.id,
    required this.sugarConcentration,
    required this.measureDescription,
    required this.date,
    required this.note,
  });

  factory BloodSugarItemModel.fromJson(Map<String, dynamic> json) =>
      BloodSugarItemModel(
        id: json["id"],
        sugarConcentration: json["sugar_concentration"],
        measureDescription: json["measure_description"],
        date: DateTime.parse(json["date"]),
        note: json["note"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "sugar_concentration": sugarConcentration,
        "measure_description": measureDescription,
        "date": date.toIso8601String(),
        "note": note,
      };
}
