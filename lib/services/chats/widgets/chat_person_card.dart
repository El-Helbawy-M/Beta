import 'package:flutter/material.dart';
import 'package:flutter_project_base/routers/navigator.dart';
import 'package:flutter_project_base/routers/routers.dart';

import '../../../utilities/theme/text_styles.dart';

class ChatPersonCard extends StatelessWidget {
  const ChatPersonCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        CustomNavigator.push(Routes.chatRoom);
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
                  backgroundImage: NetworkImage("https://cdn.pixabay.com/photo/2015/04/23/22/00/tree-736885__480.jpg"),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("محمد احمد", style: AppTextStyles.w500.copyWith(fontSize: 16)),
                      const SizedBox(height: 4),
                      Text("كيف حالك\nهل انت بخير ؟ ...", style: AppTextStyles.w500.copyWith(fontSize: 14, color: Theme.of(context).hintColor)),
                    ],
                  ),
                ),
                Text(
                  "الخميس - 12:30",
                  style: AppTextStyles.w500.copyWith(fontSize: 12, color: Theme.of(context).colorScheme.primary),
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
