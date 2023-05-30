// ignore_for_file: deprecated_member_use

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_project_base/handlers/image_picker_handler.dart';
import 'package:flutter_project_base/utilities/components/custom_btn.dart';
import 'package:flutter_project_base/utilities/theme/media.dart';

import '../../../handlers/icon_handler.dart';

class ImageInputField extends StatefulWidget {
  const ImageInputField({
    super.key,
    this.onChange,
    this.errorText,
    this.initialValue,
    this.labelText,
    this.withBottomPadding = true,
    this.hasError = false,
  });
  final String? labelText;
  final String? errorText;
  final bool hasError;
  final File? initialValue;
  final Function(File?)? onChange;
  final bool withBottomPadding;

  @override
  State<ImageInputField> createState() => _ImageInputFieldState();
}

class _ImageInputFieldState extends State<ImageInputField> {
  File? _image;

  @override
  void initState() {
    super.initState();
    _image = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.labelText ?? ""),
        const SizedBox(height: 8),
        InkWell(
          onTap: _image == null
              ? () async {
                  File? file = await ImagePickerHandler().pickGalleryImage();
                  if (file != null) {
                    setState(() {
                      _image = file;
                    });
                    widget.onChange?.call(_image);
                  }
                }
              : null,
          borderRadius: BorderRadius.circular(8),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            height: _image == null ? 175 : 120,
            width: MediaHelper.width,
            padding: EdgeInsets.all(_image == null ? 48 : 8),
            decoration: BoxDecoration(
              border: Border.all(
                  width: 1, color: Theme.of(context).hintColor.withOpacity(.5)),
              borderRadius: BorderRadius.circular(8),
            ),
            child: _image == null
                ? drawSvgIcon("image",
                    iconColor: Theme.of(context).hintColor.withOpacity(.5))
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              image: DecorationImage(
                                  image: FileImage(_image!), fit: BoxFit.cover),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              _image!.path.split("/").last,
                              style: Theme.of(context).textTheme.bodyText1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: CustomBtn(
                              text: "Remove",
                              height: 36,
                              buttonColor: Colors.transparent,
                              borderColor:
                                  Theme.of(context).colorScheme.primary,
                              textColor: Theme.of(context).colorScheme.primary,
                              onTap: () {
                                setState(() {
                                  _image = null;
                                });
                                widget.onChange?.call(_image);
                              },
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: CustomBtn(
                              text: "Change",
                              height: 36,
                              onTap: () async {
                                File? file = await ImagePickerHandler()
                                    .pickGalleryImage();
                                if (file != null) {
                                  setState(() {
                                    _image = file;
                                  });
                                  widget.onChange?.call(_image);
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
          ),
        ),
        const SizedBox(width: 16),
        if (widget.withBottomPadding) const SizedBox(height: 16),
      ],
    );
  }
}
