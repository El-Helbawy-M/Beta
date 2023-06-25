import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project_base/handlers/icon_handler.dart';
import 'package:flutter_project_base/services/chats/model/chat_model.dart';
import 'package:flutter_project_base/utilities/components/arrow_back.dart';
import 'package:flutter_project_base/utilities/components/custom_page_body.dart';
import 'package:flutter_project_base/utilities/theme/text_styles.dart';
import 'package:image_picker/image_picker.dart';

import '../../../routers/navigator.dart';
import '../../../routers/routers.dart';
import '../models/message_model.dart';
import '../widgets/message_card.dart';

class ChatRoomPage extends StatefulWidget {
  const ChatRoomPage(this.chat, {super.key, required this.userId});
  final ChatModel chat;
  final int userId;

  @override
  State<ChatRoomPage> createState() => _ChatRoomPageState();
}

class _ChatRoomPageState extends State<ChatRoomPage> {
  List<MessageModel> messages = <MessageModel>[];
  final FirebaseStorage _storage = FirebaseStorage.instance;

  bool loading = true;
  @override
  void initState() {
    // getChatMessages();
    super.initState();
  }

  Future<void> getChatMessages() async {
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore
        .instance
        .collection('Chats')
        .doc(widget.chat.id)
        .collection('Messages')
        .orderBy(createdDateKey, descending: true)
        .get();
    messages.clear();
    for (var data in querySnapshot.docs) {
      messages.add(MessageModel.fromFireStore(data));
    }

    loading = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return CustomPageBody(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: .2,
        leading: Row(
          children: [
            const SizedBox(width: 16),
            const ArrowBack(),
            const SizedBox(width: 8),
            Stack(
              alignment: Alignment.center,
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundImage: NetworkImage(widget.chat.doctorPhoto),
                ),
                Positioned(
                  right: 36,
                  top: 36,
                  child: Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                      border: Border.all(
                          color: Theme.of(context).scaffoldBackgroundColor,
                          width: 2),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        leadingWidth: 86,
        titleSpacing: 12,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.chat.doctorName,
              style: AppTextStyles.w600.copyWith(fontSize: 13),
            ),
            // const SizedBox(height: 4),
            // Text(
            //   "متصل",
            //   style: AppTextStyles.w600
            //       .copyWith(fontSize: 11, color: Colors.green),
            // ),
          ],
        ),
        actions: [
          InkWell(
            onTap: () =>
                CustomNavigator.push(Routes.videoCall, arguments: widget.chat),
            child: Icon(Icons.video_camera_front,
                color: Theme.of(context).colorScheme.primary),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: InkWell(
                onTap: () => CustomNavigator.push(Routes.voiceCall,
                    arguments: widget.chat),
                child: Icon(Icons.call,
                    color: Theme.of(context).colorScheme.primary)),
          ),
          const SizedBox(width: 16),
        ],
      ),
      //=================================================================================================
      //=================================================================================================
      //=================================================================================================
      //=================================================================================================
      //=================================================================================================
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('Chats')
                    .doc(widget.chat.id)
                    .collection('Messages')
                    .orderBy(createdDateKey, descending: true)
                    .snapshots(),
                builder: (_, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    );
                  } else {
                    messages.clear();
                    for (var data in snapshot.data!.docs) {
                      messages.add(MessageModel.fromFireStore(data));
                    }

                    return ListView.separated(
                      reverse: true,
                      itemBuilder: (_, int index) => MessageCard(
                        message: messages[index],
                        userId: widget.userId,
                      ),
                      separatorBuilder: (_, __) => const SizedBox(height: 8),
                      itemCount: messages.length,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                    );
                  }
                }),
          ),

          //loading
          //                 ? Center(
          //                     child: CircularProgressIndicator(
          //                       color: Theme.of(context).colorScheme.primary,
          //                     ),
          //                   )
          //                 : ListView.separated(
          //                     reverse: true,
          //                     itemBuilder: (_, int index) => MessageCard(
          //                       message: messages[index],
          //                       userId: widget.userId,
          //                     ),
          //                     separatorBuilder: (_, __) => const SizedBox(height: 8),
          //                     itemCount: messages.length,
          //                     padding: const EdgeInsets.symmetric(horizontal: 16),
          //                   )
          Divider(
            height: 0,
            color: Theme.of(context).dividerColor,
          ),
          ChatTextField(
            onSend: sendMessage,
            onImageTapped: () async {
              XFile? file =
                  await ImagePicker().pickImage(source: ImageSource.gallery);

              if (file == null) {
                //Create a reference to the location you want to upload to in firebase
                Reference reference = _storage.ref().child("images/");

                //Upload the file to firebase
                reference.putFile(File(file!.path));

                // Waits till the file is uploaded then stores the download url
                String location = await reference.getDownloadURL();

                FirebaseFirestore.instance
                    .collection('Chats')
                    .doc(widget.chat.id)
                    .collection('Messages')
                    .add({
                  'text': location,
                  'photo': '',
                  'type': MessageType.photo.name,
                  'senderId': widget.userId,
                  'createdDate': DateTime.now().toString(),
                });

                FirebaseFirestore.instance
                    .collection('Chats')
                    .doc(widget.chat.id)
                    .update({
                  lastMessageSenderIdKey: widget.userId,
                  lastMessageKey: 'image',
                  lastMessageDateKey: DateTime.now().toString(),
                });
              }
            },
          ),
        ],
      ),
    );
  }

  void sendMessage(String value) async {
    FirebaseFirestore.instance
        .collection('Chats')
        .doc(widget.chat.id)
        .collection('Messages')
        .add({
      'text': value,
      'photo': '',
      'type': MessageType.text.name,
      'senderId': widget.userId,
      'createdDate': DateTime.now().toString(),
    });

    FirebaseFirestore.instance.collection('Chats').doc(widget.chat.id).update({
      lastMessageSenderIdKey: widget.userId,
      lastMessageKey: value,
      lastMessageDateKey: DateTime.now().toString(),
    });
    // await getChatMessages();
  }
}

class ChatTextField extends StatefulWidget {
  const ChatTextField({
    super.key,
    this.onSend,
    this.onImageTapped,
  });
  final Function(String)? onSend;
  final Function()? onImageTapped;
  @override
  State<ChatTextField> createState() => _ChatTextFieldState();
}

class _ChatTextFieldState extends State<ChatTextField> {
  TextEditingController controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 24),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: SizedBox(
              height: 48,
              child: TextField(
                controller: controller,
                onChanged: (value) => setState(() {}),
                keyboardType: TextInputType.multiline,
                expands: true,
                maxLines: null,
                minLines: null,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Theme.of(context).colorScheme.onPrimaryContainer,
                  hintText: "اكتب رسالة ...",
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          InkWell(
            onTap: widget.onImageTapped,
            child: drawSvgIcon("image",
                width: 24,
                height: 24,
                iconColor: Theme.of(context).colorScheme.primary),
          ),
          if (controller.text.isNotEmpty) const SizedBox(width: 8),
          if (controller.text.isNotEmpty)
            RotatedBox(
              quarterTurns: 3,
              child: GestureDetector(
                onTap: () => setState(
                  () {
                    widget.onSend?.call(controller.text);
                    controller.clear();
                  },
                ),
                child: drawSvgIcon(
                  "send",
                  width: 24,
                  height: 24,
                  iconColor: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
