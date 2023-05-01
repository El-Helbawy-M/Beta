import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

Widget drawSvgIcon(String iconName, {double? width, double? height, Color? iconColor}) => SizedBox(
      width: width ?? 24,
      height: height ?? 24,
      child: SvgPicture.asset(
        "assets/icons/svg/$iconName.svg",
        color: iconColor,
      ),
    );
