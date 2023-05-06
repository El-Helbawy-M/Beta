import 'package:flutter/material.dart';
import 'package:flutter_project_base/utilities/components/custom_page_body.dart';

import '../../../../base/widgets/fields/text_input_field.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const CustomPageBody(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextInputField(
              labelText: "Email",
              hintText: "Enter the email",
              keyboardType: TextInputType.emailAddress,
            ),
            TextInputField(
              labelText: "Password",
              hintText: "Enter the password",
              keyboardType: TextInputType.visiblePassword,
            ),
          ],
        ),
      ),
    );
  }
}
