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
import '../models/weight_model.dart';
import '../widgets/weight_card.dart';

class WeightListPage extends StatefulWidget {
  const WeightListPage({super.key});

  @override
  State<WeightListPage> createState() => _WeightListPageState();
}

class _WeightListPageState extends State<WeightListPage> {
  List<WeightModel> items = <WeightModel>[];

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
        url: ApiNames.weightList,
        withToken: true,
      );

      items.clear();
      if (response == null) return;
      if (!mounted) return;

      for (var item in response.data['data']) {
        items.add(WeightModel.fromJson(item));
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
          "متابعة الوزن",
          style: AppTextStyles.w500.copyWith(fontSize: 18),
        ),
      ),
      body: loading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 15,
                crossAxisSpacing: 15,
                childAspectRatio: 1,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              itemBuilder: (_, int index) => WeightCard(items[index]),
              itemCount: items.length,
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result =
              await Navigator.of(context).pushNamed(Routes.addWeight);

          if (result == null) return;

          getItems();
        },
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
