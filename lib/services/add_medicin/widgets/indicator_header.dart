import 'package:flutter/material.dart';

import '../../../utilities/theme/media.dart';

class IndicatorHeader extends StatelessWidget {
  const IndicatorHeader(
      {super.key,
      required this.title,
      this.progress = 1,
      required this.totalSteps});
  final int totalSteps;
  final int progress;
  final String title;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            title,
            style: Theme.of(context).textTheme.headline6,
          ),
        ),
        const SizedBox(height: 16),
        Stack(
          children: [
            Container(
              height: 4,
              width: MediaHelper.width,
              color: Theme.of(context).hintColor.withOpacity(.1),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              height: 4,
              width: MediaHelper.width * (progress / totalSteps),
              color: Theme.of(context).colorScheme.primary,
            ),
          ],
        ),
      ],
    );
  }
}
