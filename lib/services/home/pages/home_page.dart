import 'package:flutter/material.dart';
import 'package:flutter_project_base/handlers/icon_handler.dart';
import 'package:flutter_project_base/services/home/models/char_data_model.dart';
import 'package:flutter_project_base/utilities/theme/media.dart';
import 'package:flutter_project_base/utilities/theme/text_styles.dart';
import '../../../utilities/components/custom_page_body.dart';
import '../widgets/chart_view.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});
  final List<String> labels = const [
    "سكر الدم",
    "ضغط الدم",
    "الأدوية",
    "A1C",
    "الوزن",
    "الطعام",
  ];
  final List<String> imagesPaths = const [
    "glucose-meter 1",
    "blood-pressure-gauge 1",
    "drugs 1",
    "blood-drop 1",
    "weight-scale 1",
    "dinner 1",
  ];
  final List<Function()?> onTaps = const [
    null,
    null,
    null,
    null,
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
                  CircleAvatar(
                    radius: 21,
                    backgroundImage: NetworkImage("https://cdn.pixabay.com/photo/2015/04/23/22/00/tree-736885__480.jpg"),
                  ),
                  SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("مرحباً بك 🖐", style: AppTextStyles.w500.copyWith(fontSize: 14)),
                      Text("محمد", style: AppTextStyles.w700.copyWith(fontSize: 20)),
                    ],
                  ),
                  Spacer(),
                  Icon(Icons.menu),
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
                physics: BouncingScrollPhysics(),
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
                    FollowDoctorButton(),
                    const SizedBox(height: 32),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("تابع حالة", style: AppTextStyles.w700.copyWith(fontSize: 16)),
                          const SizedBox(height: 16),
                          ...List.generate(
                            6,
                            (index) => GestureDetector(
                              onTap: onTaps[index],
                              child: Container(
                                height: 64,
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                margin: const EdgeInsets.only(bottom: 16),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: Theme.of(context).dividerColor.withOpacity(.05)),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Theme.of(context).dividerColor.withOpacity(.02),
                                      blurRadius: 8,
                                      offset: Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Image.asset("assets/images/${imagesPaths[index]}.png", width: 32, height: 32),
                                    const SizedBox(width: 16),
                                    Text(
                                      labels[index],
                                      style: AppTextStyles.w700.copyWith(fontSize: 22),
                                    ),
                                  ],
                                ),
                              ),
                            ),
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

class FollowDoctorButton extends StatelessWidget {
  const FollowDoctorButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          height: 64,
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          margin: const EdgeInsets.symmetric(horizontal: 24),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            "تابع مع أحد الأطباء",
            style: AppTextStyles.w700.copyWith(fontSize: 22, color: Colors.white),
          ),
        ),
        Positioned(
          bottom: 0,
          left: 24,
          child: Image.asset(
            "assets/images/follow_image.png",
            width: 134,
            height: 95,
          ),
        )
      ],
    );
  }
}
