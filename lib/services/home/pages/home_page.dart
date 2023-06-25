import 'dart:math';

import 'package:collection/collection.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project_base/routers/navigator.dart';
import 'package:flutter_project_base/routers/routers.dart';
import 'package:flutter_project_base/services/home/models/char_data_model.dart';
import 'package:flutter_project_base/utilities/theme/text_styles.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../base/utils.dart';
import '../../../config/api_names.dart';
import '../../../handlers/shared_handler.dart';
import '../../../network/network_handler.dart';
import '../../../utilities/components/custom_page_body.dart';
import '../widgets/chart_view.dart';
import '../widgets/follow_doctor_btn.dart';
import '../widgets/service_card.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<String> labels = const [
    "سكر الدم",
    "ضغط الدم",
    "الأدوية",
    // "A1C",
    "الوزن",
  ];

  final List<String> imagesPaths = const [
    "glucose-meter 1",
    "blood-pressure-gauge 1",
    "drugs 1",
    // "blood-drop 1",
    "weight-scale 1",
  ];

  final List<Function()?> onTaps = [
    () => CustomNavigator.push(Routes.diabtesList),
    () => CustomNavigator.push(Routes.pressuresList),
    () => CustomNavigator.push(Routes.medicinesList),
    // null,
    () => CustomNavigator.push(Routes.weightList),
  ];

  List<MapEntry<String, int>> items = <MapEntry<String, int>>[];

  String? userName;
  bool loading = false;

  @override
  void initState() {
    askForCameraPermission();
    getUserName();
    getItems(ApiNames.bloodSugarList);
    super.initState();
  }

  Future<void> getUserName() async {
    userName = await SharedHandler.instance
        ?.getData(key: SharedKeys().user, valueType: ValueType.map)['name'];
  }

  void askForCameraPermission() async {
    var status = await Permission.camera.status;
    if (!status.isGranted) {
      await Permission.camera.request();
    }
  }

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
                    backgroundImage: NetworkImage(
                        "https://cdn.pixabay.com/photo/2015/04/23/22/00/tree-736885__480.jpg"),
                  ),
                  const SizedBox(width: 16),
                  if (userName != null)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("مرحباً 🖐",
                            style: AppTextStyles.w500.copyWith(fontSize: 14)),
                        Text(userName ?? '',
                            style: AppTextStyles.w700.copyWith(fontSize: 20)),
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
                    loading
                        ? const Center(
                            child: CircularProgressIndicator(),
                          )
                        : items.isEmpty
                            ? const SizedBox()
                            : ChartWidget(
                                data: items
                                    .map((e) => CharDataModel(
                                        label: e.key, value: e.value))
                                    .toList(),
                                max: items.isEmpty
                                    ? 0
                                    : items
                                        .map((e) => e.value)
                                        .toList()
                                        .reduce(max),
                                onSelectItem: (option) {
                                  getItems(option.value);
                                },
                              ),
                    const SizedBox(height: 64),
                    const FollowDoctorButton(),
                    const SizedBox(height: 32),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("تابع حالة",
                              style: AppTextStyles.w600.copyWith(fontSize: 20)),
                          const SizedBox(height: 16),
                          ...List.generate(
                            4,
                            (index) => ServiceCard(
                                onTaps: onTaps[index],
                                imagesPaths: imagesPaths[index],
                                labels: labels[index]),
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

  void getItems(String url) async {
    try {
      loading = true;
      setState(() {});

      final Response? response = await NetworkHandler.instance?.get(
        url: url,
        withToken: true,
      );

      if (response == null) return;
      if (!mounted) return;

      List<ChartItem> chartItems = <ChartItem>[];

      for (var item in response.data['data']) {
        print(item['sugar_concentration']);
        // items.add(
        //     MapEntry('test', int.tryParse(item['sugar_concentration']) ?? 0));

        // chartItems
        //     .add(ChartItem(item: 'kk', value: DateTime.parse(item['date'])));
      }

      print(groupBy(
          chartItems, (p0) => DateFormat('dd-MM-yyyy').format(p0.value)));

      for (var item in chartItems) {
        items.add(MapEntry(item.item, 30));
      }
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
    loading = false;
    setState(() {});
  }
}

class ChartItem {
  final String item;
  final DateTime value;
  ChartItem({
    required this.value,
    required this.item,
  });
}
