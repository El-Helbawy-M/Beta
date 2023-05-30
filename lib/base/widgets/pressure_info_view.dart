import 'package:flutter/material.dart';

import '../../utilities/theme/text_styles.dart';

class InfoView extends StatelessWidget {
  const InfoView({
    super.key,
    required this.title,
    required this.value,
  });
  final String title;
  final Widget value;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTextStyles.w300.copyWith(fontSize: 14),
        ),
        const SizedBox(height: 8),
        value,
      ],
    );
  }
}
