import 'package:flutter/material.dart';
import 'package:flutter_project_base/services/food_list/widgets/food_card_view.dart';

import '../../../routers/navigator.dart';
import '../../../routers/routers.dart';
import '../../../utilities/components/custom_page_body.dart';
import '../../../utilities/theme/text_styles.dart';
import '../../add_meals/models/element_model.dart';
import '../widgets/food_info_view.dart';

class FoodListPage extends StatefulWidget {
  const FoodListPage({super.key});

  @override
  State<FoodListPage> createState() => _FoodListPageState();
}

class _FoodListPageState extends State<FoodListPage> {
  List<MealElementModel> items = [];

  @override
  Widget build(BuildContext context) {
    return CustomPageBody(
      // appBar: AppBar(
      //   backgroundColor: Colors.white,
      //   elevation: .2,
      //   titleSpacing: 4,
      //   title: Text(
      //     "قائمة الوجبات",
      //     style: AppTextStyles.w500.copyWith(fontSize: 18),
      //   ),
      // ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                "قائمة الوجبات",
                style: AppTextStyles.w500.copyWith(fontSize: 18),
              ),
            ),
            const SizedBox(height: 16),
            Divider(
              height: 0,
              color: Theme.of(context).dividerColor,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: ListView(
                  physics: const BouncingScrollPhysics(),
                  children: [
                    const SizedBox(height: 16),
                    ...List.generate(
                      items.length,
                      (index) => FoodCard(
                        name: items[index].name ?? '',
                        calories: 200,
                        infos: [
                          FoodInfo(
                              label: "الكربوهيدرات",
                              value: items[index].carbohydrates.toString()),
                          FoodInfo(
                              label: "البروتين",
                              value: items[index].protein.toString()),
                          FoodInfo(
                              label: "الدهون",
                              value: items[index].fat.toString()),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await CustomNavigator.push(Routes.addMeal);
          if (result == null) return;
          print(result);
          items.add(MealElementModel(
            name: result['name'],
            calories: result['totalCalories'],
            carbohydrates: result['totalCarbohydrates'],
            fat: result['totalFat'],
            protein: result['totalProtein'],
          ));

          setState(() {});
        },
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
