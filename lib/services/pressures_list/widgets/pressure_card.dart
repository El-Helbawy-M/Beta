import 'package:flutter/material.dart';
import 'package:flutter_project_base/base/widgets/pressure_info_view.dart';
import 'package:flutter_project_base/utilities/theme/text_styles.dart';
import 'package:intl/intl.dart';

import '../models/blood_pressure_item_model.dart';
import 'card_value_view.dart';

class PressureCard extends StatelessWidget {
  const PressureCard(this.item, {super.key});
  final BloodPressureItemModel item;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border:
            Border.all(color: Theme.of(context).dividerColor.withOpacity(.05)),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).dividerColor.withOpacity(.02),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: CardValueView(
                  title: "الضغط الإنقباضي",
                  value: item.systolicPressure,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: CardValueView(
                  title: "الضغط الإنبساطي",
                  value: item.diastolicPressure,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          InfoView(
            title: "الزراع المُستخدم",
            value: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Theme.of(context).colorScheme.primary,
              ),
              child: Text(
                item.arm == '1' ? 'الشمال' : 'اليمين',
                style: AppTextStyles.w300.copyWith(color: Colors.white),
              ),
            ),
          ),
          const SizedBox(height: 16),
          InfoView(
            title: "النبض",
            value: Text(
              item.pulse,
              style: AppTextStyles.w600.copyWith(fontSize: 16),
            ),
          ),
          const SizedBox(height: 16),
          InfoView(
            title: "الوقت & التاريخ",
            value: Text(
              //2-2-2021  12:00,
              DateFormat('dd-MM-yyyy hh:mm').format(item.date),
              style: AppTextStyles.w600.copyWith(fontSize: 16),
            ),
          ),
          const SizedBox(height: 16),
          InfoView(
            title: "ملحوظة",
            value: Text(
              item.note,
              style: AppTextStyles.w600.copyWith(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
