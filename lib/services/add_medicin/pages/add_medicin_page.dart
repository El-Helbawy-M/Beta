import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_project_base/config/app_events.dart';
import 'package:flutter_project_base/config/app_states.dart';
import 'package:flutter_project_base/services/add_medicin/blocs/add_medicin_bloc.dart';
import 'package:flutter_project_base/utilities/components/custom_btn.dart';
import 'package:flutter_project_base/utilities/components/custom_page_body.dart';

import '../../../routers/navigator.dart';
import '../../../utilities/components/arrow_back.dart';
import '../../../utilities/theme/text_styles.dart';
import '../widgets/indicator_header.dart';
import 'duration_step_view.dart';
import 'medicins_step_view.dart';

class AddMedicinPage extends StatelessWidget {
  const AddMedicinPage({super.key});

  @override
  Widget build(BuildContext context) {
    var bloc = BlocProvider.of<AddMedicinBloc>(context);
    return CustomPageBody(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: .2,
        leading: InkWell(
          onTap: () => CustomNavigator.pop(),
          highlightColor: Colors.transparent,
          splashColor: Colors.transparent,
          child: Row(
            children: const [
              SizedBox(width: 16),
              ArrowBack(),
            ],
          ),
        ),
        titleSpacing: 4,
        title: Text(
          "اضافة دواء جديد",
          style: AppTextStyles.w500.copyWith(fontSize: 18),
        ),
      ),
      body: BlocBuilder<AddMedicinBloc, AppStates>(
        builder: (context, state) {
          return Column(
            children: [
              IndicatorHeader(
                title: bloc.pageIndex != 0 ? "تفاصيل الدواء" : "مدة الدواء",
                totalSteps: 2,
                progress: bloc.pageIndex,
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: bloc.pageIndex == 0
                      ? const MedicinsStepView()
                      : const DurationStepView(),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                child: Row(
                  children: [
                    if (bloc.pageIndex != 0)
                      Expanded(
                        child: CustomBtn(
                          text: "السابق",
                          buttonColor: Colors.transparent,
                          borderColor: Theme.of(context).colorScheme.primary,
                          textColor: Theme.of(context).colorScheme.primary,
                          onTap: () => bloc.add(Back()),
                        ),
                      ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: CustomBtn(
                        text: bloc.pageIndex == 0 ? "التالي" : "ارسال",
                        onTap: () => bloc.add(Next()),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16)
            ],
          );
        },
      ),
    );
  }
}
