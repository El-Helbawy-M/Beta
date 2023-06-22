import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project_base/handlers/shared_handler.dart';
import 'package:flutter_project_base/utilities/theme/text_styles.dart';

import '../model/chat_model.dart';
import '../widgets/chat_person_card.dart';

class ChatListPage extends StatefulWidget {
  const ChatListPage({super.key});

  @override
  State<ChatListPage> createState() => _ChatListPageState();
}

class _ChatListPageState extends State<ChatListPage> {
  FirebaseFirestore cloudFireStore = FirebaseFirestore.instance;

  bool loading = true;
  late int userId;

  List<ChatModel> chats = [];
  @override
  void initState() {
    initData();
    super.initState();
  }

  void initData() async {
    loading = true;
    setState(() {});
    await getUserId();
    await getChats();
    loading = false;
    setState(() {});
  }

  Future<void> getUserId() async {
    userId = await SharedHandler.instance
        ?.getData(key: SharedKeys().user, valueType: ValueType.map)['id'];
  }

  Future<void> getChats() async {
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore
        .instance
        .collection('Chats')
        .where('patentId', isEqualTo: userId)
        .get();

    for (var data in querySnapshot.docs) {
      chats.add(ChatModel.fromFireStore(data));
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              children: [
                Text(
                  "المحادثات",
                  style: AppTextStyles.w500.copyWith(fontSize: 18),
                ),
                const Spacer(),
                const Icon(Icons.menu),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Divider(
            height: 0,
            color: Theme.of(context).dividerColor,
          ),
          Expanded(
            child: loading
                ? Center(
                    child: CircularProgressIndicator(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  )
                : ListView.separated(
                    itemBuilder: (_, int index) => ChatPersonCard(chats[index]),
                    separatorBuilder: (_, __) => const Divider(),
                    itemCount: chats.length,
                  ),
          ),
        ],
      ),
    );
  }
}
