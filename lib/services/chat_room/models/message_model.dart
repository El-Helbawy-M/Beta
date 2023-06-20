import 'package:cloud_firestore/cloud_firestore.dart';

const String textKey = 'text';
const String typeKey = 'type';
const String photoKey = 'photo';
const String senderIdKey = 'senderId';
const String createdDateKey = 'createdDate';

class MessageModel {
  String text, type, photo, createdDate;
  int senderId;

  MessageModel(
      {required this.text,
      required this.type,
      required this.photo,
      required this.senderId,
      required this.createdDate});

  factory MessageModel.fromFireStore(DocumentSnapshot document) => MessageModel(
        text: document.get(textKey),
        type: document.get(typeKey),
        photo: document.get(photoKey),
        senderId: document.get(senderIdKey),
        createdDate: document.get(createdDateKey),
      );
}

enum MessageType { text, photo }
