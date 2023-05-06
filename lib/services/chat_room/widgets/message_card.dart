import 'package:flutter/material.dart';

import '../../../handlers/icon_handler.dart';
import '../../../utilities/theme/media.dart';
import '../../../utilities/theme/text_styles.dart';
import '../models/message_model.dart';

class MessageCard extends StatelessWidget {
  const MessageCard({
    super.key,
    required this.message,
  });
  final MessageModel message;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          textDirection: !message.isSender ? TextDirection.ltr : TextDirection.rtl,
          children: [
            CircleAvatar(
              radius: 15,
              backgroundImage: NetworkImage("https://cdn.pixabay.com/photo/2015/04/23/22/00/tree-736885__480.jpg"),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Container(
                margin: EdgeInsets.only(left: message.isSender ? 42 : 0, right: message.isSender ? 0 : 42),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomRight: const Radius.circular(15),
                    bottomLeft: const Radius.circular(15),
                    topLeft: Radius.circular(message.isSender ? 15 : 0),
                    topRight: Radius.circular(!message.isSender ? 15 : 0),
                  ),
                  color: message.isSender ? Theme.of(context).colorScheme.primary.withOpacity(.7) : Theme.of(context).colorScheme.onPrimaryContainer,
                ),
                child: Text(
                  message.message ?? "",
                  style: AppTextStyles.w500.copyWith(fontSize: 14, color: message.isSender ? Colors.white : Colors.black),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          textDirection: !message.isSender ? TextDirection.ltr : TextDirection.rtl,
          children: [
            const SizedBox(width: 42),
            drawSvgIcon("tick", width: 8, height: 8, iconColor: Colors.green),
            drawSvgIcon("tick", width: 8, height: 8, iconColor: Colors.green),
            const SizedBox(width: 8),
            Text(
              "تمت رؤيتها",
              style: AppTextStyles.w600.copyWith(fontSize: 12, color: Theme.of(context).colorScheme.primary),
            ),
            const SizedBox(width: 8),
            SizedBox(
              height: 12.5,
              child: VerticalDivider(
                width: 0,
                thickness: 1,
                color: Theme.of(context).dividerColor,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              message.time ?? "",
              style: AppTextStyles.w600.copyWith(fontSize: 12, color: Theme.of(context).hintColor),
            ),
          ],
        ),
        SizedBox(height: 24),
      ],
    );
  }
}
