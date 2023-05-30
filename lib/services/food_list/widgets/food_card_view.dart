import 'package:flutter/material.dart';

import 'food_info_view.dart';

class FoodCard extends StatefulWidget {
  const FoodCard({
    super.key,
    this.infos = const [],
    required this.name,
    required this.calories,
  });
  final List<FoodInfo> infos;
  final String name;
  final num calories;

  @override
  State<FoodCard> createState() => _FoodCardState();
}

class _FoodCardState extends State<FoodCard> {
  bool isColapsed = false;
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      height: (isColapsed ? 0 : widget.infos.length * 40) + 80,
      margin: const EdgeInsets.only(bottom: 16),
      duration: const Duration(milliseconds: 500),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(width: 1, color: Theme.of(context).colorScheme.primaryContainer),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.name, style: Theme.of(context).textTheme.headline5),
                    const SizedBox(height: 8),
                    Text(widget.calories.toString() + "  سعر حراري", style: Theme.of(context).textTheme.subtitle1!.copyWith(color: Theme.of(context).colorScheme.primary)),
                  ],
                ),
                GestureDetector(
                  onTap: () => setState(() => isColapsed = !isColapsed),
                  child: Container(
                    height: 32,
                    width: 32,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Theme.of(context).colorScheme.primaryContainer,
                    ),
                    child: Center(
                      child: AnimatedRotation(
                        duration: const Duration(milliseconds: 300),
                        turns: isColapsed ? 0.5 : 0,
                        child: Icon(
                          Icons.keyboard_arrow_up,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          AnimatedCrossFade(
            firstChild: Column(children: widget.infos),
            secondChild: const SizedBox(),
            crossFadeState: isColapsed ? CrossFadeState.showSecond : CrossFadeState.showFirst,
            sizeCurve: Curves.linear,
            duration: const Duration(milliseconds: 500),
          ),
        ],
      ),
    );
  }
}
