import 'package:flutter/material.dart';
import 'package:flutter_project_base/base/widgets/fields/text_input_field.dart';
import 'package:flutter_project_base/routers/routers.dart';
import 'package:flutter_project_base/utilities/components/custom_btn.dart';
import 'package:flutter_project_base/utilities/components/custom_page_body.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomPageBody(
      body: Padding(
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
              hintText: "كلمة المرور",
            ),
            CustomBtn(
              buttonColor: Theme.of(context).colorScheme.primary,
              text: "دخول",
              height: 40,
              onTap: () {},
            ),
            const SizedBox(
              height: 14,
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Row(
                children: [
                  const Text("ليس لديك حساب؟ "),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pushNamed(Routes.register);
                    },
                    child: Text(
                      "انشاء حساب",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
