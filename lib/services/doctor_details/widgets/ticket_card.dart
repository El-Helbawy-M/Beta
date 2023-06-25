import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project_base/services/doctor_details/widgets/payment.dart';
import 'package:flutter_project_base/services/doctors/model/doctor_model.dart';
import 'package:intl/intl.dart';

import '../../../base/pages/base_page.dart';
import '../../../handlers/shared_handler.dart';
import '../../../utilities/theme/text_styles.dart';
import '../../chats/model/chat_model.dart';

class TicketCard extends StatefulWidget {
  const TicketCard(
    this.appointmentModel,
    this.doctorDetails, {
    super.key,
    required this.onChooseItem,
  });
  final AppointmentModel appointmentModel;
  final DoctorModel? doctorDetails;
  final void Function(bool) onChooseItem;

  @override
  State<TicketCard> createState() => _TicketCardState();
}

class _TicketCardState extends State<TicketCard> {
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
                      "${DateFormat('E').format(widget.appointmentModel.day!)} ${DateFormat('dd/MM').format(widget.appointmentModel.day!)}",
                      style: AppTextStyles.w500
                          .copyWith(fontSize: 14, color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  (widget.appointmentModel.intervals ?? [])
                      .first
                      .split(' - ')[0],
                  style: AppTextStyles.w500.copyWith(fontSize: 18),
                ),
                Text(
                  "الي",
                  style: AppTextStyles.w500.copyWith(fontSize: 14),
                ),
                const SizedBox(height: 8),
                Text(
                  (widget.appointmentModel.intervals ?? [])
                      .first
                      .split(' - ')[1],
                  style: AppTextStyles.w500.copyWith(fontSize: 18),
                ),
                const SizedBox(height: 10),
                InkWell(
                  onTap: () async {
                    final result = await Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const PaymentView()),
                    );

                    if (result == null) return;

                    if (result) {
                      widget.onChooseItem(true);
                      final user = (await SharedHandler.instance?.getData(
                          key: SharedKeys().user,
                          valueType: ValueType.map) as Map<String, dynamic>);
                      await FirebaseFirestore.instance
                          .collection('Chats')
                          .doc('${widget.doctorDetails!.id}-${user['id']}')
                          .set({
                        doctorIdKey: widget.doctorDetails!.id,
                        doctorNameKey: widget.doctorDetails!.name,
                        doctorPhotoKey: '',
                        lastMessageKey: '',
                        lastMessageDateKey: '',
                        lastMessageSenderIdKey: 0,
                        patentIdKey: user['id'],
                        patentNameKey: user['name'],
                        patentPhotoKey: '',
                        'seenLastMessage': true,
                      });

                      widget.onChooseItem(false);
                      if (!mounted) return;
                      Navigator.pop(context);
                      ChangeBottomNavigationController.instance
                          .changeBottomNavigation(1);
                    }
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
