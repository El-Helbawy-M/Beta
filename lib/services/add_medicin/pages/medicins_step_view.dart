import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_project_base/base/models/select_option.dart';
import 'package:flutter_project_base/base/widgets/fields/single_select_bottomsheet/single_select_input_field.dart';
import 'package:flutter_project_base/base/widgets/fields/text_input_field.dart';
import 'package:flutter_project_base/config/app_events.dart';
import '../blocs/add_medicin_bloc.dart';

class MedicinsStepView extends StatefulWidget {
  const MedicinsStepView({super.key});

  @override
  State<MedicinsStepView> createState() => _MedicinsStepViewState();
}

class _MedicinsStepViewState extends State<MedicinsStepView> {
  Timer? timer;

  @override
  Widget build(BuildContext context) {
    var bloc = BlocProvider.of<AddMedicinBloc>(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: () {
                    bloc.isTablets = true;
                    bloc.add(Update());
                  },
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    height: 60,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Theme.of(context).colorScheme.primary, width: 1),
                      color: bloc.isTablets ? Theme.of(context).colorScheme.primary : Colors.transparent,
                    ),
                    child: Center(
                      child: Text(
                        "اقراص",
                        style: TextStyle(color: !bloc.isTablets ? Theme.of(context).colorScheme.primary : Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: InkWell(
                  onTap: () {
                    bloc.isTablets = false;
                    bloc.add(Update());
                  },
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    height: 60,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Theme.of(context).colorScheme.primary, width: 1),
                      color: bloc.isTablets ? Colors.transparent : Theme.of(context).colorScheme.primary,
                    ),
                    child: Center(
                      child: Text("حقن", style: TextStyle(color: bloc.isTablets ? Theme.of(context).colorScheme.primary : Colors.white)),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          TextInputField(
            labelText: 'اسم الدواء',
            hintText: 'ادخل اسم الدواء',
            keyboardType: TextInputType.text,
            hasError: !bloc.nameValidation,
            errorText: "من فضلك ادخل اسم الدواء",
            initialValue: bloc.name?.toString(),
            onChange: (value) {
              if (timer != null) timer!.cancel();
              timer = Timer(const Duration(milliseconds: 500), () {
                bloc.name = value;
                bloc.add(Update());
              });
            },
          ),
          const SizedBox(height: 16),
          if (bloc.name == "انسولين")
            SingleSelectSheetField(
              labelText: "نوع الانسولين",
              hintText: "اختر نوع الانسولين",
              onChange: (value) => bloc.insulenType = value,
              initialValue: bloc.insulenType,
              valueSet: [
                SelectOption(1, "النوع الاول"),
                SelectOption(2, "النوع الثاني"),
                SelectOption(3, "النوع الثالث"),
                SelectOption(4, "النوع الرابع"),
              ],
            ),
        ],
      ),
    );
  }
}
