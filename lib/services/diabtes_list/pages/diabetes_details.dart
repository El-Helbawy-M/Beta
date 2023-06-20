import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../../base/utils.dart';
import '../../../config/api_names.dart';
import '../../../network/network_handler.dart';
import '../../../routers/navigator.dart';
import '../../../routers/routers.dart';
import '../../../utilities/components/arrow_back.dart';
import '../../../utilities/components/custom_page_body.dart';
import '../../../utilities/theme/text_styles.dart';
import '../models/blood_sugar_model.dart';
import '../widgets/diaebetes_card.dart';

class DiabetesListPage extends StatefulWidget {
  const DiabetesListPage({super.key});

  @override
  State<DiabetesListPage> createState() => _DiabetesListPageState();
}

class _DiabetesListPageState extends State<DiabetesListPage> {
  List<BloodSugarItemModel> items = <BloodSugarItemModel>[];

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

      final Response? response = await NetworkHandler.instance?.get(
        url: ApiNames.bloodSugarList,
        withToken: true,
      );

      if (response == null) return;
      if (!mounted) return;

      for (var item in response.data['data']) {
        items.add(BloodSugarItemModel.fromJson(item));
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
          onTap: CustomNavigator.pop,
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
          "قياسات سكر الدم",
          style: AppTextStyles.w500.copyWith(fontSize: 18),
        ),
      ),
      body: loading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              itemBuilder: (_, int index) => DiabetesCard(items[index]),
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemCount: items.length),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result =
              await Navigator.of(context).pushNamed(Routes.addNewDiabte);

          if (result == null) return;

          getItems();
        },
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
