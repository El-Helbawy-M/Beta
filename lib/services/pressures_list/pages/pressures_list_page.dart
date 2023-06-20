import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project_base/services/pressures_list/models/blood_pressure_item_model.dart';
import 'package:flutter_project_base/services/pressures_list/widgets/pressure_card.dart';

import '../../../base/utils.dart';
import '../../../config/api_names.dart';
import '../../../network/network_handler.dart';
import '../../../routers/navigator.dart';
import '../../../routers/routers.dart';
import '../../../utilities/components/arrow_back.dart';
import '../../../utilities/components/custom_page_body.dart';
import '../../../utilities/theme/text_styles.dart';

class PressuresListPage extends StatefulWidget {
  const PressuresListPage({super.key});

  @override
  State<PressuresListPage> createState() => _PressuresListPageState();
}

class _PressuresListPageState extends State<PressuresListPage> {
  List<BloodPressureItemModel> items = <BloodPressureItemModel>[];

  bool loading = true;
  @override
  void initState() {
    getItems();
    super.initState();
  }

  void getItems() async {
    try {
      loading = true;
      setState(() {});

      print('herr');

      final Response? response = await NetworkHandler.instance?.get(
        url: ApiNames.bloodPressureList,
        withToken: true,
      );

      if (response == null) return;
      if (!mounted) return;

      for (var item in response.data['data']) {
        items.add(BloodPressureItemModel.fromJson(item));
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
          "قياسات الضغط",
          style: AppTextStyles.w500.copyWith(fontSize: 18),
        ),
      ),
      body: loading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              itemBuilder: (_, int index) => PressureCard(items[index]),
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemCount: items.length),
      //PressureCard
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result =
              await Navigator.of(context).pushNamed(Routes.addPressure);

          if (result == null) return;

          getItems();
        },
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
