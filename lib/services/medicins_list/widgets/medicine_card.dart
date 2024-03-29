import 'package:flutter/material.dart';
import 'package:flutter_project_base/base/widgets/pressure_info_view.dart';
import 'package:flutter_project_base/handlers/icon_handler.dart';
import 'package:flutter_project_base/services/medicins_list/models/medicine_model.dart';
import 'package:flutter_project_base/utilities/theme/text_styles.dart';

class MedicineCard extends StatelessWidget {
  const MedicineCard(this.item, {super.key});
  final MedicineModel item;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topLeft,
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
                color: Theme.of(context).dividerColor.withOpacity(.05)),
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
              Text(
                item.name ?? '',
                style: AppTextStyles.w600.copyWith(fontSize: 20),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  drawSvgIcon("clock",
                      iconColor: Theme.of(context).colorScheme.primary),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      item.time ?? '',
                      style: AppTextStyles.w400.copyWith(fontSize: 16),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              InfoView(
                title: "الجرعة",
                value: Text(
                  "${item.dose} ${item.insulinType == '1' ? 'ملعقة' : 'حقنه'}",
                  style: AppTextStyles.w600.copyWith(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
        Container(
          height: 32,
          width: 46,
          decoration: const BoxDecoration(
            color: Colors.green,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(8),
              bottomRight: Radius.circular(8),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              drawSvgIcon("tick",
                  iconColor: Colors.white, width: 16, height: 16),
            ],
          ),
        ),
      ],
    );
  }
}
