import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_project_base/base/widgets/fields/date_input_field.dart';
import 'package:flutter_project_base/base/widgets/fields/text_input_field.dart';
import 'package:flutter_project_base/config/app_events.dart';
import 'package:flutter_project_base/config/app_states.dart';

import '../../../utilities/theme/text_styles.dart';
import '../blocs/add_medicin_bloc.dart';
import '../widgets/days_selector_view.dart';

class DurationStepView extends StatelessWidget {
  const DurationStepView({
    super.key,
    required this.numberOfDays,
    required this.onChooseDate,
    required this.timesInDay,
    required this.onChooseDay,
  });
  final TextEditingController timesInDay;
  final TextEditingController numberOfDays;
  final void Function(DateTime) onChooseDate;
  final void Function(String) onChooseDay;

  @override
  Widget build(BuildContext context) {
    var bloc = BlocProvider.of<AddMedicinBloc>(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: BlocBuilder<AddMedicinBloc, AppStates>(
        builder: (context, state) {
          return Column(
            children: [
              const SizedBox(height: 24),
              TextInputField(
                labelText: 'عدد المرات',
                hintText: 'ادخل عدد الكرات',
                keyboardType: TextInputType.number,
                hasError: !bloc.turnsValidation,
                errorText: "من فضلك ادخل عدد المرات",
                initialValue: bloc.turns?.toString(),
                suffixIcon: Padding(
                  padding: const EdgeInsets.only(top: 16, left: 16),
                  child: Text(
                    "مرة/يوم",
                    style: AppTextStyles.w400.copyWith(
                        color: Theme.of(context).hintColor.withOpacity(.6)),
                  ),
                ),
                onChange: (value) => bloc.turns = num.parse(value),
              ),
              TextInputField(
                labelText: 'عدد الايام',
                hintText: 'ادخل المدة',
                hasError: !bloc.durationValidation,
                errorText: "من فضلك ادخل المدة",
                keyboardType: TextInputType.number,
                initialValue: bloc.duration?.toString(),
                onChange: (value) => bloc.duration = num.parse(value),
                suffixIcon: Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Text(
                    "يوم",
                    style: AppTextStyles.w400.copyWith(
                        color: Theme.of(context).hintColor.withOpacity(.6)),
                  ),
                ),
              ),
              DateInputField(
                labelText: 'تاريخ بداية الدواء',
                hintText: 'ادخل تاريخ بداية الدواء',
                onChange: (date) {
                  bloc.days.clear();
                  bloc.startDate = date;
                  bloc.add(Update());
                  onChooseDate(date);
                },
                hasError: !bloc.startDateValidation,
                errorText: "من فضلك ادخل تاريخ بداية الدواء",
                initialValue: bloc.startDate,
              ),
              if (bloc.startDate != null)
                DaysSelectorView(
                  startDate: bloc.startDate!,
                  selectedDays: bloc.days,
                  onDaySelect: (value) {
                    if (bloc.days.contains(value)) {
                      bloc.days.remove(value);
                    } else {
                      bloc.days.add(value);
                    }
                    onChooseDay(value);
                    bloc.add(Update());
                  },
                ),
            ],
          );
        },
      ),
    );
  }
}
