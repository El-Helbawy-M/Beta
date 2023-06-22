// To parse this JSON data, do
//
//     final weightModel = weightModelFromJson(jsonString);

import 'dart:convert';

WeightModel weightModelFromJson(String str) =>
    WeightModel.fromJson(json.decode(str));

String weightModelToJson(WeightModel data) => json.encode(data.toJson());

class WeightModel {
  final int? id;
  final String? patientId;
  final String? weight;
  final String? unit;
  final DateTime? date;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  WeightModel({
    this.id,
    this.patientId,
    this.weight,
    this.unit,
    this.date,
    this.createdAt,
    this.updatedAt,
  });

  factory WeightModel.fromJson(Map<String, dynamic> json) => WeightModel(
        id: json["id"],
        patientId: json["patient_id"],
        weight: json["weight"],
        unit: json["unit"],
        date: json["date"] == null ? null : DateTime.parse(json["date"]),
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "patient_id": patientId,
        "weight": weight,
        "unit": unit,
        "date": date?.toIso8601String(),
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}
