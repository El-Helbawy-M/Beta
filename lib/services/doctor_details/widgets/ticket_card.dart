import 'package:flutter/material.dart';
import 'package:flutter_project_base/services/doctor_details/widgets/choose_session_type_sheet.dart';
import 'package:flutter_project_base/services/doctors/model/doctor_model.dart';
import 'package:intl/intl.dart';

import '../../../utilities/theme/text_styles.dart';

class TicketCard extends StatelessWidget {
  const TicketCard(
    this.appointmentModel,
    this.doctorDetails, {
    super.key,
  });
  final AppointmentModel appointmentModel;
  final DoctorModel? doctorDetails;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        InkWell(
          onTap: () {},
          child: Container(
            width: 100,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border:
                  Border.all(width: .5, color: Theme.of(context).dividerColor),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 24,
                  decoration: BoxDecoration(
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(10)),
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  child: Center(
                    child: Text(
                      "${DateFormat('E').format(appointmentModel.day!)} ${DateFormat('dd/MM').format(appointmentModel.day!)}",
                      style: AppTextStyles.w500
                          .copyWith(fontSize: 14, color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  (appointmentModel.intervals ?? []).first.split(' - ')[0],
                  style: AppTextStyles.w500.copyWith(fontSize: 18),
                ),
                Text(
                  "الي",
                  style: AppTextStyles.w500.copyWith(fontSize: 14),
                ),
                const SizedBox(height: 8),
                Text(
                  (appointmentModel.intervals ?? []).first.split(' - ')[1],
                  style: AppTextStyles.w500.copyWith(fontSize: 18),
                ),
                const SizedBox(height: 10),
                InkWell(
                  onTap: () {
                    showBottomSheet(
                        context: context,
                        constraints: const BoxConstraints(maxHeight: 280),
                        builder: (_) => ChooseSessionTypeSheet(doctorDetails),
                        shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(12),
                          topRight: Radius.circular(12),
                        )));
                  },
                  child: Container(
                    height: 24,
                    decoration: const BoxDecoration(
                      borderRadius:
                          BorderRadius.vertical(bottom: Radius.circular(10)),
                      color: Colors.green,
                    ),
                    child: Center(
                      child: Text(
                        "احجز",
                        style: AppTextStyles.w500
                            .copyWith(fontSize: 14, color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 16),
      ],
    );
  }
}
