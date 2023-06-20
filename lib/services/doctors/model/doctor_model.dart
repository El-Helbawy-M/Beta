// To parse this JSON data, do
//
//     final doctorModel = doctorModelFromJson(jsonString);

import 'dart:convert';

DoctorModel doctorModelFromJson(String str) =>
    DoctorModel.fromJson(json.decode(str));

String doctorModelToJson(DoctorModel data) => json.encode(data.toJson());

class DoctorModel {
  final int? id;
  final String? name;
  final String? email;
  final String? phone;
  final String? profilePic;
  final String? department;
  final String? bio;
  final List<AppointmentModel>? appointments;

  DoctorModel({
    this.id,
    this.name,
    this.email,
    this.phone,
    this.profilePic,
    this.department,
    this.bio,
    this.appointments,
  });

  factory DoctorModel.fromJson(Map<String, dynamic> json) => DoctorModel(
        id: json["id"],
        name: json["name"],
        email: json["email"],
        phone: json["phone"],
        profilePic: json["profile_pic"],
        department: json["department"],
        bio: json["bio"],
        appointments: json["appointments"] == null
            ? []
            : List<AppointmentModel>.from(
                json["appointments"]!.map((x) => AppointmentModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "email": email,
        "phone": phone,
        "profile_pic": profilePic,
        "department": department,
        "bio": bio,
        "appointments": appointments == null
            ? []
            : List<dynamic>.from(appointments!.map((x) => x.toJson())),
      };
}

class AppointmentModel {
  final int? id;
  final DateTime? day;
  final List<String>? intervals;
  final String? status;
  final String? sessionType;
  final String? price;

  AppointmentModel({
    this.id,
    this.day,
    this.intervals,
    this.status,
    this.sessionType,
    this.price,
  });

  factory AppointmentModel.fromJson(Map<String, dynamic> json) =>
      AppointmentModel(
        id: json["id"],
        day: json["day"] == null ? null : DateTime.parse(json["day"]),
        intervals: json["intervals"] == null
            ? []
            : List<String>.from(json["intervals"]!.map((x) => x)),
        status: json["status"],
        sessionType: json["session_type"],
        price: json["price"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "day":
            "${day!.year.toString().padLeft(4, '0')}-${day!.month.toString().padLeft(2, '0')}-${day!.day.toString().padLeft(2, '0')}",
        "intervals": intervals == null
            ? []
            : List<dynamic>.from(intervals!.map((x) => x)),
        "status": status,
        "session_type": sessionType,
        "price": price,
      };
}
