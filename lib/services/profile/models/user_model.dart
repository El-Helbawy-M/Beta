class UserModel {
  String name;
  String phone;
  DateTime birthday;
  dynamic sugarType;
  int id;

  UserModel({
    required this.name,
    required this.phone,
    required this.birthday,
    this.sugarType,
    required this.id,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        name: json["name"],
        phone: json["phone"],
        birthday: DateTime.parse(json["birthday"]),
        sugarType: json["sugar_type"],
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "phone": phone,
        "birthday":
            "${birthday.year.toString().padLeft(4, '0')}-${birthday.month.toString().padLeft(2, '0')}-${birthday.day.toString().padLeft(2, '0')}",
        "sugar_type": sugarType,
        "id": id,
      };
}
