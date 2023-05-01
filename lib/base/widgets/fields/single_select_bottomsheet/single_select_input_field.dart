import 'package:flutter/material.dart';
import 'package:flutter_project_base/base/widgets/fields/single_select_bottomsheet/single_select_bottomsheet.dart';
import '../../../../utilities/theme/text_styles.dart';
import '../../../models/select_option.dart';

class SingleSelectSheetField extends StatefulWidget {
  const SingleSelectSheetField({
    super.key,
    this.onChange,
    this.errorText,
    this.hintText,
    this.labelText,
    this.withBottomPadding = true,
    this.hasError = false,
    this.initialValue,
    required this.valueSet,
  });
  final String? hintText;
  final String? labelText;
  final String? errorText;
  final bool hasError;
  final Function(SelectOption)? onChange;
  final bool withBottomPadding;
  final List<SelectOption> valueSet;
  final SelectOption? initialValue;
  @override
  State<SingleSelectSheetField> createState() => _SingleSelectSheetFieldState();
}

class _SingleSelectSheetFieldState extends State<SingleSelectSheetField> {
  SelectOption? value;
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
          onTap: () async {
            await showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15)),
              ),
              builder: (context) => SingleSelectBottomSheet(
                valueSet: widget.valueSet,
                selecetValue: value,
                onSelect: (option) {
                  setState(() {
                    value = option;
                  });
                  widget.onChange?.call(option);
                },
              ),
            );
            // ignore: use_build_context_synchronously
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: Container(
            height: 50,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              border: value != null ? _mapBorder(borderColor: Theme.of(context).colorScheme.primary) : _mapBorder(borderColor: Colors.grey),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    value != null ? value!.label : widget.hintText ?? "",
                    style: AppTextStyles.w300.copyWith(color: value == null ? Theme.of(context).hintColor : null),
                  ),
                ),
                Icon(Icons.arrow_drop_down_circle_outlined, color: Theme.of(context).colorScheme.primary),
              ],
            ),
          ),
        ),
        if (widget.hasError) const SizedBox(height: 4),
        if (widget.hasError)
          Row(
            children: [
              const Icon(Icons.error_outline, color: Colors.red, size: 16),
              const SizedBox(width: 4),
              Text(widget.errorText ?? "Error", style: const TextStyle(color: Colors.red)),
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
