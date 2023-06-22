import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project_base/base/models/select_option.dart';
import 'package:flutter_project_base/base/utils.dart';
import 'package:flutter_project_base/base/widgets/fields/date_input_field.dart';
import 'package:flutter_project_base/base/widgets/fields/single_select_bottomsheet/single_select_input_field.dart';
import 'package:flutter_project_base/utilities/components/custom_page_body.dart';
import 'package:intl/intl.dart';

import '../../../base/widgets/fields/text_description_input_field.dart';
import '../../../base/widgets/fields/text_input_field.dart';
import '../../../base/widgets/fields/time_input_field.dart';
import '../../../config/api_names.dart';
import '../../../network/network_handler.dart';
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
  TextEditingController sugarConcentration = TextEditingController(),
      note = TextEditingController();

  DateTime dateTime = DateTime.now();

  String? measureDescription;

  bool loading = false;

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
                  controller: sugarConcentration,
                  keyboardType: TextInputType.number,
                  suffixIcon: Padding(
                    padding: const EdgeInsets.only(top: 16, left: 16),
                    child: Text(
                      "ملى متر/لتر",
                      style: AppTextStyles.w400.copyWith(
                          color: Theme.of(context).hintColor.withOpacity(.6)),
                    ),
                  ),
                ),
                SingleSelectSheetField(
                  labelText: 'وقت القياس',
                  hintText: 'اختر الوقت',
                  onChange: (option) {
                    measureDescription = option.label;
                  },
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
                  ],
                ),
                DateInputField(
                  labelText: 'تاريخ القياس',
                  hintText: "اختر التاريخ",
                  initialValue: dateTime,
                  onChange: (dateTime) {
                    this.dateTime = this.dateTime.copyWith(
                        year: dateTime.year,
                        month: dateTime.month,
                        day: dateTime.day);
                  },
                ),
                TimeInputField(
                  labelText: 'وقت القياس',
                  hintText: "اختر الوقت",
                  initialValue: dateTime,
                  onChange: (dateTime) {
                    this.dateTime = this.dateTime.copyWith(
                          hour: dateTime.hour,
                          minute: dateTime.minute,
                          second: dateTime.second,
                        );
                  },
                ),
                TextDescriptionInputField(
                  labelText: 'ملاحظات',
                  hintText: "اكتب ملاحظاتك",
                  controller: note,
                ),
                CustomBtn(
                  buttonColor: Colors.grey,
                  text: 'اعادة الضبط',
                  onTap: () {
                    sugarConcentration.clear();
                    note.clear();
                    measureDescription = null;
                  },
                ),
                const SizedBox(height: 10),
                CustomBtn(
                  buttonColor: const Color(0xff1B72C0),
                  text: 'حفظ',
                  loading: loading,
                  onTap: () {
                    if (sugarConcentration.text.isEmpty ||
                        note.text.isEmpty ||
                        measureDescription == null) {
                      showSnackBar(
                        context,
                        'جميع الحقول مطلوبة',
                        type: SnackBarType.warning,
                      );
                      return;
                    }

                    addBloodSugar();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void addBloodSugar() async {
    try {
      loading = true;
      setState(() {});
      String timeFormatPattern = 'yyyy-MM-dd hh:mm:ss';
      final FormData formData = FormData.fromMap({
        'sugar_concentration': sugarConcentration.text,
        'measure_description': measureDescription,
        'date': DateFormat(timeFormatPattern).format(dateTime),
        'note': note.text,
      });
      final Response? response = await NetworkHandler.instance?.post(
        url: ApiNames.addBloodSugar,
        body: formData,
        withToken: true,
      );

      if (response == null) return;
      if (!mounted) return;

      showSnackBar(
        context,
        'تم الإضافة بنجاح',
        type: SnackBarType.success,
      );
      Navigator.pop(context, true);
    } on DioError catch (e) {
      showSnackBar(
        context,
        'حدث خطأ، يرجي إعادة المحاولة, و كود الخطأ هو ${e.response!.statusCode}',
        type: SnackBarType.warning,
      );
    }
    loading = false;
    setState(() {});
  }

  @override
  void dispose() {
    sugarConcentration.dispose();
    note.dispose();
    super.dispose();
  }
}
