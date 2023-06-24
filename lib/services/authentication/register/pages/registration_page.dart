import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_project_base/base/widgets/fields/text_input_field.dart';
import 'package:flutter_project_base/routers/routers.dart';
import 'package:flutter_project_base/services/authentication/register/blocs/cubit/handler.dart';
import 'package:flutter_project_base/services/profile/pages/profile_page.dart';
import 'package:flutter_project_base/utilities/components/custom_btn.dart';
import 'package:flutter_project_base/utilities/components/custom_page_body.dart';
import 'package:flutter_project_base/utilities/theme/text_styles.dart';
import 'package:intl/intl.dart';

import '../../../../base/utils.dart';
import '../../../../config/api_names.dart';
import '../../../../handlers/shared_handler.dart';
import '../../../../network/network_handler.dart';

class RegistrationPage extends StatelessWidget {
  const RegistrationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RegisterHandler(),
      child: CustomPageBody(
        appBar: AppBar(
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
        ),
        body: BlocBuilder<RegisterHandler, RegisterState>(
          builder: (context, state) {
            return WillPopScope(
              onWillPop: () async {
                if (state is RegisterCurrentState) {
                  context.read<RegisterHandler>().back();
                  return false;
                }
                return true;
              },
              child: BlocBuilder<RegisterHandler, RegisterState>(
                builder: (context, state) {
                  if (state is RegisterCurrentState &&
                      state.currentState == CurrentState.mainScreen) {
                    return const MainRegisterPage();
                  } else if (state is RegisterCurrentState &&
                      state.currentState == CurrentState.infoType) {
                    return RegisterInfoTypePage(
                      registerCurrentState: state,
                    );
                  } else if (state is RegisterCurrentState &&
                      state.currentState == CurrentState.infoDuration) {
                    return RegisterDurationPage(
                      registerCurrentState: state,
                    );
                  } else if (state is RegisterCurrentState &&
                      state.currentState == CurrentState.infoCounts) {
                    return RegisterCountsPage(
                      registerCurrentState: state,
                    );
                  } else {
                    return const SizedBox();
                  }
                },
              ),
            );
          },
        ),
      ),
    );
  }
}

class MainRegisterPage extends StatefulWidget {
  const MainRegisterPage({super.key});

  @override
  State<MainRegisterPage> createState() => _MainRegisterPageState();
}

class _MainRegisterPageState extends State<MainRegisterPage> {
  TextEditingController name = TextEditingController(),
      phone = TextEditingController(),
      password = TextEditingController(),
      passwordConfirmation = TextEditingController(),
      day = TextEditingController(),
      month = TextEditingController(),
      year = TextEditingController();

  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 120),
              child: Image.asset("assets/images/splash.png"),
            ),
            const SizedBox(
              height: 99,
            ),
            TextInputField(
              hintText: "الإسم",
              controller: name,
            ),
            TextInputField(
              hintText: "رقم الهاتف",
              controller: phone,
            ),
            Row(
              children: [
                Flexible(
                  child: TextInputField(
                    hintText: "اليوم",
                    controller: day,
                  ),
                ),
                const SizedBox(
                  width: 8.0,
                ),
                Flexible(
                  child: TextInputField(
                    hintText: "الشهر",
                    controller: month,
                  ),
                ),
                const SizedBox(
                  width: 8.0,
                ),
                Flexible(
                  child: TextInputField(
                    hintText: "السنه",
                    controller: year,
                  ),
                ),
              ],
            ),
            TextInputField(
              hintText: "كلمة المرور",
              controller: password,
            ),
            TextInputField(
              hintText: "تأكيد كلمة المرور",
              controller: passwordConfirmation,
            ),
            CustomBtn(
              buttonColor: Theme.of(context).colorScheme.primary,
              text: "التالي",
              loading: loading,
              height: 40,
              onTap: () {
                if (name.text.isEmpty ||
                    password.text.isEmpty ||
                    passwordConfirmation.text.isEmpty ||
                    day.text.isEmpty ||
                    month.text.isEmpty ||
                    year.text.isEmpty ||
                    phone.text.isEmpty) {
                  return;
                }

                registerData();
              },
            ),
          ],
        ),
      ),
    );
  }

  void registerData() async {
    try {
      loading = true;
      setState(() {});
      String timeFormatPattern = 'yyyy-MM-dd';
      final dateTime = DateTime(
        year.text.toInt(),
        month.text.toInt(),
        day.text.toInt(),
      );
      final FormData formData = FormData.fromMap({
        'name': name.text,
        'phone': phone.text,
        'birthday': DateFormat(timeFormatPattern).format(dateTime),
        'password': password.text,
        'confirmed_password': passwordConfirmation.text,
      });
      final Response? response = await NetworkHandler.instance?.post(
        url: ApiNames.register,
        body: formData,
        withToken: false,
      );

      if (response == null) return;
      if (!mounted) return;
      context.read<RegisterHandler>().mainNext();
      SharedHandler.instance?.setData(
        SharedKeys().user,
        value: response.data['data'],
      );
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
}

class RegisterInfoTypePage extends StatefulWidget {
  final RegisterCurrentState registerCurrentState;
  const RegisterInfoTypePage({super.key, required this.registerCurrentState});

  @override
  State<RegisterInfoTypePage> createState() => _RegisterInfoTypePageState();
}

class _RegisterInfoTypePageState extends State<RegisterInfoTypePage> {
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "ما نوع مرض السكري الذي \nتعاني منه ؟",
            style: AppTextStyles.w700.copyWith(fontSize: 20),
          ),
          const SizedBox(height: 32),
          SelectionWidget(
            value: "النوع الاول",
            isSelected: widget.registerCurrentState.typeValue == "النوع الاول",
            onTap: () {
              context
                  .read<RegisterHandler>()
                  .updateTypeValue(typeValue: "النوع الاول");
            },
          ),
          const SizedBox(height: 16),
          SelectionWidget(
            value: "النوع التاني",
            isSelected: widget.registerCurrentState.typeValue == "النوع التاني",
            onTap: () {
              context
                  .read<RegisterHandler>()
                  .updateTypeValue(typeValue: "النوع التاني");
            },
          ),
          const SizedBox(height: 16),
          SelectionWidget(
            value: "ما قبل السُكري",
            isSelected:
                widget.registerCurrentState.typeValue == "ما قبل السُكري",
            onTap: () {
              context
                  .read<RegisterHandler>()
                  .updateTypeValue(typeValue: "ما قبل السُكري");
            },
          ),
          const SizedBox(height: 16),
          SelectionWidget(
            value: "أُخري",
            isSelected: widget.registerCurrentState.typeValue == "أُخري",
            onTap: () {
              context
                  .read<RegisterHandler>()
                  .updateTypeValue(typeValue: "أُخري");
            },
          ),
          const SizedBox(height: 16),
          if (widget.registerCurrentState.typeValue != null)
            Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                CustomBtn(
                  buttonColor: Theme.of(context).colorScheme.primary,
                  text: "التالي",
                  loading: loading,
                  height: 40,
                  onTap: () {
                    addSugarType(widget.registerCurrentState.typeValue!);
                  },
                ),
              ],
            ),
        ],
      ),
    );
  }

  void addSugarType(String sugarType) async {
    try {
      loading = true;
      setState(() {});

      final FormData formData = FormData.fromMap({
        'sugar_type': sugarType,
      });
      final Response? response = await NetworkHandler.instance?.post(
        url: ApiNames.addSugarType,
        body: formData,
        withToken: true,
      );

      if (response == null) return;
      if (!mounted) return;
      context.read<RegisterHandler>().typeNext();
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
}

class RegisterDurationPage extends StatefulWidget {
  final RegisterCurrentState registerCurrentState;
  const RegisterDurationPage({super.key, required this.registerCurrentState});

  @override
  State<RegisterDurationPage> createState() => _RegisterDurationPageState();
}

class _RegisterDurationPageState extends State<RegisterDurationPage> {
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "ما مدة إصابتك بالسُكري ؟",
            style: AppTextStyles.w700.copyWith(fontSize: 20),
          ),
          const SizedBox(height: 48),
          SelectionWidget(
            value: "أقل من 6 أشهر",
            isSelected:
                widget.registerCurrentState.durationValue == "أقل من 6 أشهر",
            onTap: () {
              context
                  .read<RegisterHandler>()
                  .updateDurationValue(durationValue: "أقل من 6 أشهر");
            },
          ),
          const SizedBox(height: 16),
          SelectionWidget(
            value: "أقل من سنه",
            isSelected:
                widget.registerCurrentState.durationValue == "أقل من سنه",
            onTap: () {
              context
                  .read<RegisterHandler>()
                  .updateDurationValue(durationValue: "أقل من سنه");
            },
          ),
          const SizedBox(height: 16),
          SelectionWidget(
            value: "من 1 سنه الي 5 سنين",
            isSelected: widget.registerCurrentState.durationValue ==
                "من 1 سنه الي 5 سنين",
            onTap: () {
              context
                  .read<RegisterHandler>()
                  .updateDurationValue(durationValue: "من 1 سنه الي 5 سنين");
            },
          ),
          const SizedBox(height: 16),
          SelectionWidget(
            value: "أكثر من 5 سنين",
            isSelected:
                widget.registerCurrentState.durationValue == "أكثر من 5 سنين",
            onTap: () {
              context
                  .read<RegisterHandler>()
                  .updateDurationValue(durationValue: "أكثر من 5 سنين");
            },
          ),
          const SizedBox(height: 20),
          if (widget.registerCurrentState.durationValue != null)
            Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                CustomBtn(
                  buttonColor: Theme.of(context).colorScheme.primary,
                  text: "التالي",
                  height: 40,
                  loading: loading,
                  onTap: () {
                    addInjuryDuration(
                        widget.registerCurrentState.durationValue!);
                  },
                ),
              ],
            ),
        ],
      ),
    );
  }

  void addInjuryDuration(String injuryDuration) async {
    try {
      loading = true;
      setState(() {});

      final FormData formData = FormData.fromMap({
        'injury_duration': injuryDuration,
      });
      final Response? response = await NetworkHandler.instance?.post(
        url: ApiNames.addInjuryDuration,
        body: formData,
        withToken: true,
      );

      if (response == null) return;
      if (!mounted) return;
      context.read<RegisterHandler>().durationNext();
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
}

class RegisterCountsPage extends StatefulWidget {
  final RegisterCurrentState registerCurrentState;
  const RegisterCountsPage({super.key, required this.registerCurrentState});

  @override
  State<RegisterCountsPage> createState() => _RegisterCountsPageState();
}

class _RegisterCountsPageState extends State<RegisterCountsPage> {
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "معدل قياسك للسكر",
            style: AppTextStyles.w700.copyWith(fontSize: 20),
          ),
          const SizedBox(height: 48),
          SelectionWidget(
            value: "مرة في اليوم",
            isSelected:
                widget.registerCurrentState.countValue == "مرة في اليوم",
            onTap: () {
              context
                  .read<RegisterHandler>()
                  .updateCountValue(countValue: "مرة في اليوم");
            },
          ),
          const SizedBox(height: 16),
          SelectionWidget(
            value: "مرتين في اليوم",
            isSelected:
                widget.registerCurrentState.countValue == "مرتين في اليوم",
            onTap: () {
              context
                  .read<RegisterHandler>()
                  .updateCountValue(countValue: "مرتين في اليوم");
            },
          ),
          const SizedBox(height: 16),
          SelectionWidget(
            value: "اكثر من مرتين في اليوم",
            isSelected: widget.registerCurrentState.countValue ==
                "اكثر من مرتين في اليوم",
            onTap: () {
              context
                  .read<RegisterHandler>()
                  .updateCountValue(countValue: "اكثر من مرتين في اليوم");
            },
          ),
          const SizedBox(height: 16),
          SizedBox(height: MediaQuery.of(context).size.height * 0.15),
          if (widget.registerCurrentState.countValue != null)
            Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                CustomBtn(
                  buttonColor: Theme.of(context).colorScheme.primary,
                  text: "التالي",
                  height: 40,
                  loading: loading,
                  onTap: () {
                    addSugarMeasurement(
                      widget.registerCurrentState.countValue!,
                    );
                  },
                ),
              ],
            ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  void addSugarMeasurement(String sugarMeasurement) async {
    try {
      loading = true;
      setState(() {});

      final FormData formData = FormData.fromMap({
        'sugar_measurement': sugarMeasurement,
      });
      final Response? response = await NetworkHandler.instance?.post(
        url: ApiNames.addSugarMeasurement,
        body: formData,
        withToken: true,
      );

      if (response == null) return;
      if (!mounted) return;
      context.read<RegisterHandler>().countNext();
      Navigator.of(context).pushNamed(Routes.home);
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
}

class SelectionWidget extends StatelessWidget {
  final String value;
  final bool isSelected;
  final VoidCallback onTap;
  const SelectionWidget({
    super.key,
    required this.value,
    this.isSelected = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        height: 56,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color:
              isSelected ? Theme.of(context).colorScheme.primary : Colors.white,
          border: Border.all(color: Theme.of(context).colorScheme.primary),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              value,
              style: TextStyle(
                color: isSelected
                    ? Colors.white
                    : Theme.of(context).colorScheme.primary,
              ),
            ),
            if (isSelected)
              Container(
                height: 22,
                width: 22,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: Colors.white,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
