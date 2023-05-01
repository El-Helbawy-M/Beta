import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class TextInputField extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (labelText != null) Text(labelText ?? ""),
        const SizedBox(height: 4),
        SizedBox(
          height: 56,
          child: TextFormField(
            controller: controller,
            initialValue: controller != null ? null : initialValue,
            onChanged: onChange,
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: const TextStyle(color: Colors.grey),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              enabledBorder: _mapBorder(borderColor: Colors.grey),
              focusedBorder: _mapBorder(borderColor: Colors.blue),
              errorBorder: _mapBorder(borderColor: Colors.red),
            ),
          ),
        ),
        if (hasError) const Text("Error", style: TextStyle(color: Colors.red)),
        if (withBottomPadding) const SizedBox(height: 16),
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
