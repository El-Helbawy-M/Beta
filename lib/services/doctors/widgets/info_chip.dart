import 'package:flutter/material.dart';

class InfoChip extends StatelessWidget {
  const InfoChip({
    super.key,
    required this.child,
  });
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 34,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: const Color(0xffF7F8F8)),
      child: child,
    );
  }
}
