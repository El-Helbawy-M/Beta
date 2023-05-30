import 'package:flutter/material.dart';
import 'package:flutter_project_base/routers/navigator.dart';
import 'package:flutter_project_base/routers/routers.dart';
import '../../../utilities/theme/text_styles.dart';
import 'info_chip.dart';

class DoctorCard extends StatelessWidget {
  const DoctorCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          GestureDetector(
            onTap: () => CustomNavigator.push(Routes.doctorDetails),
            child: Stack(
              alignment: Alignment.bottomCenter,
              clipBehavior: Clip.none,
              children: [
                Container(
                  height: 150,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(width: 1, color: Theme.of(context).dividerColor),
                  ),
                  child: Row(children: [
                    const SizedBox(width: 100),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "احمد",
                            style: AppTextStyles.w500.copyWith(fontSize: 18),
                          ),
                          const SizedBox(height: 4),
                          Expanded(
                            child: Text(
                              "هناك حقيقة مثبتة منذ زمن طويل وهي أن المحتوى المقروء لصفحة\nهناك حقيقة مثبتة منذ زمن طويل وهي أن المحتوى المقروء لصفحة",
                              overflow: TextOverflow.ellipsis,
                              maxLines: 3,
                              style: AppTextStyles.w500.copyWith(fontSize: 12, color: Theme.of(context).hintColor),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              InfoChip(
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.star,
                                      size: 16,
                                      color: Theme.of(context).colorScheme.primary,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      "4.5",
                                      style: AppTextStyles.w500.copyWith(fontSize: 12),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 8),
                              InfoChip(
                                child: Text(
                                  "طبيب عيون",
                                  style: AppTextStyles.w500.copyWith(fontSize: 12),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ]),
                ),
                Positioned(
                  right: 0,
                  bottom: 1,
                  child: Hero(
                    tag: "doctorId",
                    child: Image.network(
                      "https://th.bing.com/th/id/R.40cbdaf81075c195fa1e6a815be1aba0?rik=v1fvLsWdR5hHhw&pid=ImgRaw&r=0",
                      width: 100,
                      height: 170,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
