import 'package:flutter/material.dart';

class FoodInfo extends StatelessWidget {
  const FoodInfo({
    super.key,
    required this.label,
    required this.value,
    this.labelColor,
    this.valueColor,
    this.borderRadius,
  });
  final String label, value;
  final Color? valueColor, labelColor;
  final BorderRadius? borderRadius;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: borderRadius,
          color: Theme.of(context).colorScheme.primaryContainer,
        ),
        height: 32,
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: Theme.of(context).textTheme.bodyText1!.copyWith(color: labelColor),
            ),
            Text(value, style: Theme.of(context).textTheme.bodyText2!.copyWith(color: valueColor)),
          ],
        ),
      ),
    );
  }
}
