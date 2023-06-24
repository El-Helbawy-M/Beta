import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project_base/base/utils.dart';
import 'package:flutter_project_base/services/chats/model/chat_model.dart';
import 'package:flutter_project_base/services/doctor_details/widgets/payment.dart';

import '../../../base/pages/base_page.dart';
import '../../../handlers/shared_handler.dart';
import '../../doctors/model/doctor_model.dart';

class ChooseSessionTypeSheet extends StatefulWidget {
  const ChooseSessionTypeSheet(this.doctorDetails, {super.key});
  final DoctorModel? doctorDetails;

  @override
  State<ChooseSessionTypeSheet> createState() => _ChooseSessionTypeSheetState();
}

class _ChooseSessionTypeSheetState extends State<ChooseSessionTypeSheet> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 22, horizontal: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'متابعة مع الدكتور عن طريق ..',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              TextButton(
                onPressed: Navigator.of(context).pop,
                child: const Text('إلغاء'),
              )
            ],
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.chat),
            title: const Text('المحادثه عن طريق الرسائل'),
            onTap: () async {
              final result = await Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const PaymentView()),
              );

              if (result == null) return;

              if (result) {
                print('ksksksk');
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

                // DocumentSnapshot doc = await FirebaseFirestore.instance
                //     .collection('Chats')
                //     .doc('${widget.doctorDetails}-${user['id']}')
                //     .get();
                // ChatModel chatModel = ChatModel.fromFireStore(doc);
                if (!mounted) return;
                Navigator.pop(context);
                Navigator.pop(context);
                ChangeBottomNavigationController.instance
                    .changeBottomNavigation(1);
                // Navigator.of(context).pushNamed(Routes.chatRoom, arguments: [
                //   user['id'],
                //   chatModel,
                // ]);
              }
            },
          ),
          ListTile(
            leading: const Icon(Icons.access_time_outlined),
            title: const Text('زيارة'),
            onTap: () {
              Navigator.pop(context);
              showSnackBar(context, 'تم حجز الميعاد ستصلك رسالة بالتفاصيل');
            },
          ),
        ],
      ),
    );
  }
}
