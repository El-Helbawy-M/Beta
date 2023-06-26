import 'dart:async';
import 'dart:convert';
import 'dart:developer' as dev;
import 'dart:math';

import 'package:draggable_widget/draggable_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:flutter_project_base/handlers/icon_handler.dart';
import 'package:flutter_project_base/services/home/pages/home_page.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';

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

  bool connectDevice = false;

  // Initializing the Bluetooth connection state to be unknown
  BluetoothState _bluetoothState = BluetoothState.UNKNOWN;
  // Get the instance of the Bluetooth
  final FlutterBluetoothSerial _bluetooth = FlutterBluetoothSerial.instance;
  // Track the Bluetooth connection with the remote device
  BluetoothConnection? connection;

  bool isDisconnecting = false;

  Future<void> connectToBluetooth() async {
    var cameraStatus = await Permission.camera.status;
    if (!cameraStatus.isGranted) {
      await Permission.camera.request();
    }

    var status = await Permission.bluetoothConnect.status;
    if (!status.isGranted) {
      await Permission.bluetoothConnect.request();
    }
    var bluetoothStatus = await Permission.bluetooth.status;
    if (!bluetoothStatus.isGranted) {
      await Permission.bluetooth.request();
    }

    // Get current state
    FlutterBluetoothSerial.instance.state.then((state) {
      setState(() {
        _bluetoothState = state;
      });
    });

    // If the bluetooth of the device is not enabled,
    // then request permission to turn on bluetooth
    // as the app starts up
    enableBluetooth();

    // Listen for further state changes
    FlutterBluetoothSerial.instance
        .onStateChanged()
        .listen((BluetoothState state) {
      setState(() {
        _bluetoothState = state;
        if (_bluetoothState == BluetoothState.STATE_OFF) {
          _isButtonUnavailable = true;
        }
        getPairedDevices();
      });
    });
  }

  String? number;

  // To track whether the device is still connected to Bluetooth
  bool get isConnected => connection != null && connection!.isConnected;

  // Define some variables, which will be required later
  List<BluetoothDevice> _devicesList = [];
  BluetoothDevice? _device;
  bool _connected = false;
  bool _isButtonUnavailable = false;

  @override
  void dispose() {
    // Avoid memory leak and disconnect
    if (isConnected) {
      isDisconnecting = true;
      connection!.dispose();
      connection = null;
    }

    super.dispose();
  }

  // Request Bluetooth permission from the user
  Future<bool> enableBluetooth() async {
    // Retrieving the current Bluetooth state
    _bluetoothState = await FlutterBluetoothSerial.instance.state;

    // If the bluetooth is off, then turn it on first
    // and then retrieve the devices that are paired.
    if (_bluetoothState == BluetoothState.STATE_OFF) {
      await FlutterBluetoothSerial.instance.requestEnable();
      await getPairedDevices();
      return true;
    } else {
      await getPairedDevices();
    }
    return false;
  }

  // For retrieving and storing the paired devices
  // in a list.
  Future<void> getPairedDevices() async {
    List<BluetoothDevice> devices = [];

    // To get the list of paired devices
    try {
      devices = await _bluetooth.getBondedDevices();
    } on PlatformException {
      dev.log("Error");
    }

    // It is an error to call [setState] unless [mounted] is true.
    if (!mounted) {
      return;
    }

    // Store the [devices] list in the [_devicesList] for accessing
    // the list outside this class
    setState(() {
      _devicesList = devices;
    });
  }

  @override
  void initState() {
    ChangeBottomNavigationController.instance.addListener(() {
      _index = ChangeBottomNavigationController.instance.pageIndex;
      setState(() {});
    });
    connectToBluetooth();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
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
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: DropdownButton(
                              items: _getDeviceItems(),
                              isExpanded: true,
                              onChanged: (value) =>
                                  setState(() => _device = value),
                              value: _devicesList.isNotEmpty ? _device : null,
                            ),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            connectDevice = true;
                            setState(() {});
                          },
                          child: Text(connectDevice ? 'قطع الاتصال' : 'اتصال'),
                        ),
                      ],
                    ),
                  ),
                  Expanded(child: screen[_index]),
                ],
              ),
            ),
            if (connectDevice)
              DraggableWidget(
                bottomMargin: 80,
                topMargin: 80,
                intialVisibility: true,
                horizontalSpace: 20,
                shadowBorderRadius: 50,
                initialPosition: AnchoringPosition.topLeft,
                child: SugarTimer(number: number),
              ),
          ],
        ),
      ),
    );
  }

  // Create the List of devices to be shown in Dropdown Menu
  List<DropdownMenuItem<BluetoothDevice>> _getDeviceItems() {
    List<DropdownMenuItem<BluetoothDevice>> items = [];
    if (_devicesList.isEmpty) {
      items.add(const DropdownMenuItem(
        child: Text('HC 05'),
      ));
    } else {
      for (var device in _devicesList) {
        items.add(DropdownMenuItem(
          value: device,
          child: Text(device.name ?? 'HC 05'),
        ));
      }
    }
    return items;
  }

  void _connect() async {
    setState(() {
      _isButtonUnavailable = true;
    });
    if (_device == null) {
      show('يجب الاختيار');
    } else {
      if (!isConnected) {
        await BluetoothConnection.toAddress(_device!.address)
            .then((connectionData) {
          dev.log('Connected to the device');
          connection = connectionData;
          setState(() {
            _connected = true;
          });

          connection!.input!.listen((Uint8List data) {
            dev.log('Data incoming: ${ascii.decode(data)}');

            number = ascii.decode(data);

            int numberNum = int.tryParse(number ?? '0') ?? 0;
            MapEntry<String, int> item = MapEntry(
                DateFormat('hh:mm a').format(DateTime.now()), numberNum);

            if (numberNum > 160) {
              show("قياس السكر عالى للغاية");
            }

            ChartsDataController.instance
                .setNewItemTo(ChartsDataController.bloodSugarType, item);
            setState(() {});
            connection!.output.add(data);

            if (ascii.decode(data).contains('!')) {
              connection!.finish();
              dev.log('Disconnecting by local host');
            }
          }).onDone(() {
            if (isDisconnecting) {
              dev.log('Disconnecting locally!');
            } else {
              dev.log('Disconnected remotely!');
            }
            if (mounted) {
              number = null;
              setState(() {});
            }
          });
        }).catchError((error) {
          number = null;
          setState(() {});
          dev.log('Cannot connect, exception occurred');
          dev.log(error.toString());
        });
        show('Device connected');

        setState(() => _isButtonUnavailable = false);
      }
    }
  }

  void _disconnect() async {
    setState(() {
      _isButtonUnavailable = true;
      number = null;
    });

    await connection!.close();
    show('تم فصل الاتصال');
    if (!connection!.isConnected) {
      setState(() {
        _connected = false;
        _isButtonUnavailable = false;
      });
    }
  }

  Future show(
    String message, {
    Duration duration = const Duration(seconds: 3),
  }) async {
    await Future.delayed(const Duration(milliseconds: 100));
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      duration: duration,
    ));
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
  const SugarTimer({super.key, this.number});
  final String? number;

  @override
  State<SugarTimer> createState() => _SugarTimerState();
}

class _SugarTimerState extends State<SugarTimer> {
  int sugar = 0;
  late Timer timer;

  @override
  void initState() {
    timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      int min = 25;
      int max = 210;
      sugar = min + Random().nextInt(max - min);
      MapEntry<String, int> item = MapEntry(DateTime.now().toString(), sugar);

      // if (sugar > 160) {
      //   show("قياس السكر عالى للغاية");
      // }

      if (ChartsDataController.instance.bloodSugar.length > 5) {
        MapEntry<String, int> lastItem =
            ChartsDataController.instance.bloodSugar.last;
        ChartsDataController.instance.bloodSugar.clear();
        ChartsDataController.instance.bloodSugar.add(lastItem);
      }
      ChartsDataController.instance
          .setNewItemTo(ChartsDataController.bloodSugarType, item);

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
      // onTap: () => Navigator.pushNamed(context, Routes.bluetoothDeviceView),
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
              (widget.number ?? sugar).toString(),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Future show(
    String message, {
    Duration duration = const Duration(seconds: 3),
  }) async {
    await Future.delayed(const Duration(milliseconds: 100));
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      duration: duration,
    ));
  }
}
