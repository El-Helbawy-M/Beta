import 'package:flutter/material.dart';

void showSnackBar(
  BuildContext context,
  String? text, {
  SnackBarType type = SnackBarType.success,
}) {
  Color textColor = Colors.white;
  Color bgColor = Colors.green;
  switch (type) {
    case SnackBarType.success:
      bgColor = Colors.green;
      break;
    case SnackBarType.error:
      bgColor = Colors.red;
      break;
    case SnackBarType.warning:
      bgColor = Colors.deepOrange;
      break;
  }

  SnackBar snackBar = SnackBar(
    content: Text(
      text ?? 'حدث خطأ',
      style: TextStyle(color: textColor),
    ),
    backgroundColor: bgColor,
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

enum SnackBarType { success, error, warning }
