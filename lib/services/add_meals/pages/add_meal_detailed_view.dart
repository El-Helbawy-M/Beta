import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../base/widgets/fields/text_input_field.dart';
import '../../../config/app_states.dart';
import '../../../handlers/icon_handler.dart';
import '../../../utilities/theme/text_styles.dart';
import '../blocs/add_meal_bloc.dart';
import '../widgets/meal_view.dart';

class AddMealDetailsView extends StatelessWidget {
  const AddMealDetailsView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var bloc = BlocProvider.of<AddMealBloc>(context);
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      controller: bloc.scrollController,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: BlocBuilder<AddMealBloc, AppStates>(
          builder: (context, state) {
            return Column(
              children: [
                const SizedBox(height: 16),
                const TextInputField(
                  labelText: "اسم الوجبة",
                  hintText: "ادخل اسم الوجبة",
                ),
                const SizedBox(height: 16),
                ...List.generate(
                  bloc.elements.length,
                  (index) => MealView(
                    showRemove: bloc.elements.length > 1,
                    onRemove: () => bloc.removeElement(index),
                    index: index,
                  ),
                ),
                GestureDetector(
                  onTap: () => bloc.addElement(),
                  child: Row(
                    children: [
                      drawSvgIcon("add_circled", iconColor: Theme.of(context).colorScheme.primary),
                      const SizedBox(width: 8),
                      Text(
                        "اضافة عنصر اخر",
                        style: AppTextStyles.w400.copyWith(fontSize: 12, color: Theme.of(context).colorScheme.primary),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
