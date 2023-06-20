import 'package:flutter/material.dart';
import 'package:flutter_project_base/handlers/icon_handler.dart';
import 'package:flutter_project_base/utilities/extensions/date_formatter.dart';

import '../../../base/widgets/fields/date_input_field.dart';
import '../../../routers/navigator.dart';
import '../../../routers/routers.dart';
import '../../../utilities/components/arrow_back.dart';
import '../../../utilities/components/custom_page_body.dart';
import '../../../utilities/theme/text_styles.dart';
import '../widgets/medicine_card.dart';

class MedicinesListPage extends StatelessWidget {
  const MedicinesListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomPageBody(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: .2,
        leading: InkWell(
          onTap: () => CustomNavigator.pop(),
          highlightColor: Colors.transparent,
          splashColor: Colors.transparent,
          child: Row(
            children: const [
              SizedBox(width: 16),
              ArrowBack(),
            ],
          ),
        ),
        titleSpacing: 4,
        title: Text(
          "الأدوية",
          style: AppTextStyles.w500.copyWith(fontSize: 18),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            InkWell(
              onTap: () => showBottomSheetDatePicker(
                onChange: (value) {},
              ),
              child: AnimatedContainer(
                height: 56,
                duration: const Duration(milliseconds: 300),
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  children: [
                    drawSvgIcon("calendar",
                        iconColor: Theme.of(context).colorScheme.primary),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        DateTime.now().toYearMonthDayFormatte(),
                        style: AppTextStyles.w500.copyWith(fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Divider(height: 0),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: [
                      const SizedBox(height: 16),
                      ...List.generate(
                          4,
                          (index) => MedicineCard([
                                'الدواء الاول',
                                'الدواء الثاني',
                                'الدواء الثالث',
                                'الدواء الرابع',
                              ][index])),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async{
          final result = await  Navigator.of(context).pushNamed(Routes.addMedicines);

          if(result == null) return;

          // getItems();
        },
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
