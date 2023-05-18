import 'package:flutter/material.dart';
import 'package:flutter_project_base/handlers/icon_handler.dart';
import 'package:flutter_project_base/services/home/pages/home_page.dart';

import '../../services/chats/pages/chats_list_page.dart';
import '../../services/doctor_details/pages/doctor_details_page.dart';
import '../../services/doctors/pages/doctors_list_page.dart';

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
    if (_index == index) return Theme.of(context).bottomNavigationBarTheme.selectedItemColor!;
    return Theme.of(context).bottomNavigationBarTheme.unselectedItemColor!;
  }

  List<Widget> screen = [
    Container(),
    const ChatListPage(),
    HomePage(),
    const DoctorsListPage(),
    Container(),
  ];

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
          BottomNavigationBarItem(icon: ButtonContainer(isSelected: _index == 0, child: drawSvgIcon(_mapIcon(0, "profile"), iconColor: _mapColor(0, context))), label: "", backgroundColor: Theme.of(context).colorScheme.primary),
          BottomNavigationBarItem(icon: ButtonContainer(isSelected: _index == 1, child: drawSvgIcon(_mapIcon(1, "chat"), iconColor: _mapColor(1, context))), label: "", backgroundColor: Theme.of(context).colorScheme.primary),
          BottomNavigationBarItem(icon: ButtonContainer(isSelected: _index == 2, child: drawSvgIcon(_mapIcon(2, "home"), iconColor: _mapColor(2, context))), label: "", backgroundColor: Theme.of(context).colorScheme.primary),
          BottomNavigationBarItem(icon: ButtonContainer(isSelected: _index == 3, child: drawSvgIcon(_mapIcon(3, "user"), iconColor: _mapColor(3, context))), label: "", backgroundColor: Theme.of(context).colorScheme.primary),
          BottomNavigationBarItem(icon: ButtonContainer(isSelected: _index == 4, child: drawSvgIcon(_mapIcon(4, "food"), iconColor: _mapColor(4, context))), label: "", backgroundColor: Theme.of(context).colorScheme.primary),
        ],
      ),
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: screen[_index],
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
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(16), color: isSelected ? Colors.white : Colors.transparent),
      child: child,
    );
  }
}
