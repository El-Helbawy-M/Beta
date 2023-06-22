import 'package:flutter/material.dart';

import '../../../utilities/theme/text_styles.dart';

class CardValueView extends StatelessWidget {
  const CardValueView({
    super.key,
    required this.title,
    required this.value,
  });
  final String title, value;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: AppTextStyles.w400.copyWith(fontSize: 14),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: AppTextStyles.w600.copyWith(
                fontSize: 18, color: Theme.of(context).colorScheme.primary),
          ),
        ],
      ),
    );
  }
}
