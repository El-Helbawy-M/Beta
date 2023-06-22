import 'package:flutter/material.dart';
import 'package:flutter_project_base/handlers/icon_handler.dart';
import 'package:flutter_project_base/utilities/theme/text_styles.dart';
import '../../../../routers/navigator.dart';
import '../../../models/select_option.dart';
import '../../check_box_view.dart';

class SingleSelectBottomSheet extends StatefulWidget {
  const SingleSelectBottomSheet({
    Key? key,
    required this.onSelect,
    required this.valueSet,
    this.selecetValue,
  }) : super(key: key);
  final Function(SelectOption option) onSelect;
  final List<SelectOption> valueSet;
  final SelectOption? selecetValue;

  @override
  State<SingleSelectBottomSheet> createState() =>
      _SingleSelectBottomSheetState();
}

class _SingleSelectBottomSheetState extends State<SingleSelectBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        height: 340,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15), topRight: Radius.circular(15)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 50,
              height: 4,
              margin: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                color: Theme.of(context).hintColor.withOpacity(.5),
                borderRadius: const BorderRadius.all(Radius.circular(2)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                children: [
                  GestureDetector(
                      onTap: () => CustomNavigator.pop(),
                      child: drawSvgIcon("close_circle",
                          iconColor: Theme.of(context).colorScheme.primary)),
                  Expanded(
                    child: Center(
                      child: Text(
                        "Select Category",
                        style: AppTextStyles.w600.copyWith(
                            fontSize: 18,
                            color: Theme.of(context).colorScheme.primary),
                      ),
                    ),
                  ),
                  const SizedBox(width: 24),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Column(
                children: List.generate(
                  widget.valueSet.length,
                  (index) => ListTile(
                    onTap: () {
                      widget.onSelect(widget.valueSet[index]);
                      CustomNavigator.pop();
                    },
                    minLeadingWidth: 12,
                    dense: true,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 24),
                    leading: CheckBoxView(
                      isChecked: widget.selecetValue == null
                          ? widget.valueSet[index].isSelected
                          : widget.selecetValue!.value ==
                              widget.valueSet[index].value,
                    ),
                    title: Text(
                      widget.valueSet[index].label,
                      style: AppTextStyles.w600
                          .copyWith(fontSize: 18, color: Colors.black),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
