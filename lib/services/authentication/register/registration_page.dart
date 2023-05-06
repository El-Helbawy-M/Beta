import 'package:flutter/material.dart';
import 'package:flutter_project_base/base/widgets/fields/text_input_field.dart';
import 'package:flutter_project_base/utilities/components/custom_btn.dart';
import 'package:flutter_project_base/utilities/components/custom_page_body.dart';
import 'package:flutter_project_base/utilities/theme/text_styles.dart';

class RegistrationPage extends StatelessWidget {
  const RegistrationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomPageBody(
      body: SingleChildScrollView(
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
                buttonColor:
                    Theme.of(context).colorScheme.error.withOpacity(0.9),
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
      ),
    );
  }
}
