// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

class SubtitleView extends StatelessWidget {
  const SubtitleView({super.key, this.text});
  final String? text;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(text ?? "No Title",
          style: Theme.of(context).textTheme.headline5!),
    );
  }
}
