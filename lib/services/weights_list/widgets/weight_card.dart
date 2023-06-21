import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/weight_model.dart';

class WeightCard extends StatelessWidget {
  final WeightModel item;
  const WeightCard(this.item, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(6),
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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '${item.weight} كجم',
            style: const TextStyle(
                fontWeight: FontWeight.bold, fontSize: 15),
          ),
          if(item.date != null) ...[
            Text(
              DateFormat('dd MMM yyyy, hh:mm a').format(item.date!),
              textAlign: TextAlign.start,
              style: const TextStyle(color: Colors.grey,fontSize: 10),
            ),

          ]

        ],
      ),
    );
  }
}
