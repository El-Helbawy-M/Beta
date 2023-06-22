import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project_base/base/models/select_option.dart';
import 'package:flutter_project_base/base/widgets/fields/date_input_field.dart';
import 'package:flutter_project_base/base/widgets/fields/single_select_bottomsheet/single_select_input_field.dart';
import 'package:flutter_project_base/utilities/components/custom_page_body.dart';
import 'package:intl/intl.dart';

import '../../../base/utils.dart';
import '../../../base/widgets/fields/text_description_input_field.dart';
import '../../../base/widgets/fields/text_input_field.dart';
import '../../../base/widgets/fields/time_input_field.dart';
import '../../../config/api_names.dart';
import '../../../network/network_handler.dart';
import '../../../routers/navigator.dart';
import '../../../utilities/components/arrow_back.dart';
import '../../../utilities/components/custom_btn.dart';
import '../../../utilities/theme/text_styles.dart';

class AddPressurePage extends StatefulWidget {
  const AddPressurePage({super.key});

  @override
  State<AddPressurePage> createState() => _AddPressurePageState();
}

class _AddPressurePageState extends State<AddPressurePage> {
  TextEditingController systolicPressure = TextEditingController(),
      diastolicPressure = TextEditingController(),
      pulse = TextEditingController(),
      note = TextEditingController();

  DateTime dateTime = DateTime.now();

  String? arm;

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
                  labelText: 'الضغط الانقباضي',
                  hintText: "ادخل القرائة",
                  keyboardType: TextInputType.number,
                  controller: systolicPressure,
                  suffixIcon: Padding(
                    padding: const EdgeInsets.only(top: 16, left: 16),
                    child: Text(
                      "ملليمول/ليتر",
                      style: AppTextStyles.w400.copyWith(
                          color: Theme.of(context).hintColor.withOpacity(.6)),
                    ),
                  ),
                ),
                TextInputField(
                  labelText: 'الضغط الانبساطي',
                  hintText: "ادخل القرائة",
                  keyboardType: TextInputType.number,
                  controller: diastolicPressure,
                  suffixIcon: Padding(
                    padding: const EdgeInsets.only(top: 16, left: 16),
                    child: Text(
                      "ملليمول/ليتر",
                      style: AppTextStyles.w400.copyWith(
                          color: Theme.of(context).hintColor.withOpacity(.6)),
                    ),
                  ),
                ),
                SingleSelectSheetField(
                  labelText: 'الذراع المستخدم',
                  hintText: 'اختر الذراع',
                  //  initialValue: SelectOption('Time', 'قبل الغداء'),
                  onChange: (value) => arm = value.id.toString(),
                  valueSet: [
                    SelectOption(
                      'right-arm',
                      'الذراع الايمن',
                      id: 0,
                    ),
                    SelectOption(
                      'left-arm',
                      'الذراع الايسر',
                      id: 1,
                    ),
                  ],
                ),
                TextInputField(
                  labelText: 'النبض',
                  hintText: "ادخل القرائة",
                  keyboardType: TextInputType.number,
                  controller: pulse,
                ),
                DateInputField(
                  labelText: 'تاريخ القياس',
                  hintText: "اختر التاريخ",
                  onChange: (dateTime) {
                    this.dateTime = this.dateTime.copyWith(
                          year: dateTime.year,
                          month: dateTime.month,
                          day: dateTime.day,
                        );
                  },
                ),
                TimeInputField(
                  labelText: 'وقت القياس',
                  hintText: "اختر الوقت",
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
                    systolicPressure.clear();
                    diastolicPressure.clear();
                    pulse.clear();
                    note.clear();
                    dateTime = DateTime.now();
                    arm = null;
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                CustomBtn(
                  buttonColor: const Color(0xff1B72C0),
                  text: 'حفظ',
                  loading: loading,
                  onTap: () {
                    if (systolicPressure.text.isEmpty ||
                        diastolicPressure.text.isEmpty ||
                        pulse.text.isEmpty ||
                        note.text.isEmpty ||
                        arm == null) {
                      showSnackBar(
                        context,
                        'جميع الحقول مطلوبة',
                        type: SnackBarType.warning,
                      );
                      return;
                    }
                    addBloodPressure();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void addBloodPressure() async {
    try {
      loading = true;
      setState(() {});
      String timeFormatPattern = 'yyyy-MM-dd hh:mm:ss';
      final FormData formData = FormData.fromMap({
        'systolic_pressure': systolicPressure.text,
        'diastolic_pressure': diastolicPressure.text,
        'arm': arm,
        'pulse': pulse.text,
        'date': DateFormat(timeFormatPattern).format(dateTime),
        'note': note.text,
      });
      final Response? response = await NetworkHandler.instance?.post(
        url: ApiNames.addBloodPressure,
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
      String? msg = e.response?.data.toString();

      if (e.response?.data is Map &&
          (e.response?.data as Map).containsKey('errors')) {
        msg = e.response?.data['errors'].toString();
      }

      showSnackBar(
        context,
        msg,
        type: SnackBarType.warning,
      );
    }
    loading = false;
    setState(() {});
  }
}
