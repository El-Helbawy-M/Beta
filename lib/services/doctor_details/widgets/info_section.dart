import 'package:flutter/material.dart';

import '../../../utilities/theme/text_styles.dart';

class InfoSection extends StatelessWidget {
  const InfoSection({
    super.key,
    required this.body,
    this.with24Padding = true,
    this.label = "",
  });
  final Widget body;
  final bool with24Padding;
  final String label;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: with24Padding ? 24 : 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: !with24Padding ? 24 : 0),
            child: Text(
              label,
              style: AppTextStyles.w600.copyWith(fontSize: 18),
            ),
          ),
          const SizedBox(height: 16),
          body,
        ],
      ),
    );
  }
}
