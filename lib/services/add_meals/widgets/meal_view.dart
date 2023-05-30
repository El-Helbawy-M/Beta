import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_project_base/base/widgets/fields/text_input_field.dart';
import 'package:flutter_project_base/config/app_states.dart';
import 'package:flutter_project_base/handlers/icon_handler.dart';

import '../blocs/add_meal_bloc.dart';

class MealView extends StatelessWidget {
  const MealView({super.key, this.onRemove, required this.index, required this.showRemove});
  final bool showRemove;
  final Function()? onRemove;
  final int index;
  @override
  Widget build(BuildContext context) {
    var bloc = context.read<AddMealBloc>();
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(width: 1, color: Colors.grey.withOpacity(.4)),
      ),
      child: Column(
        children: [
          if (showRemove)
            Align(
              alignment: Alignment.topLeft,
              child: GestureDetector(
                onTap: () {
                  onRemove?.call();

                  FocusScope.of(context).unfocus();
                },
                child: drawSvgIcon("remove", iconColor: Theme.of(context).colorScheme.primary),
              ),
            ),
          const SizedBox(height: 8),
          TextInputField(
            labelText: "اسم العنصر",
            hintText: "ادخل اسم العنصر",
            onChange: (value) => bloc.elements[index].name = value,
            initialValue: bloc.elements[index].name,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: TextInputField(
                  labelText: "كالوريز",
                  hintText: "ادخل كالوريز",
                  keyboardType: TextInputType.number,
                  onChange: (value) => bloc.elements[index].calories = num.parse(value),
                  initialValue: bloc.elements[index].calories?.toString(),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: TextInputField(
                  labelText: "دهون",
                  hintText: "ادخل دهون",
                  keyboardType: TextInputType.number,
                  onChange: (value) => bloc.elements[index].fat = num.parse(value),
                  initialValue: bloc.elements[index].fat?.toString(),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: TextInputField(
                  labelText: "كاربوهيادرات",
                  hintText: "ادخل كاربوهيادرات",
                  keyboardType: TextInputType.number,
                  onChange: (value) => bloc.elements[index].carbohydrates = num.parse(value),
                  initialValue: bloc.elements[index].carbohydrates?.toString(),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: TextInputField(
                  labelText: "بروتين",
                  hintText: "ادخل بروتين",
                  keyboardType: TextInputType.number,
                  onChange: (value) => bloc.elements[index].protein = num.parse(value),
                  initialValue: bloc.elements[index].protein?.toString(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
