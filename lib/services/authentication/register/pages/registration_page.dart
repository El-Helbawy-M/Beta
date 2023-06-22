import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_project_base/base/widgets/fields/text_input_field.dart';
import 'package:flutter_project_base/routers/routers.dart';
import 'package:flutter_project_base/services/authentication/register/blocs/cubit/handler.dart';
import 'package:flutter_project_base/utilities/components/custom_btn.dart';
import 'package:flutter_project_base/utilities/components/custom_page_body.dart';
import 'package:flutter_project_base/utilities/theme/text_styles.dart';

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

class MainRegisterPage extends StatelessWidget {
  const MainRegisterPage({super.key});

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
            ),
            TextInputField(
              hintText: "رقم الهاتف",
            ),
            Row(
              children: [
                Flexible(
                  child: TextInputField(
                    hintText: "اليوم",
                  ),
                ),
                const SizedBox(
                  width: 8.0,
                ),
                Flexible(
                  child: TextInputField(
                    hintText: "الشهر",
                  ),
                ),
                const SizedBox(
                  width: 8.0,
                ),
                Flexible(
                  child: TextInputField(
                    hintText: "السنه",
                  ),
                ),
              ],
            ),
            TextInputField(
              hintText: "كلمة المرور",
            ),
            TextInputField(
              hintText: "تأكيد كلمة المرور",
            ),
            CustomBtn(
              buttonColor: Theme.of(context).colorScheme.primary,
              text: "التالي",
              height: 40,
              onTap: () {
                context.read<RegisterHandler>().mainNext();
              },
            ),
          ],
        ),
      ),
    );
  }
}

class RegisterInfoTypePage extends StatelessWidget {
  final RegisterCurrentState registerCurrentState;
  const RegisterInfoTypePage({super.key, required this.registerCurrentState});

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
            isSelected: registerCurrentState.typeValue == "النوع الاول",
            onTap: () {
              context
                  .read<RegisterHandler>()
                  .updateTypeValue(typeValue: "النوع الاول");
            },
          ),
          const SizedBox(height: 16),
          SelectionWidget(
            value: "النوع التاني",
            isSelected: registerCurrentState.typeValue == "النوع التاني",
            onTap: () {
              context
                  .read<RegisterHandler>()
                  .updateTypeValue(typeValue: "النوع التاني");
            },
          ),
          const SizedBox(height: 16),
          SelectionWidget(
            value: "ما قبل السُكري",
            isSelected: registerCurrentState.typeValue == "ما قبل السُكري",
            onTap: () {
              context
                  .read<RegisterHandler>()
                  .updateTypeValue(typeValue: "ما قبل السُكري");
            },
          ),
          const SizedBox(height: 16),
          SelectionWidget(
            value: "أُخري",
            isSelected: registerCurrentState.typeValue == "أُخري",
            onTap: () {
              context
                  .read<RegisterHandler>()
                  .updateTypeValue(typeValue: "أُخري");
            },
          ),
          const SizedBox(height: 16),
          if (registerCurrentState.typeValue != null)
            Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                CustomBtn(
                  buttonColor: Theme.of(context).colorScheme.primary,
                  text: "التالي",
                  height: 40,
                  onTap: () {
                    context.read<RegisterHandler>().typeNext();
                  },
                ),
              ],
            ),
        ],
      ),
    );
  }
}

class RegisterDurationPage extends StatelessWidget {
  final RegisterCurrentState registerCurrentState;
  const RegisterDurationPage({super.key, required this.registerCurrentState});

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
            isSelected: registerCurrentState.durationValue == "أقل من 6 أشهر",
            onTap: () {
              context
                  .read<RegisterHandler>()
                  .updateDurationValue(durationValue: "أقل من 6 أشهر");
            },
          ),
          const SizedBox(height: 16),
          SelectionWidget(
            value: "أقل من سنه",
            isSelected: registerCurrentState.durationValue == "أقل من سنه",
            onTap: () {
              context
                  .read<RegisterHandler>()
                  .updateDurationValue(durationValue: "أقل من سنه");
            },
          ),
          const SizedBox(height: 16),
          SelectionWidget(
            value: "من 1 سنه الي 5 سنين",
            isSelected:
                registerCurrentState.durationValue == "من 1 سنه الي 5 سنين",
            onTap: () {
              context
                  .read<RegisterHandler>()
                  .updateDurationValue(durationValue: "من 1 سنه الي 5 سنين");
            },
          ),
          const SizedBox(height: 16),
          SelectionWidget(
            value: "أكثر من 5 سنين",
            isSelected: registerCurrentState.durationValue == "أكثر من 5 سنين",
            onTap: () {
              context
                  .read<RegisterHandler>()
                  .updateDurationValue(durationValue: "أكثر من 5 سنين");
            },
          ),
          const SizedBox(height: 20),
          if (registerCurrentState.durationValue != null)
            Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                CustomBtn(
                  buttonColor: Theme.of(context).colorScheme.primary,
                  text: "التالي",
                  height: 40,
                  onTap: () {
                    context.read<RegisterHandler>().durationNext();
                  },
                ),
              ],
            ),
        ],
      ),
    );
  }
}

class RegisterCountsPage extends StatelessWidget {
  final RegisterCurrentState registerCurrentState;
  const RegisterCountsPage({super.key, required this.registerCurrentState});

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
            isSelected: registerCurrentState.countValue == "مرة في اليوم",
            onTap: () {
              context
                  .read<RegisterHandler>()
                  .updateCountValue(countValue: "مرة في اليوم");
            },
          ),
          const SizedBox(height: 16),
          SelectionWidget(
            value: "مرتين في اليوم",
            isSelected: registerCurrentState.countValue == "مرتين في اليوم",
            onTap: () {
              context
                  .read<RegisterHandler>()
                  .updateCountValue(countValue: "مرتين في اليوم");
            },
          ),
          const SizedBox(height: 16),
          SelectionWidget(
            value: "اكثر من مرتين في اليوم",
            isSelected:
                registerCurrentState.countValue == "اكثر من مرتين في اليوم",
            onTap: () {
              context
                  .read<RegisterHandler>()
                  .updateCountValue(countValue: "اكثر من مرتين في اليوم");
            },
          ),
          const SizedBox(height: 16),
          SizedBox(height: MediaQuery.of(context).size.height * 0.15),
          if (registerCurrentState.countValue != null)
            Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                CustomBtn(
                  buttonColor: Theme.of(context).colorScheme.primary,
                  text: "التالي",
                  height: 40,
                  onTap: () {
                    context.read<RegisterHandler>().countNext();
                    Navigator.of(context).pushNamed(Routes.home);
                  },
                ),
              ],
            ),
          const SizedBox(height: 16),
        ],
      ),
    );
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
