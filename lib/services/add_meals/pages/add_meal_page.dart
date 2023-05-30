import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_project_base/base/widgets/fields/text_input_field.dart';
import 'package:flutter_project_base/config/app_events.dart';
import 'package:flutter_project_base/config/app_states.dart';
import 'package:flutter_project_base/handlers/icon_handler.dart';
import 'package:flutter_project_base/services/add_meals/blocs/add_meal_bloc.dart';
import 'package:flutter_project_base/services/add_meals/widgets/meal_view.dart';
import 'package:flutter_project_base/services/add_medicin/blocs/add_medicin_bloc.dart';
import 'package:flutter_project_base/utilities/components/custom_btn.dart';
import 'package:flutter_project_base/utilities/components/custom_page_body.dart';
import '../../../routers/navigator.dart';
import '../../../utilities/components/arrow_back.dart';
import '../../../utilities/theme/text_styles.dart';
import 'add_meal_detailed_view.dart';

class AddMealPage extends StatefulWidget {
  const AddMealPage({super.key});

  @override
  State<AddMealPage> createState() => _AddMealPageState();
}

class _AddMealPageState extends State<AddMealPage> {
  int _index = 0;
  @override
  Widget build(BuildContext context) {
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
          "اضافة وجبة جديدة",
          style: AppTextStyles.w500.copyWith(fontSize: 18),
        ),
      ),
      body: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _index = 0;
                    });
                  },
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 400),
                    height: 56,
                    decoration: BoxDecoration(border: Border(bottom: BorderSide(width: 2, color: _index == 0 ? Theme.of(context).colorScheme.primary : Theme.of(context).hintColor.withOpacity(.2)))),
                    child: Center(
                      child: Text(
                        "محتوي تفصيلي",
                        style: AppTextStyles.w500.copyWith(fontSize: 14, color: _index == 0 ? Theme.of(context).colorScheme.primary : Theme.of(context).hintColor.withOpacity(.2)),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _index = 2;
                    });
                  },
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 400),
                    height: 56,
                    decoration: BoxDecoration(border: Border(bottom: BorderSide(width: 2, color: _index == 2 ? Theme.of(context).colorScheme.primary : Theme.of(context).hintColor.withOpacity(.2)))),
                    child: Center(
                      child: Text(
                        "صورة للوجبة",
                        style: AppTextStyles.w500.copyWith(fontSize: 14, color: _index == 2 ? Theme.of(context).colorScheme.primary : Theme.of(context).hintColor.withOpacity(.2)),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
          Expanded(
            child: _index == 0
                ? const AddMealDetailsView()
                : Center(
                    child: drawSvgIcon(
                      "upload",
                      iconColor: Theme.of(context).colorScheme.primary,
                      width: 100,
                      height: 100,
                    ),
                  ),
          ),
          if (_index == 0) const SizedBox(height: 8),
          if (_index == 0)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: CustomBtn(
                buttonColor: Theme.of(context).colorScheme.primary,
                textColor: Colors.white,
                text: "اضافة وجبة",
                onTap: () => CustomNavigator.pop(),
              ),
            ),
        ],
      ),
    );
  }
}
