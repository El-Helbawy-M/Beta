import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project_base/services/doctors/model/doctor_model.dart';

import '../../../base/utils.dart';
import '../../../config/api_names.dart';
import '../../../network/network_handler.dart';
import '../../../utilities/theme/text_styles.dart';
import '../widgets/doctor_card.dart';

class DoctorsListPage extends StatefulWidget {
  const DoctorsListPage({super.key});

  @override
  State<DoctorsListPage> createState() => _DoctorsListPageState();
}

class _DoctorsListPageState extends State<DoctorsListPage> {
  List<DoctorModel> items = <DoctorModel>[];

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
        url: ApiNames.doctorList,
        withToken: true,
      );

      if (response == null) return;
      if (!mounted) return;

      for (var item in response.data['data']) {
        items.add(DoctorModel.fromJson(item));
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
    return SafeArea(
      child: Column(
        children: [
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              children: [
                Text(
                  "قائمة الاطباء",
                  style: AppTextStyles.w500.copyWith(fontSize: 18),
                ),
                const Spacer(),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Divider(
            height: 0,
            color: Theme.of(context).dividerColor,
          ),
          Expanded(
            child: loading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    itemBuilder: (_, int index) => DoctorCard(items[index]),
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemCount: items.length),
          ),
        ],
      ),
    );
  }
  //DoctorCard
}
