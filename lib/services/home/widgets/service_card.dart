import 'package:flutter/material.dart';

import '../../../utilities/theme/text_styles.dart';

class ServiceCard extends StatelessWidget {
  const ServiceCard({
    super.key,
    required this.onTaps,
    required this.imagesPaths,
    required this.labels,
  });

  final Function()? onTaps;
  final String imagesPaths;
  final String labels;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTaps,
      child: Container(
        height: 64,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Theme.of(context).dividerColor.withOpacity(.05)),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).dividerColor.withOpacity(.02),
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Image.asset("assets/images/${imagesPaths}.png", width: 32, height: 32),
            const SizedBox(width: 16),
            Text(
              labels,
              style: AppTextStyles.w500.copyWith(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
