import 'package:flutter/material.dart';
import 'package:flutter_project_base/utilities/components/custom_page_body.dart';

class EmptyPage extends StatelessWidget {
  const EmptyPage({super.key, this.body});
  final Widget? body;
  @override
  Widget build(BuildContext context) {
    return CustomPageBody(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            "assets/images/empty.png",
            fit: BoxFit.contain,
          ),
          body ??
              Text(
                "No data found",
                style: Theme.of(context).textTheme.headline6,
              ),
        ],
      ),
    );
  }
}
