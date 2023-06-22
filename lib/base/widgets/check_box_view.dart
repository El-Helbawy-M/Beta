import 'package:flutter/material.dart';

class CheckBoxView extends StatelessWidget {
  const CheckBoxView({
    super.key,
    required this.isChecked,
  });
  final bool isChecked;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 16,
      height: 16,
      decoration: BoxDecoration(
        color: isChecked
            ? Theme.of(context).colorScheme.primary
            : Colors.transparent,
        borderRadius: const BorderRadius.all(Radius.circular(4)),
        border: Border.all(
            color: isChecked
                ? Colors.transparent
                : Theme.of(context).colorScheme.secondary),
      ),
    );
  }
}
