import 'package:cloud_firestore/cloud_firestore.dart';

const String patentIdKey = 'patentId';
const String doctorPhotoKey = 'doctorPhoto';
const String lastMessageKey = 'lastMessage';
const String doctorNameKey = 'doctorName';
const String patentNameKey = 'patentName';
const String lastMessageSenderIdKey = 'lastMessageSenderId';
const String doctorIdKey = 'doctorId';
const String patentPhotoKey = 'patentPhoto';
const String lastMessageDateKey = 'lastMessageDate';

class ChatModel {
  final String id,
      doctorName,
      doctorPhoto,
      patentName,
      patentPhoto,
      lastMessage,
      lastMessageDate;
  final int doctorId, patentId, lastMessageSenderId;

  const ChatModel({
    required this.id,
    required this.patentId,
    required this.doctorPhoto,
    required this.lastMessage,
    required this.doctorName,
    required this.patentName,
    required this.lastMessageSenderId,
    required this.doctorId,
    required this.patentPhoto,
    required this.lastMessageDate,
  });

  factory ChatModel.fromFireStore(DocumentSnapshot document) => ChatModel(
        id: document.id,
        patentId: document.get(patentIdKey),
        doctorPhoto: document.get(doctorPhotoKey),
        lastMessage: document.get(lastMessageKey),
        doctorName: document.get(doctorNameKey),
        patentName: document.get(doctorPhotoKey),
        lastMessageSenderId: document.get(lastMessageSenderIdKey),
        doctorId: document.get(doctorIdKey),
        patentPhoto: document.get(patentPhotoKey),
        lastMessageDate: document.get(lastMessageDateKey),
      );
}
