import 'package:flutter/material.dart';

import '../../../utilities/theme/text_styles.dart';

class TicketCard extends StatelessWidget {
  const TicketCard({
    super.key,
    this.isTaken = false,
  });
  final bool isTaken;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        InkWell(
          onTap: () {},
          child: Container(
            width: 80,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border:
                  Border.all(width: .5, color: Theme.of(context).dividerColor),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 24,
                  decoration: BoxDecoration(
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(10)),
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  child: Center(
                    child: Text(
                      "الاربعاء 3/1",
                      style: AppTextStyles.w500
                          .copyWith(fontSize: 14, color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "10:00",
                  style: AppTextStyles.w500.copyWith(fontSize: 18),
                ),
                Text(
                  "الي",
                  style: AppTextStyles.w500.copyWith(fontSize: 14),
                ),
                const SizedBox(height: 8),
                Text(
                  "10:00",
                  style: AppTextStyles.w500.copyWith(fontSize: 18),
                ),
                const SizedBox(height: 10),
                Container(
                  height: 24,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.vertical(
                        bottom: Radius.circular(10)),
                    color: isTaken ? Colors.red : Colors.green,
                  ),
                  child: Center(
                    child: Text(
                      isTaken ? "محجوز" : "احجز",
                      style: AppTextStyles.w500
                          .copyWith(fontSize: 14, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 16),
      ],
    );
  }
}
