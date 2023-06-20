import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_project_base/base/base_state.dart';
import 'package:flutter_project_base/base/utils.dart';
import 'package:flutter_project_base/base/widgets/fields/text_input_field.dart';
import 'package:flutter_project_base/handlers/shared_handler.dart';
import 'package:flutter_project_base/routers/routers.dart';
import 'package:flutter_project_base/services/authentication/login/blocs/login_cubit.dart';
import 'package:flutter_project_base/utilities/components/custom_btn.dart';
import 'package:flutter_project_base/utilities/components/custom_page_body.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController phone = TextEditingController(),
      password = TextEditingController();

  LoginCubit loginCubit = LoginCubit();

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
              hintText: "رقم الهاتف",
              controller: phone,
            ),
            TextInputField(
              hintText: "كلمة المرور",
              controller: password,
            ),
            BlocConsumer<LoginCubit, BaseState>(
              bloc: loginCubit,
              listener: (_, BaseState state) {
                if (state.isSuccess) {
                  SharedHandler.instance?.setData(
                    SharedKeys().user,
                    value: state.item,
                  );
                  Navigator.pushNamed(context, Routes.home);
                } else if (state.isFailure) {
                  showSnackBar(
                    context,
                    state.failure?.message,
                    type: SnackBarType.error,
                  );
                }
              },
              builder: (_, BaseState state) => CustomBtn(
                buttonColor: Theme.of(context).colorScheme.primary,
                text: "دخول",
                height: 40,
                loading: state.isInProgress,
                onTap: () => loginCubit.login(
                  phone: phone.text,
                  password: password.text,
                ),
              ),
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

  @override
  void dispose() {
    phone.dispose();
    password.dispose();
    super.dispose();
  }
}
