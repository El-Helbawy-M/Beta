import 'package:flutter/material.dart';

class PricingItemWidget extends StatefulWidget {
  const PricingItemWidget(this.data, {Key? key}) : super(key: key);
  final MapEntry<TextEditingController, TextEditingController> data;

  @override
  State<PricingItemWidget> createState() => _PricingItemWidgetState();
}

class _PricingItemWidgetState extends State<PricingItemWidget> {
  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Container(
      height: 60,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(12)),
        border: Border.all(
          color: theme.colorScheme.primary,
        ),
      ),
      child: Row(
        children: [
          Expanded(
              child: Row(
            children: [
              SizedBox(
                width: 140,
                child: TextFormField(
                  textAlign: TextAlign.center,
                  controller: widget.data.key,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(hintText: 'عدد الجلسات'),
                  onChanged: (_) {
                    setState(() {});
                  },
                ),
              ),
              Expanded(
                child: Text(
                  numberOfSessions(widget.data.key.text) > 10
                      ? 'جلسة'
                      : 'جلسات',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
            ],
          )),
          SizedBox(
            width: 80,
            child: TextFormField(
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                hintText: 'السعر',
              ),
            ),
          ),
        ],
      ),
    );
  }

  int numberOfSessions(String str) {
    int number = int.tryParse(str) ?? 0;
    return number;
  }
}
