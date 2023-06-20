import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_project_base/base/base_state.dart';
import 'package:flutter_project_base/base/utils.dart';
import 'package:flutter_project_base/services/profile/blocs/cubit/update_profile_cubit.dart';
import 'package:flutter_project_base/services/profile/models/appointment_model.dart';

import '../../../base/widgets/fields/text_input_field.dart';
import '../../../utilities/components/custom_btn.dart';
import '../blocs/cubit/get_profile_cubit.dart';
import '../widgets/profile_header.dart';
import '../widgets/sliver_body.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  TextEditingController name = TextEditingController(),
      phone = TextEditingController(),
      day = TextEditingController(),
      month = TextEditingController(),
      year = TextEditingController(),
      sugarType = TextEditingController();

  final GetProfileCubit getProfileCubit = GetProfileCubit();
  final UpdateProfileCubit updateProfileCubit = UpdateProfileCubit();

  @override
  void initState() {
    getProfileCubit.getProfileDetails();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final ThemeData theme = Theme.of(context);
    return Builder(builder: (context) {
      return MultiBlocListener(
        listeners: [
          BlocListener<UpdateProfileCubit, BaseState<UserModel>>(
            bloc: updateProfileCubit,
            listener: (BuildContext context, BaseState<UserModel> state) {
              if (state.isSuccess) {
                showSnackBar(
                  context,
                  'تم تحديث البيانات بنجاح',
                  type: SnackBarType.success,
                );
              }
            },
          ),
          BlocListener<GetProfileCubit, BaseState<UserModel>>(
            bloc: getProfileCubit,
            listener: (BuildContext context, BaseState<UserModel> state) {
              if (state.isSuccess) {
                if (state.item == null) return;
                name.text = state.item!.name;
                phone.text = state.item!.phone;
                sugarType.text = state.item!.sugarType ?? '';
                day.text = state.item!.birthday.day.toString();
                month.text = state.item!.birthday.month.toString();
                year.text = state.item!.birthday.year.toString();
              } else if (state.isFailure) {
                showSnackBar(
                  context,
                  state.failure?.message,
                  type: SnackBarType.error,
                );
              }
            },
          ),
        ],
        child: BlocBuilder<GetProfileCubit, BaseState<UserModel>>(
          bloc: getProfileCubit,
          builder: (BuildContext context, BaseState<UserModel> state) =>
              Scaffold(
            body: Stack(
              children: [
                SliverBody(
                  collapsedHeight: 60,
                  expandedHeight: 250,
                  flexibleSpace: ProfileHeader(
                    userName: name.text,
                  ),
                  child: SliverList(
                    delegate: SliverChildListDelegate([
                      Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'المعلومات الشخصية',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: theme.colorScheme.primary,
                                ),
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
                                      maxLength: 2,
                                      keyboardType: TextInputType.number,
                                      controller: day,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 8.0,
                                  ),
                                  Flexible(
                                    child: TextInputField(
                                      hintText: "الشهر",
                                      maxLength: 2,
                                      keyboardType: TextInputType.number,
                                      controller: month,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 8.0,
                                  ),
                                  Flexible(
                                    child: TextInputField(
                                      hintText: "السنة",
                                      maxLength: 4,
                                      keyboardType: TextInputType.number,
                                      controller: year,
                                    ),
                                  ),
                                ],
                              ),
                              BlocBuilder<UpdateProfileCubit,
                                      BaseState<UserModel>>(
                                  bloc: updateProfileCubit,
                                  builder: (BuildContext context,
                                          BaseState<UserModel> state) =>
                                      CustomBtn(
                                        buttonColor: theme.colorScheme.primary,
                                        text: "تعديل الحساب",
                                        height: 40,
                                        loading: state.isInProgress,
                                        onTap: () {
                                          DateTime newBirthday = DateTime(
                                            year.text.toInt(),
                                            month.text.toInt(),
                                            day.text.toInt(),
                                          );
                                          updateProfileCubit.updateProfile(
                                              name: name.text,
                                              phone: phone.text,
                                              birthday: newBirthday,
                                              sugerType: 'hdjsgd');
                                        },
                                      )),
                            ],
                          )),
                    ]),
                  ),
                ),
                if (state.isInProgress)
                  Container(
                    width: size.width,
                    height: size.height,
                    color: Colors.white70,
                    child: const Center(child: CircularProgressIndicator()),
                  )
              ],
            ),
          ),
        ),
      );
    });
  }
}

extension StringToInt on String {
  int toInt() {
    return int.tryParse(this) ?? 0;
  }
}
