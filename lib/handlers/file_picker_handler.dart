import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';

abstract class FilePickerHelper {
  static Future<File?> pickFile({String title = "Pick a file", FileType? type, List<String>? allowedExtensions, ValueChanged<File>? onSelected}) async {
    var result = await FilePicker.platform.pickFiles(type: type ?? FileType.custom, allowedExtensions: allowedExtensions, dialogTitle: title);
    if (result != null) {
      File file = File(result.files.first.path!);
      if (onSelected != null) onSelected(file);
    } else {
      return null;
    }
  }
}
