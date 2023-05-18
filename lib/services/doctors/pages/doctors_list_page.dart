import 'package:flutter/material.dart';

import '../../../utilities/theme/text_styles.dart';
import '../widgets/doctor_card.dart';

class DoctorsListPage extends StatelessWidget {
  const DoctorsListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              children: [
                Text(
                  "قائمة الاطباء",
                  style: AppTextStyles.w500.copyWith(fontSize: 18),
                ),
                const Spacer(),
                const Icon(Icons.menu),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Divider(
            height: 0,
            color: Theme.of(context).dividerColor,
          ),
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  const SizedBox(height: 36),
                  ...List.generate(
                    12,
                    (index) => const DoctorCard(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
