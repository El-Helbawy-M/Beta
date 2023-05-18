import 'package:flutter/material.dart';
import 'package:flutter_project_base/base/models/select_option.dart';
import 'package:flutter_project_base/base/widgets/fields/date_input_field.dart';
import 'package:flutter_project_base/base/widgets/fields/single_select_bottomsheet/single_select_input_field.dart';
import 'package:flutter_project_base/utilities/components/custom_page_body.dart';

import '../../../../base/widgets/fields/text_description_input_field.dart';
import '../../../../base/widgets/fields/text_input_field.dart';
import '../../../../base/widgets/fields/time_input_field.dart';
import '../../../../utilities/components/custom_btn.dart';

class AddDiabetesDetails extends StatefulWidget {
  const AddDiabetesDetails({super.key});

  @override
  State<AddDiabetesDetails> createState() => _AddDiabetesDetailsState();
}

class _AddDiabetesDetailsState extends State<AddDiabetesDetails> {
  bool isSelected = false;
  @override
  Widget build(BuildContext context) {
    return CustomPageBody(
      appBar: AppBar(
        leading: const Icon(Icons.arrow_back),
        backgroundColor: const Color(0xff1B72C0),
        title: const Text('سكر الدم'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextInputField(
                  labelText: 'تركيز السكر',
                ),
                SingleSelectSheetField(
                    labelText: 'وقت القياس',
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
                ),
                const TimeInputField(
                  labelText: 'وقت القياس',
                ),
                const TextDescriptionInputField(
                  labelText: 'ملاحظات',
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
