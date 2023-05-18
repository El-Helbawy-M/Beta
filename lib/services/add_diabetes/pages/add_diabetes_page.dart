import 'package:flutter/material.dart';
import 'package:flutter_project_base/base/models/select_option.dart';
import 'package:flutter_project_base/base/widgets/fields/date_input_field.dart';
import 'package:flutter_project_base/base/widgets/fields/single_select_bottomsheet/single_select_input_field.dart';
import 'package:flutter_project_base/utilities/components/custom_page_body.dart';

import '../../../base/widgets/fields/text_description_input_field.dart';
import '../../../base/widgets/fields/text_input_field.dart';
import '../../../base/widgets/fields/time_input_field.dart';
import '../../../routers/navigator.dart';
import '../../../utilities/components/arrow_back.dart';
import '../../../utilities/components/custom_btn.dart';
import '../../../utilities/theme/text_styles.dart';

class AddDiabetesPage extends StatefulWidget {
  const AddDiabetesPage({super.key});

  @override
  State<AddDiabetesPage> createState() => _AddDiabetesPageState();
}

class _AddDiabetesPageState extends State<AddDiabetesPage> {
  bool isSelected = false;
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
          "اضافة قياس جديد",
          style: AppTextStyles.w500.copyWith(fontSize: 18),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextInputField(
                  labelText: 'تركيز السكر',
                  hintText: "ادخل القيمة",
                  keyboardType: TextInputType.number,
                  suffixIcon: Padding(
                    padding: const EdgeInsets.only(top: 16, left: 16),
                    child: Text(
                      "ملليمول/ليتر",
                      style: AppTextStyles.w400.copyWith(color: Theme.of(context).hintColor.withOpacity(.6)),
                    ),
                  ),
                ),
                SingleSelectSheetField(
                    labelText: 'وقت القياس',
                    hintText: 'اختر الوقت',
                    //  initialValue: SelectOption('Time', 'قبل الغداء'),
                    valueSet: [
                      SelectOption(
                        'Time1',
                        'قبل الفطور',
                      ),
                      SelectOption(
                        'Time2',
                        'بعد الفطور',
                      ),
                      SelectOption(
                        'Time3',
                        'قبل الغداء',
                      ),
                      SelectOption(
                        'Time4',
                        'بعد الغداء',
                      ),
                    ]),
                const DateInputField(
                  labelText: 'تاريخ القياس',
                  hintText: "اختر التاريخ",
                ),
                const TimeInputField(
                  labelText: 'وقت القياس',
                  hintText: "اختر الوقت",
                ),
                const TextDescriptionInputField(
                  labelText: 'ملاحظات',
                  hintText: "اكتب ملاحظاتك",
                ),
                CustomBtn(
                  buttonColor: Colors.grey,
                  text: 'اعادة الضبط',
                  onTap: () {},
                ),
                const SizedBox(
                  height: 10,
                ),
                CustomBtn(
                  buttonColor: const Color(0xff1B72C0),
                  text: 'حفظ',
                  onTap: () {},
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
