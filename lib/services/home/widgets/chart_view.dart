import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project_base/base/models/select_option.dart';
import 'package:flutter_project_base/base/widgets/fields/single_select_bottomsheet/single_select_input_field.dart';
import 'package:flutter_project_base/services/home/models/char_data_model.dart';
import 'package:flutter_project_base/utilities/theme/media.dart';

import '../../../base/widgets/fields/date_input_field.dart';
import '../../../utilities/theme/text_styles.dart';

class ChartWidget extends StatelessWidget {
  const ChartWidget({
    Key? key,
    required this.data,
  }) : super(key: key);
  final List<CharDataModel> data;
  final int max = 120;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: SizedBox(
        height: 400,
        width: MediaHelper.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: const DateInputField(
                    hintText: "اختر اليوم",
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: SingleSelectSheetField(
                    initialValue: SelectOption("A1C", "A1C"),
                    valueSet: [
                      SelectOption("weight", "الوزن"),
                      SelectOption("bloodPressure", "ضغط الدم"),
                      SelectOption("A1C", "A1C"),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(width: 1, color: Theme.of(context).dividerColor.withOpacity(.05)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey[300]!.withOpacity(.4),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                padding: const EdgeInsets.only(right: 16, top: 16, bottom: 16),
                child: BarChart(
                  BarChartData(
                      groupsSpace: 50,
                      borderData: FlBorderData(
                        show: true,
                        border: Border.symmetric(
                          horizontal: BorderSide(width: .5, color: Theme.of(context).dividerColor),
                        ),
                      ),
                      maxY: max.toDouble(),
                      gridData: FlGridData(
                        show: true,
                        drawHorizontalLine: true,
                        drawVerticalLine: false,
                        horizontalInterval: max.toDouble() / 12,
                        getDrawingHorizontalLine: (value) {
                          return FlLine(color: Theme.of(context).dividerColor, strokeWidth: .5);
                        },
                      ),
                      barGroups: List.generate(
                        data.length,
                        (index) => BarChartGroupData(
                          x: index,
                          barRods: [
                            BarChartRodData(
                              toY: data[index].value.toDouble(),
                              width: 3,
                              color: Theme.of(context).colorScheme.primary,
                              borderRadius: BorderRadius.circular(15),
                            )
                          ],
                        ),
                      ),
                      titlesData: FlTitlesData(
                        show: true,
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            interval: 1,
                            getTitlesWidget: (value, meta) => SideTitleWidget(
                              axisSide: meta.axisSide,
                              space: 4.0,
                              child: Text(
                                data[value.toInt()].label,
                                style: AppTextStyles.w600.copyWith(fontSize: 12, fontFamily: "txt", color: Colors.black),
                              ),
                            ),
                          ),
                        ),
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 50,
                            interval: max.toDouble() / 12,
                            getTitlesWidget: (value, meta) => SideTitleWidget(
                              axisSide: meta.axisSide,
                              space: 0,
                              child: Center(
                                child: Text(
                                  value.toInt().toString(),
                                  style: AppTextStyles.w600.copyWith(fontSize: 12, fontFamily: "txt", color: Colors.black),
                                ),
                              ),
                            ),
                          ),
                        ),
                        topTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        rightTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                      )),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
