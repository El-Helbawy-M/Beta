import 'package:flutter/material.dart';
import 'package:flutter_project_base/routers/routers.dart';
import 'package:flutter_project_base/services/chats/model/chat_model.dart';

import '../../../utilities/theme/text_styles.dart';

class ChatPersonCard extends StatelessWidget {
  final ChatModel chat;
  const ChatPersonCard(
    this.chat, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, Routes.chatRoom, arguments: [
          chat,
          chat.patentId,
        ]);
      },
      child: Column(
        children: [
          const SizedBox(height: 16),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundImage: NetworkImage(chat.doctorPhoto),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(chat.doctorName,
                          style: AppTextStyles.w500.copyWith(fontSize: 16)),
                      const SizedBox(height: 4),
                      Text(chat.lastMessage,
                          style: AppTextStyles.w500.copyWith(
                              fontSize: 14,
                              color: Theme.of(context).hintColor)),
                    ],
                  ),
                ),
                Text(
                  chat.lastMessageDate,
                  style: AppTextStyles.w500.copyWith(
                      fontSize: 12,
                      color: Theme.of(context).colorScheme.primary),
                )
              ],
            ),
          ),
          const SizedBox(height: 16),
          Divider(
            height: 0,
            color: Theme.of(context).dividerColor,
          ),
        ],
      ),
    );
  }
}
