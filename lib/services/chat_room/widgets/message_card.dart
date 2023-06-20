// ignore_for_file: unused_import, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;

import '../../../handlers/icon_handler.dart';
import '../../../utilities/theme/media.dart';
import '../../../utilities/theme/text_styles.dart';
import '../models/message_model.dart';

class MessageCard extends StatelessWidget {
  const MessageCard({
    super.key,
    required this.message,
    required this.userId,
  });
  final MessageModel message;
  final int userId;

  bool get isSender => message.senderId == userId;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          textDirection: !isSender ? TextDirection.ltr : TextDirection.rtl,
          children: [
            CircleAvatar(
              radius: 15,
              backgroundImage: NetworkImage(message.photo),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Container(
                margin: EdgeInsets.only(
                    left: isSender ? 42 : 0, right: isSender ? 0 : 42),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomRight: const Radius.circular(15),
                    bottomLeft: const Radius.circular(15),
                    topLeft: Radius.circular(isSender ? 15 : 0),
                    topRight: Radius.circular(!isSender ? 15 : 0),
                  ),
                  color: isSender
                      ? Theme.of(context).colorScheme.primary.withOpacity(.7)
                      : Theme.of(context).colorScheme.onPrimaryContainer,
                ),
                child: Text(
                  message.text,
                  style: AppTextStyles.w500.copyWith(
                      fontSize: 14,
                      color: isSender ? Colors.white : Colors.black),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          textDirection: !isSender ? TextDirection.ltr : TextDirection.rtl,
          children: [
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
              intl.DateFormat('dd/MM/yyyy hh:mm a')
                  .format(DateTime.parse(message.createdDate)),
              style: AppTextStyles.w600
                  .copyWith(fontSize: 12, color: Theme.of(context).hintColor),
            ),
          ],
        ),
        SizedBox(height: 24),
      ],
    );
  }
}
