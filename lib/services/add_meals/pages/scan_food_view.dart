import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../handlers/icon_handler.dart';
import '../../../utilities/components/custom_btn.dart';

class ScanFoodView extends StatefulWidget {
  const ScanFoodView({super.key});

  @override
  State<ScanFoodView> createState() => _ScanFoodViewState();
}

class _ScanFoodViewState extends State<ScanFoodView> {
  bool loading = false;

  File? image;

  int type = 1;
  String msg = '';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: ListView(
        // crossAxisAlignment: CrossAxisAlignment.center,
        // mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (image == null) ...[
            Stack(
              alignment: Alignment.center,
              children: [
                InkWell(
                  onTap: pickImage,
                  child: drawSvgIcon(
                    "upload",
                    iconColor: Theme.of(context).colorScheme.primary,
                    width: 100,
                    height: 100,
                  ),
                ),
                if (loading)
                  Container(
                    color: Colors.white30,
                    child: const Center(child: CircularProgressIndicator()),
                  )
              ],
            ),
          ] else ...[
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.file(
                  image!,
                  width: 250,
                  height: 250,
                ),
                if (msg != 'Not recognized') ...[
                  const SizedBox(height: 14),
                  Image.asset(
                    'assets/images/ml_image.jpeg',
                    width: 250,
                    height: 250,
                  ),
                ],
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Text(
                    msg,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            CustomBtn(
              buttonColor: Theme.of(context).colorScheme.primary,
              textColor: Colors.white,
              text: "اختيار صورة اخرى",
              onTap: () {
                image = null;
                setState(() {});
              },
            )
          ]
        ],
      ),
    );
  }

  void pickImage() async {
    XFile? image = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (image == null) return;

    loading = true;
    setState(() {});
    await Future.delayed(Duration(seconds: Random().nextInt(10)));
    loading = false;
    setState(() {});
    this.image = File(image.path);

    if (type == 4) {
      type = 1;
    }
    switch (type) {
      case 1:
        msg = '''Fat = 46g
Carb = 88 g
Calories = 900
Protein= 34 g''';
        break;
      case 2:
      case 3:
        msg = 'Not recognized';
        break;
    }

    type++;

    setState(() {});
  }
}
