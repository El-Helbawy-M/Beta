import 'package:flutter/material.dart';
import 'package:flutter_project_base/handlers/icon_handler.dart';
import 'package:flutter_project_base/routers/navigator.dart';
import 'package:flutter_project_base/utilities/components/custom_page_body.dart';
import 'package:flutter_project_base/utilities/theme/text_styles.dart';
import 'package:readmore/readmore.dart';

import '../../../utilities/components/arrow_back.dart';
import '../widgets/info_section.dart';
import '../widgets/ticket_card.dart';

class DoctorDetailsPage extends StatelessWidget {
  const DoctorDetailsPage({super.key});

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
          "د.احمد عوض",
          style: AppTextStyles.w500.copyWith(fontSize: 18),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            const SizedBox(height: 24),
            Hero(
              tag: "doctorId",
              child: Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  color: const Color(0xffD3E4FF),
                  borderRadius: BorderRadius.circular(20),
                  image: const DecorationImage(image: NetworkImage("https://th.bing.com/th/id/R.00f8e62a60bba40c1cbc109b2a8c559a?rik=MabAto9xvonFDw&pid=ImgRaw&r=0"), fit: BoxFit.cover),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              "د.احمد عوض",
              style: AppTextStyles.w700.copyWith(fontSize: 26),
            ),
            Divider(
              height: 32,
              color: Theme.of(context).dividerColor,
            ),
            InfoSection(
              label: "معلومات عن الدكتور",
              body: ReadMoreText(
                'هناك حقيقة مثبتة منذ زمن طويل وهي أن المحتوى المقروء لصفحة هناك حقيقة مثبتة منذ زمن طويل وهي أن المحتوى المقروء لصفحة لصفحة هناك حقيقة مثبتة منذ زمن طويل وهي أن المحتوى المقروء لصفحة لصفحة هناك حقيقة مثبتة منذ زمن طويل وهي أن المحتوى المقروء لصفحة هناك حقيقة مثبتة منذ زمن طويل وهي أن المحتوى المقروء لصفحة هناك حقيقة مثبتة منذ زمن طويل وهي أن المحتوى المقروء لصفحة لصفحة هناك حقيقة مثبتة منذ زمن طويل وهي أن المحتوى المقروء لصفحة لصفحة هناك حقيقة مثبتة منذ زمن طويل وهي أن المحتوى المقروء لصفحة ',
                trimLines: 3,
                colorClickableText: Theme.of(context).colorScheme.primary,
                trimMode: TrimMode.Line,
                trimCollapsedText: '\t\tاظهر المزيد',
                trimExpandedText: '\t\tاختصار',
                moreStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.primary),
                lessStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.primary),
              ),
            ),
            Divider(
              height: 32,
              color: Theme.of(context).dividerColor,
            ),
            InfoSection(
              with24Padding: false,
              label: "احجز استشارة",
              body: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Row(
                      children: [
                        drawSvgIcon("cash", iconColor: Colors.green),
                        const SizedBox(width: 8),
                        Text(
                          " 150 ج.م",
                          style: AppTextStyles.w500.copyWith(fontSize: 18, color: Colors.green),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    child: Row(
                      children: [
                        const SizedBox(width: 24),
                        TicketCard(),
                        TicketCard(isTaken: true),
                        TicketCard(isTaken: true),
                        TicketCard(),
                        TicketCard(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Divider(
            //   height: 32,
            //   color: Theme.of(context).dividerColor,
            // ),
            // InfoSection(
            //   with24Padding: false,
            //   label: "اطباء اخرون",
            //   body: Column(
            //     children: [
            //       Padding(
            //         padding: const EdgeInsets.symmetric(horizontal: 24),
            //         child: Row(
            //           children: [
            //             drawSvgIcon("cash", iconColor: Colors.green),
            //             const SizedBox(width: 8),
            //             Text(
            //               " 150 ج.م",
            //               style: AppTextStyles.w500.copyWith(fontSize: 18, color: Colors.green),
            //             ),
            //           ],
            //         ),
            //       ),
            //       const SizedBox(height: 16),
            //       SingleChildScrollView(
            //         scrollDirection: Axis.horizontal,
            //         physics: const BouncingScrollPhysics(),
            //         child: Row(
            //           children: [
            //             const SizedBox(width: 24),
            //             TicketCard(),
            //             TicketCard(isTaken: true),
            //             TicketCard(isTaken: true),
            //             TicketCard(),
            //             TicketCard(),
            //           ],
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
