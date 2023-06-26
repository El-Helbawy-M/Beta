import 'package:flutter/material.dart';
import 'package:flutter_project_base/services/medicins_list/models/medicine_model.dart';
import 'package:flutter_project_base/utilities/components/custom_btn.dart';
import 'package:flutter_project_base/utilities/components/custom_page_body.dart';
import 'package:intl/intl.dart';

import '../../../routers/navigator.dart';
import '../../../utilities/components/arrow_back.dart';
import '../../../utilities/theme/text_styles.dart';
import '../widgets/indicator_header.dart';
import 'duration_step_view.dart';
import 'medicins_step_view.dart';

class AddMedicinePage extends StatefulWidget {
  const AddMedicinePage({super.key});

  @override
  State<AddMedicinePage> createState() => _AddMedicinePageState();
}

class _AddMedicinePageState extends State<AddMedicinePage> {
  bool loading = false;

  final String medicineType = '';
  String insulinType = '';
  TextEditingController name = TextEditingController(),
      numberOfDays = TextEditingController(),
      timesInDay = TextEditingController();

  bool isInsulin = true;
  Set<String> days = {};

  DateTime dateTime = DateTime.now();

  int pageIndex = 0;

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
          "اضافة دواء جديد",
          style: AppTextStyles.w500.copyWith(fontSize: 18),
        ),
      ),
      body: Column(
        children: [
          IndicatorHeader(
            title: pageIndex != 1 ? "تفاصيل الدواء" : "مدة الدواء",
            totalSteps: 2,
            progress: pageIndex + 1,
          ),
          Expanded(
            child: SingleChildScrollView(
              child: pageIndex == 1
                  ? DurationStepView(
                      numberOfDays: numberOfDays,
                      onChooseDate: (date) {
                        dateTime = date;
                      },
                      timesInDay: timesInDay,
                      onChooseDay: (day) {
                        if (days.contains(day)) {
                          days.remove(day);
                        } else {
                          days.add(day);
                        }
                      },
                    )
                  : MedicinsStepView(
                      name: name,
                      onChangeMedicineType: (String value) {
                        insulinType = value;
                      },
                    ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            child: Row(
              children: [
                if (pageIndex != 0)
                  Expanded(
                    child: CustomBtn(
                      text: "السابق",
                      buttonColor: Colors.transparent,
                      borderColor: Theme.of(context).colorScheme.primary,
                      textColor: Theme.of(context).colorScheme.primary,
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                const SizedBox(width: 16),
                Expanded(
                  child: CustomBtn(
                    text: pageIndex == 0 ? "التالي" : "ارسال",
                    onTap: () {
                      if (pageIndex == 1) {
                        final medicineModel = MedicineModel(
                            name: name.text,
                            dose: timesInDay.text,
                            date: dateTime,
                            time: DateFormat('hh:mm:ss').format(dateTime),
                            insulinType: insulinType);
                        CustomNavigator.pop(result: medicineModel);
                      }
                      pageIndex++;
                      setState(() {});
                    },
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16)
        ],
      ),
    );
  }
}
