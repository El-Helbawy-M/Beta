import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_project_base/handlers/icon_handler.dart';
import 'package:flutter_project_base/utilities/theme/text_styles.dart';

class TextInputField extends StatefulWidget {
  const TextInputField({
    super.key,
    this.onChange,
    this.controller,
    this.errorText,
    this.hintText,
    this.initialValue,
    this.labelText,
    this.withBottomPadding = true,
    this.hasError = false,
    this.keyboardType,
  });
  final String? hintText;
  final String? labelText;
  final String? errorText;
  final bool hasError;
  final String? initialValue;
  final TextEditingController? controller;
  final Function(String)? onChange;
  final bool withBottomPadding;
  final TextInputType? keyboardType;
  @override
  State<TextInputField> createState() => _TextInputFieldState();
}

class _TextInputFieldState extends State<TextInputField> {
  bool showText = true;

  _mapSuffixIcon() {
    if (widget.keyboardType == null) {
      return null;
    } else if (widget.keyboardType == TextInputType.phone) {
      return Padding(
        padding: const EdgeInsets.only(left: 12, right: 16, top: 12, bottom: 12),
        child: drawSvgIcon("phone", iconColor: Theme.of(context).colorScheme.primary),
      );
    } else if (widget.keyboardType == TextInputType.visiblePassword) {
      return GestureDetector(
        child: Padding(
          padding: const EdgeInsets.only(left: 12, right: 16, top: 12, bottom: 12),
          child: drawSvgIcon(showText ? "eye_hide" : "eye_show"),
        ),
        onTap: () {
          setState(() {
            showText = !showText;
          });
        },
      );
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.labelText != null) Text(widget.labelText ?? ""),
        const SizedBox(height: 4),
        SizedBox(
          height: 56,
          child: TextFormField(
            controller: widget.controller,
            initialValue: widget.controller != null ? null : widget.initialValue,
            onChanged: widget.onChange,
            keyboardType: widget.keyboardType ?? TextInputType.text,
            style: AppTextStyles.w300,
            obscureText: !showText,
            decoration: InputDecoration(
              hintText: widget.hintText,
              hintStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w100),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              suffixIcon: _mapSuffixIcon(),
              enabledBorder: _mapBorder(borderColor: Colors.grey),
              focusedBorder: _mapBorder(borderColor: Theme.of(context).colorScheme.primary),
              errorBorder: _mapBorder(borderColor: Colors.red),
            ),
          ),
        ),
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
