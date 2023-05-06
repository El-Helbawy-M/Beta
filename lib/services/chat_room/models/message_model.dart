import 'package:flutter_project_base/base/models/mapper.dart';

class MessageModel extends SingleMapper {
  String? message;
  bool isSender = true;
  int state = 0;
  String? time;
  String? senderImageUrl;

  MessageModel({this.message, this.isSender = true, this.state = 0, this.time, this.senderImageUrl});
  MessageModel.fromJson(Map<String, dynamic> json) {
    message = json["message"];
    time = json["time"];
    senderImageUrl = json["sender_image_url"];
    isSender = json["is_sender"];
    state = json["state"];
  }
  @override
  Mapper fromJson(Map<String, dynamic> json) => MessageModel.fromJson(json);
}
