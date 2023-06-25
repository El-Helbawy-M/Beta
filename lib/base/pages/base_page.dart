import 'dart:async';
import 'dart:math';

import 'package:draggable_widget/draggable_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project_base/handlers/icon_handler.dart';
import 'package:flutter_project_base/routers/routers.dart';
import 'package:flutter_project_base/services/home/pages/home_page.dart';

import '../../services/chats/pages/chats_list_page.dart';
import '../../services/doctors/pages/doctors_list_page.dart';
import '../../services/food_list/pages/food_list_page.dart';
import '../../services/profile/pages/profile_page.dart';

class BasePage extends StatefulWidget {
  const BasePage({super.key});

  @override
  State<BasePage> createState() => _BasePageState();
}

class _BasePageState extends State<BasePage> {
  int _index = 2;
  String _mapIcon(int index, String icon) {
    if (_index == index) return "base_icons/${icon}_bold";
    return "base_icons/${icon}_outline";
  }

  Color _mapColor(int index, BuildContext context) {
    if (_index == index) {
      return Theme.of(context).bottomNavigationBarTheme.selectedItemColor!;
    }
    return Theme.of(context).bottomNavigationBarTheme.unselectedItemColor!;
  }

  List<Widget> screen = [
    const ProfilePage(),
    const ChatListPage(),
    HomePage(),
    const DoctorsListPage(),
    const FoodListPage(),
  ];

  @override
  void initState() {
    ChangeBottomNavigationController.instance.addListener(() {
      _index = ChangeBottomNavigationController.instance.pageIndex;
      setState(() {});
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        type: BottomNavigationBarType.shifting,
        showSelectedLabels: false,
        onTap: (value) => setState(() {
          _index = value;
        }),
        currentIndex: _index,
        items: [
          BottomNavigationBarItem(
              icon: ButtonContainer(
                  isSelected: _index == 0,
                  child: drawSvgIcon(_mapIcon(0, "profile"),
                      iconColor: _mapColor(0, context))),
              label: "",
              backgroundColor: Theme.of(context).colorScheme.primary),
          BottomNavigationBarItem(
              icon: ButtonContainer(
                  isSelected: _index == 1,
                  child: drawSvgIcon(_mapIcon(1, "chat"),
                      iconColor: _mapColor(1, context))),
              label: "",
              backgroundColor: Theme.of(context).colorScheme.primary),
          BottomNavigationBarItem(
              icon: ButtonContainer(
                  isSelected: _index == 2,
                  child: drawSvgIcon(_mapIcon(2, "home"),
                      iconColor: _mapColor(2, context))),
              label: "",
              backgroundColor: Theme.of(context).colorScheme.primary),
          BottomNavigationBarItem(
              icon: ButtonContainer(
                  isSelected: _index == 3,
                  child: drawSvgIcon(_mapIcon(3, "user"),
                      iconColor: _mapColor(3, context))),
              label: "",
              backgroundColor: Theme.of(context).colorScheme.primary),
          BottomNavigationBarItem(
              icon: ButtonContainer(
                  isSelected: _index == 4,
                  child: drawSvgIcon(_mapIcon(4, "food"),
                      iconColor: _mapColor(4, context))),
              label: "",
              backgroundColor: Theme.of(context).colorScheme.primary),
        ],
      ),
      body: Stack(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: screen[_index],
          ),
          DraggableWidget(
            bottomMargin: 80,
            topMargin: 80,
            intialVisibility: true,
            horizontalSpace: 20,
            shadowBorderRadius: 50,
            initialPosition: AnchoringPosition.topLeft,
            child: const SugarTimer(),
          ),
        ],
      ),
    );
  }
}

class ButtonContainer extends StatelessWidget {
  const ButtonContainer({
    super.key,
    required this.child,
    this.isSelected = false,
  });
  final Widget child;
  final bool isSelected;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: isSelected ? Colors.white : Colors.transparent),
      child: child,
    );
  }
}

class ChangeBottomNavigationController extends ChangeNotifier {
  ChangeBottomNavigationController._();

  static ChangeBottomNavigationController instance =
      ChangeBottomNavigationController._();

  int pageIndex = 0;

  void changeBottomNavigation(int index) {
    pageIndex = index;
    notifyListeners();
  }
}

class SugarTimer extends StatefulWidget {
  const SugarTimer({super.key});

  @override
  State<SugarTimer> createState() => _SugarTimerState();
}

class _SugarTimerState extends State<SugarTimer> {
  int sugar = 0;
  late Timer timer;

  @override
  void initState() {
    timer = Timer.periodic(const Duration(seconds: 4), (timer) {
      int min = 25;
      int max = 210;
      sugar = min + Random().nextInt(max - min);
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.pushNamed(context, Routes.bluetoothDeviceView),
      child: Container(
        height: 100,
        width: 100,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
            border: Border.all(color: Theme.of(context).colorScheme.primary)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'قياس السكر الان هو',
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              sugar.toString(),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
