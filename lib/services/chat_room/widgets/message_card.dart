import 'package:flutter/material.dart';

import '../../../handlers/icon_handler.dart';
import '../../../utilities/theme/media.dart';
import '../../../utilities/theme/text_styles.dart';

class MessageCard extends StatelessWidget {
  const MessageCard({
    super.key,
    required this.isSender,
  });
  final bool isSender;
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
              backgroundImage: NetworkImage("https://cdn.pixabay.com/photo/2015/04/23/22/00/tree-736885__480.jpg"),
            ),
            const SizedBox(width: 8),
            Container(
              width: MediaHelper.width - 100,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomRight: const Radius.circular(15),
                  bottomLeft: const Radius.circular(15),
                  topLeft: Radius.circular(isSender ? 15 : 0),
                  topRight: Radius.circular(!isSender ? 15 : 0),
                ),
                color: isSender ? Theme.of(context).colorScheme.primary.withOpacity(.7) : Theme.of(context).colorScheme.onPrimaryContainer,
              ),
              child: Text(
                "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
                style: AppTextStyles.w500.copyWith(fontSize: 14, color: isSender ? Colors.white : Colors.black),
                softWrap: true,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          textDirection: !isSender ? TextDirection.ltr : TextDirection.rtl,
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
              "12:30",
              style: AppTextStyles.w600.copyWith(fontSize: 12, color: Theme.of(context).hintColor),
            ),
          ],
        ),
        SizedBox(height: 24),
      ],
    );
  }
}
