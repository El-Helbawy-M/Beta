import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_project_base/base/widgets/fields/text_input_field.dart';
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
        body: BlocBuilder<RegisterHandler, RegisterState>(
          builder: (context, state) {
            if (state is RegisterCurrentState &&
                state.currentState == CurrentState.mainScreen) {
              return const MainRegisterPage();
            } else if (state is RegisterCurrentState &&
                state.currentState == CurrentState.infoType) {
              return const RegisterInfoTypePage();
            } else if (state is RegisterCurrentState &&
                state.currentState == CurrentState.infoDuration) {
              return const RegisterDurationPage();
            } else if (state is RegisterCurrentState &&
                state.currentState == CurrentState.infoCounts) {
              return RegisterCountsPage();
            } else {
              return const SizedBox();
            }
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
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 98),
        child: Column(
          children: [
            Center(
              child: Text("إنشاء حساب",
                  style: AppTextStyles.w700.copyWith(fontSize: 32)),
            ),
            const SizedBox(
              height: 32,
            ),
            TextInputField(
              hintText: "الإسم",
            ),
            TextInputField(
              hintText: "رقم الهاتف",
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Flexible(
                  child: TextInputField(hintText: "اليوم"),
                ),
                const SizedBox(
                  width: 8.0,
                ),
                Flexible(
                  child: TextInputField(hintText: "الشهر"),
                ),
                const SizedBox(
                  width: 8.0,
                ),
                Flexible(
                  child: TextInputField(hintText: "السنه"),
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
              buttonColor: Theme.of(context).colorScheme.secondary,
              text: "التالي",
              height: 40,
              onTap: () {
                context.read<RegisterHandler>().mainNext();
              },
            ),
            const SizedBox(
              height: 40,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Center(
                child: Row(
                  children: [
                    Expanded(
                      child: Divider(
                        height: 1,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        'أو',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                    Expanded(
                      child: Divider(
                        height: 1,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            CustomBtn(
              buttonColor: Theme.of(context).colorScheme.primary,
              text: "تسجيل الدخول بإستخدام فيسبوك",
              height: 40,
              icon: Padding(
                padding: const EdgeInsets.only(right: 15),
                child: Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Image.asset(
                    "assets/images/facebook.png",
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            CustomBtn(
              buttonColor: Theme.of(context).colorScheme.error.withOpacity(0.9),
              text: "تسجيل الدخول بإستخدام جوجل",
              height: 40,
              icon: Padding(
                padding: const EdgeInsets.only(right: 15),
                child: Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Image.asset(
                    "assets/images/google.png",
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RegisterInfoTypePage extends StatelessWidget {
  const RegisterInfoTypePage({super.key});

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
          Container(
            decoration: context.read<RegisterHandler>().getBoxDecoration(),
            child: CustomBtn(
              buttonColor:
                  Theme.of(context).colorScheme.onSecondary.withOpacity(0.2),
              text: "النوع الاول",
              height: 40,
              textColor: Colors.black,
              onTap: () {
                context.read<RegisterHandler>().typeNext();
              },
            ),
          ),
          const SizedBox(height: 16),
          Container(
            decoration: context.read<RegisterHandler>().getBoxDecoration(),
            child: CustomBtn(
              buttonColor:
                  Theme.of(context).colorScheme.onSecondary.withOpacity(0.2),
              text: "النوع التاني",
              height: 40,
              textColor: Colors.black,
              onTap: () {
                context.read<RegisterHandler>().typeNext();
              },
            ),
          ),
          const SizedBox(height: 16),
          Container(
            decoration: context.read<RegisterHandler>().getBoxDecoration(),
            child: CustomBtn(
              buttonColor:
                  Theme.of(context).colorScheme.onSecondary.withOpacity(0.2),
              text: "ما قبل السُكري",
              height: 40,
              textColor: Colors.black,
              onTap: () {
                context.read<RegisterHandler>().typeNext();
              },
            ),
          ),
          const SizedBox(height: 16),
          Container(
            decoration: context.read<RegisterHandler>().getBoxDecoration(),
            child: CustomBtn(
              buttonColor:
                  Theme.of(context).colorScheme.onSecondary.withOpacity(0.2),
              text: "أُخري",
              height: 40,
              textColor: Colors.black,
              onTap: () {
                context.read<RegisterHandler>().typeNext();
              },
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

class RegisterDurationPage extends StatelessWidget {
  const RegisterDurationPage({super.key});

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
          Container(
            decoration: context.read<RegisterHandler>().getBoxDecoration(),
            child: CustomBtn(
              buttonColor:
                  Theme.of(context).colorScheme.onSecondary.withOpacity(0.2),
              text: "أقل من 6 أشهر",
              height: 40,
              textColor: Colors.black,
              onTap: () {
                context.read<RegisterHandler>().durationNext();
              },
            ),
          ),
          const SizedBox(height: 16),
          Container(
            decoration: context.read<RegisterHandler>().getBoxDecoration(),
            child: CustomBtn(
              buttonColor:
                  Theme.of(context).colorScheme.onSecondary.withOpacity(0.2),
              text: "أقل من سنه",
              height: 40,
              textColor: Colors.black,
              onTap: () {
                context.read<RegisterHandler>().durationNext();
              },
            ),
          ),
          const SizedBox(height: 16),
          Container(
            decoration: context.read<RegisterHandler>().getBoxDecoration(),
            child: CustomBtn(
              buttonColor:
                  Theme.of(context).colorScheme.onSecondary.withOpacity(0.2),
              text: "من 1 سنه الي 5 سنين",
              height: 40,
              textColor: Colors.black,
              onTap: () {
                context.read<RegisterHandler>().durationNext();
              },
            ),
          ),
          const SizedBox(height: 16),
          Container(
            decoration: context.read<RegisterHandler>().getBoxDecoration(),
            child: CustomBtn(
              buttonColor:
                  Theme.of(context).colorScheme.onSecondary.withOpacity(0.2),
              text: "أكثر من 5 سنين",
              height: 40,
              textColor: Colors.black,
              onTap: () {
                context.read<RegisterHandler>().durationNext();
              },
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

class RegisterCountsPage extends StatelessWidget {
  const RegisterCountsPage({super.key});

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
          Container(
            decoration: context.read<RegisterHandler>().getBoxDecoration(),
            child: CustomBtn(
              buttonColor:
                  Theme.of(context).colorScheme.onSecondary.withOpacity(0.2),
              text: "مرة في اليوم",
              height: 40,
              textColor: Colors.black,
              onTap: () {
                // context.read<RegisterHandler>().typeNext();
              },
            ),
          ),
          const SizedBox(height: 16),
          Container(
            decoration: context.read<RegisterHandler>().getBoxDecoration(),
            child: CustomBtn(
              buttonColor:
                  Theme.of(context).colorScheme.onSecondary.withOpacity(0.2),
              text: "مرتين في اليوم",
              height: 40,
              textColor: Colors.black,
              onTap: () {
                // context.read<RegisterHandler>().typeNext();
              },
            ),
          ),
          const SizedBox(height: 16),
          Container(
            decoration: context.read<RegisterHandler>().getBoxDecoration(),
            child: CustomBtn(
              buttonColor:
                  Theme.of(context).colorScheme.onSecondary.withOpacity(0.2),
              text: "اكثر من مرتين في اليوم",
              height: 40,
              textColor: Colors.black,
              onTap: () {
                // context.read<RegisterHandler>().typeNext();
              },
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.15),
          CustomBtn(
            buttonColor: Theme.of(context).colorScheme.secondary,
            text: "إبدأ",
            height: 40,
            onTap: () {
              context.read<RegisterHandler>().mainNext();
            },
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
