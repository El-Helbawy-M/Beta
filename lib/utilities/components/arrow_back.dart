import 'package:flutter/material.dart';
import 'package:flutter_project_base/handlers/icon_handler.dart';
import 'package:flutter_project_base/handlers/localization_handler.dart';

class ArrowBack extends StatelessWidget {
  const ArrowBack({super.key, this.reverse = false, this.color});
  final bool reverse;
  final Color? color;
  @override
  Widget build(BuildContext context) {
    return currentLang() == "en"
        ? drawSvgIcon(
            reverse ? "arrow_right" : "arrow_left",
            iconColor: color ?? Colors.black,
          )
        : drawSvgIcon(
            reverse ? "arrow_left" : "arrow_right",
            iconColor: color ?? Colors.black,
          );
  }
}
