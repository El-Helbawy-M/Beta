import 'package:flutter/material.dart';
import 'package:flutter_project_base/routers/navigator.dart';
import 'package:flutter_project_base/routers/routers.dart';
import 'package:flutter_project_base/services/home/models/char_data_model.dart';
import 'package:flutter_project_base/utilities/theme/text_styles.dart';
import '../../../utilities/components/custom_page_body.dart';
import '../widgets/chart_view.dart';
import '../widgets/follow_doctor_btn.dart';
import '../widgets/service_card.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});
  final List<String> labels = const [
    "سكر الدم",
    "ضغط الدم",
    "الأدوية",
    "A1C",
    "الوزن",
  ];
  final List<String> imagesPaths = const [
    "glucose-meter 1",
    "blood-pressure-gauge 1",
    "drugs 1",
    "blood-drop 1",
    "weight-scale 1",
  ];
  final List<Function()?> onTaps = [
    () => CustomNavigator.push(Routes.diabtesList),
    () => CustomNavigator.push(Routes.pressuresList),
    () => CustomNavigator.push(Routes.medicinesList),
    null,
    null,
  ];
  @override
  Widget build(BuildContext context) {
    return CustomPageBody(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const CircleAvatar(
                    radius: 21,
                    backgroundImage: NetworkImage("https://cdn.pixabay.com/photo/2015/04/23/22/00/tree-736885__480.jpg"),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("مرحباً بك 🖐", style: AppTextStyles.w500.copyWith(fontSize: 14)),
                      Text("محمد", style: AppTextStyles.w700.copyWith(fontSize: 20)),
                    ],
                  ),
                  const Spacer(),
                  const Icon(Icons.menu),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Divider(
              height: 0,
              color: Theme.of(context).dividerColor,
            ),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    ChartWidget(
                      data: [
                        CharDataModel(label: "00:00", value: 20),
                        CharDataModel(label: "06:00", value: 120),
                        CharDataModel(label: "12:00", value: 60),
                        CharDataModel(label: "15:00", value: 70),
                        CharDataModel(label: "20:00", value: 10),
                      ],
                    ),
                    const SizedBox(height: 64),
                    const FollowDoctorButton(),
                    const SizedBox(height: 32),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("تابع حالة", style: AppTextStyles.w600.copyWith(fontSize: 20)),
                          const SizedBox(height: 16),
                          ...List.generate(
                            5,
                            (index) => ServiceCard(onTaps: onTaps[index], imagesPaths: imagesPaths[index], labels: labels[index]),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
