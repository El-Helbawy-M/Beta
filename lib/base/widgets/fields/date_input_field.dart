import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project_base/handlers/icon_handler.dart';
import 'package:flutter_project_base/routers/navigator.dart';
import 'package:flutter_project_base/utilities/components/custom_btn.dart';
import 'package:flutter_project_base/utilities/extensions/date_formatter.dart';
import 'package:flutter_project_base/utilities/theme/text_styles.dart';

class DateInputField extends StatefulWidget {
  const DateInputField({
    super.key,
    this.onChange,
    this.errorText,
    this.hintText,
    this.labelText,
    this.withBottomPadding = true,
    this.hasError = false,
    this.initialValue,
  });
  final String? hintText;
  final String? labelText;
  final String? errorText;
  final bool hasError;
  final Function(DateTime)? onChange;
  final bool withBottomPadding;
  final DateTime? initialValue;

  @override
  State<DateInputField> createState() => _DateInputFieldState();
}

class _DateInputFieldState extends State<DateInputField> {
  DateTime? value;

  @override
  void initState() {
    super.initState();
    value = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.labelText != null) Text(widget.labelText ?? ""),
        const SizedBox(height: 4),
        GestureDetector(
          onTap: () => showBottomSheetDatePicker(
            onChange: (value) {
              setState(() {
                this.value = value;
                widget.onChange?.call(value);
              });
            },
          ),
          child: Container(
            height: 46,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              border: _mapBorder(
                  borderColor: value != null
                      ? Theme.of(context).colorScheme.primary
                      : Colors.grey),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    value != null
                        ? value!.toYearMonthDayFormatte()
                        : widget.hintText ?? "",
                    style: AppTextStyles.w400
                        .copyWith(color: value == null ? Colors.grey : null),
                  ),
                ),
                drawSvgIcon("calendar",
                    iconColor: value == null
                        ? Theme.of(context).iconTheme.color
                        : Theme.of(context).colorScheme.primary),
              ],
            ),
          ),
        ),
        if (widget.hasError) const SizedBox(height: 8),
        if (widget.hasError)
          Row(
            children: [
              const Icon(Icons.error_outline, color: Colors.red, size: 16),
              const SizedBox(width: 4),
              Text(widget.errorText ?? "Error",
                  style: const TextStyle(color: Colors.red)),
            ],
          ),
        if (widget.withBottomPadding) const SizedBox(height: 16),
      ],
    );
  }

  Border _mapBorder({required Color borderColor}) {
    return Border.all(
      width: 1,
      color: borderColor,
    );
  }
}

//===============================================================

showBottomSheetDatePicker({required Function(DateTime) onChange}) {
  DateTime date = DateTime.now();
  return showModalBottomSheet(
    context: CustomNavigator.navigatorState.currentContext!,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) => Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Padding(
          padding: const EdgeInsets.all(24),
          child: InkWell(
            borderRadius: BorderRadius.circular(50),
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                    width: 1, color: Theme.of(context).colorScheme.primary),
              ),
              child: Center(
                child: Icon(Icons.close,
                    color: Theme.of(context).colorScheme.primary, size: 16),
              ),
            ),
          ),
        ),
        Expanded(
          child: ClipRRect(
            clipBehavior: Clip.hardEdge,
            borderRadius: BorderRadius.circular(20),
            child: CupertinoDatePicker(
              minimumDate: DateTime(1900),
              maximumDate: DateTime.now().add(const Duration(days: 1000)),
              initialDateTime: DateTime.now(),
              mode: CupertinoDatePickerMode.date,
              dateOrder: DatePickerDateOrder.ymd,
              onDateTimeChanged: (value) {
                date = value;
                onChange(value);
              },
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: CustomBtn(
            text: "Pick",
            height: 56,
            onTap: () {
              onChange(date);
              Navigator.pop(context);
            },
          ),
        ),
      ],
    ),
  );
}
