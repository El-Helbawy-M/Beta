import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../utilities/theme/text_styles.dart';

class DaysSelectorView extends StatelessWidget {
  const DaysSelectorView({
    super.key,
    required this.startDate,
    required this.onDaySelect,
    this.selectedDays = const [],
  });
  final DateTime startDate;
  final Function(String) onDaySelect;
  final List<String> selectedDays;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 24),
        Text(
          "ايام الدواء",
          style: AppTextStyles.w500.copyWith(fontSize: 16),
        ),
        const SizedBox(height: 16),
        GridView(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            childAspectRatio: 3,
          ),
          children: List.generate(
            7,
            (index) {
              var day = startDate.add(Duration(days: index));
              String dayName = DateFormat.E("ar").format(day);
              return InkWell(
                onTap: () => onDaySelect(dayName),
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Theme.of(context)
                        .primaryColor
                        .withOpacity(selectedDays.contains(dayName) ? 1 : .2),
                  ),
                  child: Center(
                    child: Text(
                      dayName,
                      style: AppTextStyles.w400.copyWith(
                        color: selectedDays.contains(dayName)
                            ? Colors.white
                            : Theme.of(context).hintColor.withOpacity(.6),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
