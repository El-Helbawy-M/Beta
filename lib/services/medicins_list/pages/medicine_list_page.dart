import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project_base/handlers/icon_handler.dart';
import 'package:flutter_project_base/services/medicins_list/models/medicine_model.dart';
import 'package:flutter_project_base/utilities/extensions/date_formatter.dart';

import '../../../base/utils.dart';
import '../../../base/widgets/fields/date_input_field.dart';
import '../../../routers/navigator.dart';
import '../../../routers/routers.dart';
import '../../../utilities/components/arrow_back.dart';
import '../../../utilities/components/custom_page_body.dart';
import '../../../utilities/theme/text_styles.dart';
import '../widgets/medicine_card.dart';

class MedicinesListPage extends StatefulWidget {
  const MedicinesListPage({super.key});

  @override
  State<MedicinesListPage> createState() => _MedicinesListPageState();
}

class _MedicinesListPageState extends State<MedicinesListPage> {
  List<MedicineModel> items = <MedicineModel>[];

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

      await Future.delayed(const Duration(seconds: 2));
      items.add(MedicineModel(
        date: DateTime.now(),
        time: '03:40:00',
        name: 'انسلوين',
        dose: '2',
        insulinType: '1',
      ));
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
          "الأدوية",
          style: AppTextStyles.w500.copyWith(fontSize: 18),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            InkWell(
              onTap: () => showBottomSheetDatePicker(
                onChange: (value) {},
              ),
              child: AnimatedContainer(
                height: 56,
                duration: const Duration(milliseconds: 300),
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  children: [
                    drawSvgIcon("calendar",
                        iconColor: Theme.of(context).colorScheme.primary),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        DateTime.now().toYearMonthDayFormatte(),
                        style: AppTextStyles.w500.copyWith(fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Divider(height: 0),
            Expanded(
                child: loading
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        itemBuilder: (_, int index) =>
                            MedicineCard(items[index]),
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                        itemCount: items.length)),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result =
              await Navigator.of(context).pushNamed(Routes.addMedicines);

          if (result == null) return;

          if (result is MedicineModel) {
            items.add(result);
            setState(() {});
          }
        },
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
