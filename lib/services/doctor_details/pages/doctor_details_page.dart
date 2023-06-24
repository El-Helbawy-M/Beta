import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project_base/handlers/icon_handler.dart';
import 'package:flutter_project_base/routers/navigator.dart';
import 'package:flutter_project_base/utilities/components/custom_page_body.dart';
import 'package:flutter_project_base/utilities/theme/text_styles.dart';
import 'package:readmore/readmore.dart';

import '../../../base/utils.dart';
import '../../../config/api_names.dart';
import '../../../handlers/shared_handler.dart';
import '../../../network/network_handler.dart';
import '../../../utilities/components/arrow_back.dart';
import '../../doctors/model/doctor_model.dart';
import '../widgets/info_section.dart';
import '../widgets/ticket_card.dart';

class DoctorDetailsPage extends StatefulWidget {
  const DoctorDetailsPage(this.id, {super.key});
  final int id;

  @override
  State<DoctorDetailsPage> createState() => _DoctorDetailsPageState();
}

class _DoctorDetailsPageState extends State<DoctorDetailsPage> {
  DoctorModel? doctorDetails;
  int? userId;

  TextEditingController comment = TextEditingController();
  @override
  void initState() {
    getItems();
    super.initState();
  }

  Future<void> getUserID() async {
    userId = (await SharedHandler.instance?.getData(
        key: SharedKeys().user,
        valueType: ValueType.map) as Map<String, dynamic>)['id'];
  }

  void getItems() async {
    await getUserID();
    try {
      final Response? response = await NetworkHandler.instance?.get(
        url: '${ApiNames.doctorList}${widget.id}',
        withToken: true,
      );

      if (response == null) return;
      if (!mounted) return;

      doctorDetails = DoctorModel.fromJson(response.data['data']);
      setState(() {});
    } on DioError catch (e) {
      String? msg = e.response?.data.toString();

      if (e.response?.data is Map &&
          (e.response?.data as Map).containsKey('errors')) {
        msg = e.response?.data['errors'].toString();
      }

      showSnackBar(
        context,
        msg,
        type: SnackBarType.warning,
      );
    }
  }

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
          doctorDetails == null ? '' : "د.احمد عوض",
          style: AppTextStyles.w500.copyWith(fontSize: 18),
        ),
      ),
      body: doctorDetails == null
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
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
                        image: DecorationImage(
                            image:
                                NetworkImage(doctorDetails!.profilePic ?? ''),
                            fit: BoxFit.cover),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    doctorDetails?.name ?? '',
                    style: AppTextStyles.w700.copyWith(fontSize: 26),
                  ),
                  Divider(
                    height: 32,
                    color: Theme.of(context).dividerColor,
                  ),
                  InfoSection(
                    label: "معلومات عن الدكتور",
                    body: ReadMoreText(
                      doctorDetails!.bio ?? '',
                      trimLines: 3,
                      colorClickableText: Theme.of(context).colorScheme.primary,
                      trimMode: TrimMode.Line,
                      trimCollapsedText: '\t\tاظهر المزيد',
                      trimExpandedText: '\t\tاختصار',
                      moreStyle: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary),
                      lessStyle: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary),
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
                                style: AppTextStyles.w500.copyWith(
                                    fontSize: 18, color: Colors.green),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          physics: const BouncingScrollPhysics(),
                          child: Row(
                              children: (doctorDetails?.appointments ?? [])
                                  .map((e) => TicketCard(e, doctorDetails))
                                  .toList()),
                        ),
                      ],
                    ),
                  ),
                  const Divider(),
                  const Text(
                    'التعليقات',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 22),
                    child: TextFormField(
                      maxLines: 4,
                      controller: comment,
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: TextButton(
                      onPressed: () async {
                        if (comment.text.isEmpty) return;
                        DoctorCommentsController.instance.addComment(
                          userId: userId!.toString(),
                          comment: comment.text,
                        );
                        setState(() {});
                      },
                      child: const Text('أضف تعليق'),
                    ),
                  ),
                  ListView.separated(
                    shrinkWrap: true,
                    padding: const EdgeInsets.symmetric(horizontal: 22),
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (_, int index) => Container(
                      color: Colors.grey[300],
                      padding: const EdgeInsets.all(8),
                      child: Text(DoctorCommentsController
                              .instance.comments[userId]?[index] ??
                          ''),
                    ),
                    separatorBuilder: (_, __) => const Divider(),
                    itemCount: DoctorCommentsController
                            .instance.comments[userId]?.length ??
                        0,
                  )
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

class DoctorCommentsController {
  DoctorCommentsController._();

  static DoctorCommentsController instance = DoctorCommentsController._();

  Map<String, List<String>> comments = {};

  void addComment({required String userId, required String comment}) {
    List<String>? list = comments[userId] ?? [];
    comments[userId] = [comment, ...list];
  }
}
