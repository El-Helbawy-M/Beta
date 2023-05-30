import 'package:flutter/material.dart';
import 'package:flutter_project_base/services/food_list/widgets/food_card_view.dart';

import '../../../routers/navigator.dart';
import '../../../routers/routers.dart';
import '../../../utilities/components/arrow_back.dart';
import '../../../utilities/components/custom_page_body.dart';
import '../../../utilities/theme/text_styles.dart';
import '../widgets/food_info_view.dart';

class FoodListPage extends StatelessWidget {
  const FoodListPage({super.key});

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
                    SizedBox(height: 16),
                    ...List.generate(
                      12,
                      (index) => const FoodCard(
                        name: "وجبة الغداء",
                        calories: 200,
                        infos: [
                          FoodInfo(label: "الكربوهيدرات", value: "20"),
                          FoodInfo(label: "البروتين", value: "20"),
                          FoodInfo(label: "الدهون", value: "20"),
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
        onPressed: () => CustomNavigator.push(Routes.addMeal),
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
