import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_project_base/routers/navigator.dart';
import 'package:flutter_project_base/routers/routers.dart';
import 'package:flutter_project_base/services/home/models/char_data_model.dart';
import 'package:flutter_project_base/utilities/theme/text_styles.dart';
import 'package:intl/intl.dart';

import '../../../handlers/shared_handler.dart';
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

  String? userName;
  String filterType = 'day';
  String chartType = ChartsDataController.bloodSugarType;

  @override
  void initState() {
    getUserName();
    ChartsDataController.instance.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  Future<void> getUserName() async {
    userName = await SharedHandler.instance
        ?.getData(key: SharedKeys().user, valueType: ValueType.map)['name'];
  }

  String get format {
    if (filterType == 'day') return 'hh:mm a';
    return 'dd/MM';
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
                  // const Icon(Icons.menu),
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
                        data: ChartsDataController.instance
                            .items(chartType)
                            .map((e) {
                          if (filterType == 'day') {
                            if (DateTime.parse(e.key).day ==
                                DateTime.now().day) {
                              return CharDataModel(
                                  label: DateFormat(format)
                                      .format(DateTime.parse(e.key)),
                                  value: e.value);
                            } else {
                              return null;
                            }
                          } else {
                            return CharDataModel(
                                label: DateFormat(format)
                                    .format(DateTime.parse(e.key)),
                                value: e.value);
                          }
                        }).toList(),
                        max: ChartsDataController.instance
                                .items(chartType)
                                .isEmpty
                            ? 0
                            : ChartsDataController.instance
                                .items(chartType)
                                .map((e) => e.value)
                                .toList()
                                .reduce(max),
                        onSelectItem: (option) {
                          chartType = option.value;
                          setState(() {});
                          // ChartsDataController.instance.
                        },
                        onChangeChartFilter: (filter) {
                          filterType = filter.value;

                          setState(() {});
                        }),
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
}

class ChartsDataController extends ChangeNotifier {
  ChartsDataController._();

  static ChartsDataController instance = ChartsDataController._();
  static String bloodSugarType = 'bloodSugar';
  static String bloodPressureType = 'bloodPressure';
  static String weightType = 'weight';

  //DateFormat('dd-MM-yyyy').format(DateTime(202, 6, 12)), 90)
  List<MapEntry<String, int>> bloodSugar = <MapEntry<String, int>>[
    MapEntry(DateTime(202, 6, 12).toString(), 90),
    MapEntry(DateTime(2023, 6, 24).toString(), 666),
    MapEntry(DateTime(2023, 6, 20).toString(), 333),
    MapEntry(DateTime(2023, 6, 25).toString(), 33),
    MapEntry(DateTime(2023, 6, 25, 6).toString(), 40),
    MapEntry(DateTime(2023, 6, 25, 22).toString(), 80),
    MapEntry(DateTime(2023, 6, 25, 4).toString(), 120),
  ];
  List<MapEntry<String, int>> bloodPressure = <MapEntry<String, int>>[
    MapEntry(DateTime(2023, 6, 12).toString(), 80),
  ];
  List<MapEntry<String, int>> weight = <MapEntry<String, int>>[
    MapEntry(DateTime(2023, 3, 21).toString(), 70),
  ];

  void setNewItemTo(String itemType, MapEntry<String, int> data) {
    if (itemType == bloodSugarType) {
      bloodSugar.add(data);
    } else if (itemType == bloodPressureType) {
      bloodPressure.add(data);
    } else {
      weight.add(data);
    }
    notifyListeners();
  }

  List<MapEntry<String, int>> items(String itemType) {
    if (itemType == bloodSugarType) {
      return bloodSugar;
    } else if (itemType == bloodPressureType) {
      return bloodPressure;
    } else {
      return weight;
    }
  }
}
