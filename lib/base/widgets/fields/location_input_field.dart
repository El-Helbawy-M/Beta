import 'package:flutter/material.dart';
import 'package:flutter_project_base/base/widgets/fields/single_select_bottomsheet/single_select_bottomsheet.dart';
import 'package:flutter_project_base/handlers/icon_handler.dart';
import '../../../../utilities/theme/text_styles.dart';

class LocationInputField extends StatefulWidget {
  const LocationInputField({
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
  final Function(LocationData)? onChange;
  final bool withBottomPadding;
  final LocationData? initialValue;
  @override
  State<LocationInputField> createState() => _LocationInputFieldState();
}

class _LocationInputFieldState extends State<LocationInputField> {
  LocationData? value;
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
                    value != null ? (value!.country ?? "") + (value!.city ?? "") : widget.hintText ?? "Enter Location",
                    style: AppTextStyles.w300.copyWith(color: value == null ? Theme.of(context).hintColor : null),
                  ),
                ),
                drawSvgIcon("location", iconColor: Theme.of(context).colorScheme.primary),
              ],
            ),
          ),
        ),
        if (widget.hasError) const Text("Error", style: TextStyle(color: Colors.red)),
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

class LocationData {
  num? lat, lng;
  String? city;
  String? country;

  LocationData({this.lng, this.lat, this.city, this.country});
}
