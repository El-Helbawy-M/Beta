import 'package:flutter/material.dart';

class SliverBody extends StatelessWidget {
  const SliverBody({
    Key? key,
    this.title,
    this.padding,
    required this.child,
    this.flexibleSpace,
    this.backgroundColor,
    this.collapsedHeight,
    this.expandedHeight,
    this.bottom,
    this.actions,
  }) : super(key: key);
  final String? title;
  final Widget child;
  final Widget? flexibleSpace;
  final double? collapsedHeight, expandedHeight;
  final Color? backgroundColor;
  final EdgeInsets? padding;
  final PreferredSizeWidget? bottom;
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          snap: true,
          pinned: true,
          floating: true,
          backgroundColor: backgroundColor,
          flexibleSpace: FlexibleSpaceBar(
            background: Padding(
              padding: padding ?? const EdgeInsets.fromLTRB(0, 0, 0, 0),
              child: flexibleSpace,
            ),
          ),
          actions: actions,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(20),
            bottomLeft: Radius.circular(20),
          )),
          bottom: bottom,
          centerTitle: false,
          title: title == null
              ? null
              : Text(
                  title!,
                ),
          toolbarHeight: 0,
          collapsedHeight: collapsedHeight,
          expandedHeight: expandedHeight,
        ),
        child
      ],
    );
  }
}
