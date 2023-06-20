class BloodPressureItemModel {
  int id;
  String systolicPressure;
  String diastolicPressure;
  String arm;
  String pulse;
  DateTime date;
  String note;

  BloodPressureItemModel({
    required this.id,
    required this.systolicPressure,
    required this.diastolicPressure,
    required this.arm,
    required this.pulse,
    required this.date,
    required this.note,
  });

  factory BloodPressureItemModel.fromJson(Map<String, dynamic> json) =>
      BloodPressureItemModel(
        id: json["id"],
        systolicPressure: json["systolic_pressure"],
        diastolicPressure: json["diastolic_pressure"],
        arm: json["arm"],
        pulse: json["pulse"],
        date: DateTime.parse(json["date"]),
        note: json["note"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "systolic_pressure": systolicPressure,
        "diastolic_pressure": diastolicPressure,
        "arm": arm,
        "pulse": pulse,
        "date": date.toIso8601String(),
        "note": note,
      };
}
