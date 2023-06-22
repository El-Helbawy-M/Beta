import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/blood_sugar_model.dart';

class DiabetesCard extends StatelessWidget {
  final BloodSugarItemModel item;
  const DiabetesCard(this.item, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border:
            Border.all(color: Theme.of(context).dividerColor.withOpacity(.05)),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).dividerColor.withOpacity(.02),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${item.sugarConcentration} ملى مول/ لتر',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  const SizedBox(height: 4),
                  //2/2/2023, 12:00 AM
                  Text(
                    DateFormat('dd/MM/yyyy, hh:mm a').format(item.date),
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: const Color(0xff1B72C0),
                ),
                child: Text(
                  item.measureDescription,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 16,
          ),
          Text(
            item.note,
            // style: TextStyle(
            //   color: Colors.grey,
            // ),
          ),
        ],
      ),
    );
  }
}
