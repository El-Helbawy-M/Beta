// ignore_for_file: deprecated_member_use

import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_project_base/handlers/image_picker_handler.dart';

import '../../../handlers/icon_handler.dart';

class ImagesListInputField extends StatefulWidget {
  const ImagesListInputField({
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
  final List<File>? initialValue;
  final Function(List<File>?)? onChange;
  final bool withBottomPadding;

  @override
  State<ImagesListInputField> createState() => _ImagesListInputFieldState();
}

class _ImagesListInputFieldState extends State<ImagesListInputField> {
  List<File> _images = [];
  ScrollController controller = ScrollController();

  @override
  void initState() {
    super.initState();
    _images = widget.initialValue ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Text(widget.labelText ?? ""),
        ),
        const SizedBox(height: 8),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          controller: controller,
          physics: const BouncingScrollPhysics(),
          child: Row(
            children: [
              const SizedBox(width: 24),
              ...List.generate(
                _images.length,
                (index) => Row(
                  children: [
                    Stack(
                      children: [
                        ImageFrame(image: _images[index]),
                        Positioned(
                          top: 0,
                          right: 0,
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                _images.removeAt(index);
                                widget.onChange?.call(_images);
                              });
                            },
                            child: Container(
                              height: 24,
                              width: 48,
                              decoration: BoxDecoration(
                                color: Theme.of(context).errorColor,
                                borderRadius: const BorderRadius.only(
                                    topRight: Radius.circular(8),
                                    bottomLeft: Radius.circular(8)),
                              ),
                              child: const Icon(
                                Icons.close,
                                color: Colors.white,
                                size: 16,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 16),
                  ],
                ),
              ),
              InkWell(
                onTap: () async {
                  File? file = await ImagePickerHandler().pickGalleryImage();
                  if (file != null) {
                    setState(() {
                      log(controller.offset.toString());
                      _images.add(file);
                      controller.animateTo(
                          controller.position.maxScrollExtent + 191,
                          duration: const Duration(milliseconds: 600),
                          curve: Curves.easeInOut);
                    });
                    widget.onChange?.call(_images);
                  }
                },
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  height: 250,
                  width: 175,
                  padding: const EdgeInsets.all(48),
                  decoration: BoxDecoration(
                    border: Border.all(
                        width: 1,
                        color: Theme.of(context).hintColor.withOpacity(.5)),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: drawSvgIcon("image",
                      iconColor: Theme.of(context).hintColor.withOpacity(.5)),
                ),
              ),
              const SizedBox(width: 16)
            ],
          ),
        ),
        if (widget.withBottomPadding) const SizedBox(height: 16),
      ],
    );
  }
}

class ImageFrame extends StatelessWidget {
  const ImageFrame({
    super.key,
    required this.image,
  });
  final File image;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250,
      width: 175,
      padding: const EdgeInsets.all(48),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        image: DecorationImage(image: FileImage(image), fit: BoxFit.cover),
      ),
    );
  }
}
