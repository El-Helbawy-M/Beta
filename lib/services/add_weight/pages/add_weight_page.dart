import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project_base/base/utils.dart';
import 'package:flutter_project_base/base/widgets/fields/date_input_field.dart';
import 'package:flutter_project_base/utilities/components/custom_page_body.dart';
import 'package:intl/intl.dart';

import '../../../base/widgets/fields/text_input_field.dart';
import '../../../base/widgets/fields/time_input_field.dart';
import '../../../config/api_names.dart';
import '../../../network/network_handler.dart';
import '../../../routers/navigator.dart';
import '../../../utilities/components/arrow_back.dart';
import '../../../utilities/components/custom_btn.dart';
import '../../../utilities/theme/text_styles.dart';

class AddWeightPage extends StatefulWidget {
  const AddWeightPage({super.key});

  @override
  State<AddWeightPage> createState() => _AddWeightPageState();
}

class _AddWeightPageState extends State<AddWeightPage> {
  TextEditingController weight = TextEditingController();
  DateTime dateTime = DateTime.now();

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
          "اضافة وزن جديد",
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
                  labelText: 'الوزن',
                  hintText: "ادخل القيمة",
                  controller: weight,
                  keyboardType: TextInputType.number,
                  suffixIcon: Padding(
                    padding: const EdgeInsets.only(top: 16, left: 16),
                    child: Text(
                      "كيلو",
                      style: AppTextStyles.w400.copyWith(
                          color: Theme.of(context).hintColor.withOpacity(.6)),
                    ),
                  ),
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
                CustomBtn(
                  buttonColor: Colors.grey,
                  text: 'اعادة الضبط',
                  onTap: () {
                    weight.clear();
                  },
                ),
                const SizedBox(height: 10),
                CustomBtn(
                  buttonColor: const Color(0xff1B72C0),
                  text: 'حفظ',
                  loading: loading,
                  onTap: () {
                    if (weight.text.isEmpty) {
                      showSnackBar(
                        context,
                        'جميع الحقول مطلوبة',
                        type: SnackBarType.warning,
                      );
                      return;
                    }

                    addWeight();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void addWeight() async {
    try {
      loading = true;
      setState(() {});
      String timeFormatPattern = 'yyyy-MM-dd hh:mm:ss';

      final FormData formData = FormData.fromMap({
        'weight': weight.text,
        'unit': 'كيلو',
        'date': DateFormat(timeFormatPattern).format(dateTime),
      });
      final Response? response = await NetworkHandler.instance?.post(
        url: ApiNames.addWeight,
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
    weight.dispose();
    super.dispose();
  }
}
