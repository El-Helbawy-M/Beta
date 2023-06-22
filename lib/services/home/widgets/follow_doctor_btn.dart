import 'package:flutter/material.dart';

import '../../../utilities/theme/text_styles.dart';

class FollowDoctorButton extends StatelessWidget {
  const FollowDoctorButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          height: 64,
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          margin: const EdgeInsets.symmetric(horizontal: 24),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            "تابع مع أحد الأطباء",
            style:
                AppTextStyles.w700.copyWith(fontSize: 22, color: Colors.white),
          ),
        ),
        Positioned(
          bottom: 0,
          left: 24,
          child: Image.asset(
            "assets/images/follow_image.png",
            width: 134,
            height: 95,
          ),
        )
      ],
    );
  }
}
