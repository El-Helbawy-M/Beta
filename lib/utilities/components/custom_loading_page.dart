import 'package:flutter/material.dart';

class CustomLoadingPage extends StatelessWidget {
  const CustomLoadingPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}
