import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_project_base/handlers/icon_handler.dart';
import 'package:flutter_project_base/utilities/theme/text_styles.dart';

class TextDescrabtionInputField extends StatefulWidget {
  const TextDescrabtionInputField({
    super.key,
    this.onChange,
    this.controller,
    this.errorText,
    this.hintText,
    this.initialValue,
    this.labelText,
    this.withBottomPadding = true,
    this.hasError = false,
  });
  final String? hintText;
  final String? labelText;
  final String? errorText;
  final bool hasError;
  final String? initialValue;
  final TextEditingController? controller;
  final Function(String)? onChange;
  final bool withBottomPadding;
  @override
  State<TextDescrabtionInputField> createState() => _TextDescrabtionInputFieldState();
}

class _TextDescrabtionInputFieldState extends State<TextDescrabtionInputField> {
  bool showText = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.labelText != null) Text(widget.labelText ?? ""),
        const SizedBox(height: 4),
        SizedBox(
          height: 150,
          child: TextFormField(
            expands: true,
            maxLines: null,
            minLines: null,
            textAlignVertical: TextAlignVertical.top,
            controller: widget.controller,
            initialValue: widget.controller != null ? null : widget.initialValue,
            onChanged: widget.onChange,
            keyboardType: TextInputType.multiline,
            style: AppTextStyles.w300,
            obscureText: !showText,
            decoration: InputDecoration(
              hintText: widget.hintText,
              hintStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w100),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              enabledBorder: _mapBorder(borderColor: Colors.grey),
              focusedBorder: _mapBorder(borderColor: Theme.of(context).colorScheme.primary),
              errorBorder: _mapBorder(borderColor: Colors.red),
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

  OutlineInputBorder _mapBorder({required Color borderColor}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: borderColor),
    );
  }
}
