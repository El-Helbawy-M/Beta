// To parse this JSON data, do
//
//     final medicineModel = medicineModelFromJson(jsonString);

import 'dart:convert';

MedicineModel medicineModelFromJson(String str) =>
    MedicineModel.fromJson(json.decode(str));

String medicineModelToJson(MedicineModel data) => json.encode(data.toJson());

class MedicineModel {
  final String? medicationType;
  final String? name;
  final String? isInsulin;
  final String? insulinType;
  final String? dose;
  final dynamic reminderTimes;
  final dynamic reminderDuration;
  final DateTime? date;
  final String? time;

  MedicineModel({
    this.medicationType,
    this.name,
    this.isInsulin,
    this.insulinType,
    this.dose,
    this.reminderTimes,
    this.reminderDuration,
    this.date,
    this.time,
  });

  factory MedicineModel.fromJson(Map<String, dynamic> json) => MedicineModel(
        medicationType: json["medication_type"],
        name: json["name"],
        isInsulin: json["is_insulin"],
        insulinType: json["insulin_type"],
        dose: json["dose"],
        reminderTimes: json["reminder_times"],
        reminderDuration: json["reminder_duration"],
        date: json["date"] == null ? null : DateTime.parse(json["date"]),
        time: json["time"],
      );

  Map<String, dynamic> toJson() => {
        "medication_type": medicationType,
        "name": name,
        "is_insulin": isInsulin,
        "insulin_type": insulinType,
        "dose": dose,
        "reminder_times": reminderTimes,
        "reminder_duration": reminderDuration,
        "date": date?.toIso8601String(),
        "time": time,
      };
}
