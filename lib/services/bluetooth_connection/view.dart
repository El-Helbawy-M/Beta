import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:permission_handler/permission_handler.dart';

class BluetoothConnectionView extends StatefulWidget {
  const BluetoothConnectionView({super.key});

  @override
  State<BluetoothConnectionView> createState() =>
      _BluetoothConnectionViewState();
}

class _BluetoothConnectionViewState extends State<BluetoothConnectionView> {
  // Initializing the Bluetooth connection state to be unknown
  BluetoothState _bluetoothState = BluetoothState.UNKNOWN;
  // Initializing a global key, as it would help us in showing a SnackBar later
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  // Get the instance of the Bluetooth
  final FlutterBluetoothSerial _bluetooth = FlutterBluetoothSerial.instance;
  // Track the Bluetooth connection with the remote device
  BluetoothConnection? connection;

  int? _deviceState;

  bool isDisconnecting = false;

  Map<String, Color> colors = {
    'onBorderColor': Colors.green,
    'offBorderColor': Colors.red,
    'neutralBorderColor': Colors.transparent,
    'onTextColor': Colors.green[700]!,
    'offTextColor': Colors.red[700]!,
    'neutralTextColor': Colors.blue,
  };

  Future<void> connectToBluetooth() async {
    var status = await Permission.bluetoothConnect.status;
    if (status.isDenied) {
      await Permission.bluetoothConnect.request();
    }
    var bluetoothStatus = await Permission.bluetooth.status;
    if (bluetoothStatus.isDenied) {
      await Permission.bluetooth.request();
    }

    // Get current state
    FlutterBluetoothSerial.instance.state.then((state) {
      setState(() {
        _bluetoothState = state;
      });
    });

    _deviceState = 0; // neutral

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
  void initState() {
    super.initState();
    connectToBluetooth();
  }

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
      log("Error");
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

  // Now, its time to build the UI
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: const Text("الاتصال عن طريق البلوتوث"),
        actions: <Widget>[
          IconButton(
            onPressed: () async {
              // So, that when new devices are paired
              // while the app is running, user can refresh
              // the paired devices list.
              await getPairedDevices().then((_) {
                show('تم تحديث الأجهزة');
              });
            },
            tooltip: 'تحديث قائمة الاجهزة',
            icon: const Icon(
              Icons.refresh,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Visibility(
            visible: _isButtonUnavailable &&
                _bluetoothState == BluetoothState.STATE_ON,
            child: LinearProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                  Theme.of(context).colorScheme.primary),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                const Expanded(
                  child: Text(
                    'تفعيل البلوتوث',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                    ),
                  ),
                ),
                CupertinoSwitch(
                  value: _bluetoothState.isEnabled,
                  onChanged: (bool value) {
                    future() async {
                      if (value) {
                        await FlutterBluetoothSerial.instance.requestEnable();
                      } else {
                        await FlutterBluetoothSerial.instance.requestDisable();
                      }

                      await getPairedDevices();
                      _isButtonUnavailable = false;

                      if (_connected) {
                        _disconnect();
                      }
                    }

                    future().then((_) {
                      setState(() {});
                    });
                  },
                )
              ],
            ),
          ),
          Stack(
            children: <Widget>[
              Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Text(
                      "الاجهزة المقترنه",
                      style: TextStyle(
                        fontSize: 24,
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.w900,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  // Padding(
                  //   padding: const EdgeInsets.all(8.0),
                  //   child: Row(
                  //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //     children: <Widget>[
                  //       const Text(
                  //         'Device:',
                  //         style: TextStyle(
                  //           fontWeight: FontWeight.bold,
                  //         ),
                  //       ),
                  //       Expanded(
                  //         child: DropdownButton(
                  //           items: _getDeviceItems(),
                  //           isExpanded: true,
                  //           onChanged: (value) =>
                  //               setState(() => _device = value),
                  //           value: _devicesList.isNotEmpty ? _device : null,
                  //         ),
                  //       ),
                  //       ElevatedButton(
                  //         onPressed: _isButtonUnavailable
                  //             ? null
                  //             : _connected
                  //                 ? _disconnect
                  //                 : _connect,
                  //         child: Text(_connected ? 'Disconnect' : 'Connect'),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  ListView.separated(
                    itemBuilder: (_, int index) => InkWell(
                      onTap: () {
                        setState(() => _device = _devicesList[index]);
                        _isButtonUnavailable
                            ? null
                            : _connected
                                ? _disconnect()
                                : _connect();
                      },
                      child: ListTile(
                        title: Text(_devicesList[index].name ?? 'لا شئ'),
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 22),
                    separatorBuilder: (_, __) => const Divider(),
                    itemCount: _devicesList.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                  ),
                  const SizedBox(height: 20),
                  if (number != null)
                    Column(
                      children: [
                        const Text(
                          'قياس السكر الان',
                          style: TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 20,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          number ?? '',
                          style: const TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 16,
                          ),
                        ), //number ?? ''
                      ],
                    )
                  // const Divider(),
                  // Padding(
                  //   padding: const EdgeInsets.all(16.0),
                  //   child: Card(
                  //     shape: RoundedRectangleBorder(
                  //       side: BorderSide(
                  //         color: _deviceState == 0
                  //             ? colors['neutralBorderColor']!
                  //             : _deviceState == 1
                  //                 ? colors['onBorderColor']!
                  //                 : colors['offBorderColor']!,
                  //         width: 3,
                  //       ),
                  //       borderRadius: BorderRadius.circular(4.0),
                  //     ),
                  //     elevation: _deviceState == 0 ? 4 : 0,
                  //     child: Padding(
                  //       padding: const EdgeInsets.all(8.0),
                  //       child: Row(
                  //         children: <Widget>[
                  //           Expanded(
                  //             child: Text(
                  //               "DEVICE 1",
                  //               style: TextStyle(
                  //                 fontSize: 20,
                  //                 color: _deviceState == 0
                  //                     ? colors['neutralTextColor']
                  //                     : _deviceState == 1
                  //                         ? colors['onTextColor']
                  //                         : colors['offTextColor'],
                  //               ),
                  //             ),
                  //           ),
                  //           ElevatedButton(
                  //             onPressed: _connected
                  //                 ? _sendOnMessageToBluetooth
                  //                 : null,
                  //             child: const Text("ON"),
                  //           ),
                  //           ElevatedButton(
                  //             onPressed: _connected
                  //                 ? _sendOffMessageToBluetooth
                  //                 : null,
                  //             child: const Text("OFF"),
                  //           ),
                  //         ],
                  //       ),
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ],
          ),
          // Expanded(
          //   child: Padding(
          //     padding: const EdgeInsets.all(20),
          //     child: Center(
          //       child: Column(
          //         mainAxisAlignment: MainAxisAlignment.center,
          //         children: <Widget>[
          //           const Text(
          //             "NOTE: If you cannot find the device in the list, please pair the device by going to the bluetooth settings",
          //             style: TextStyle(
          //               fontSize: 15,
          //               fontWeight: FontWeight.bold,
          //               color: Colors.red,
          //             ),
          //           ),
          //           const SizedBox(height: 15),
          //           ElevatedButton(
          //             style: ElevatedButton.styleFrom(
          //               elevation: 2,
          //             ),
          //             child: const Text("Bluetooth Settings"),
          //             onPressed: () {
          //               FlutterBluetoothSerial.instance.openSettings();
          //             },
          //           ),
          //         ],
          //       ),
          //     ),
          //   ),
          // )
        ],
      ),
    );
  }

  // Create the List of devices to be shown in Dropdown Menu
  List<Widget> _getDeviceItems() {
    List<Widget> items = [];
    if (_devicesList.isEmpty) {
      items.add(const Padding(
        padding: EdgeInsets.all(8.0),
        child: Text('NONE'),
      ));
    } else {
      for (var device in _devicesList) {
        items.add(Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(device.name ?? 'NONE'),
        ));
      }
    }
    return items;
  }

  // Method to connect to bluetooth
  void _connect() async {
    setState(() {
      _isButtonUnavailable = true;
    });
    if (_device == null) {
      show('No device selected');
    } else {
      if (!isConnected) {
        await BluetoothConnection.toAddress(_device!.address)
            .then((connectionData) {
          log('Connected to the device');
          connection = connectionData;
          setState(() {
            _connected = true;
          });

          connection!.input!.listen((Uint8List data) {
            log('Data incoming: ${ascii.decode(data)}');

            number = ascii.decode(data);
            connection!.output.add(data);

            if (ascii.decode(data).contains('!')) {
              connection!.finish();
              log('Disconnecting by local host');
            }
          }).onDone(() {
            if (isDisconnecting) {
              log('Disconnecting locally!');
            } else {
              log('Disconnected remotely!');
            }
            if (mounted) {
              setState(() {});
            }
          });
        }).catchError((error) {
          log('Cannot connect, exception occurred');
          log(error);
        });
        show('Device connected');

        setState(() => _isButtonUnavailable = false);
      }
    }
  }

  // void _onDataReceived(Uint8List data) {
  //   // Allocate buffer for parsed data
  //   int backspacesCounter = 0;
  //   data.forEach((byte) {
  //     if (byte == 8 || byte == 127) {
  //       backspacesCounter++;
  //     }
  //   });
  //   Uint8List buffer = Uint8List(data.length - backspacesCounter);
  //   int bufferIndex = buffer.length;
  //
  //   // Apply backspace control character
  //   backspacesCounter = 0;
  //   for (int i = data.length - 1; i >= 0; i--) {
  //     if (data[i] == 8 || data[i] == 127) {
  //       backspacesCounter++;
  //     } else {
  //       if (backspacesCounter > 0) {
  //         backspacesCounter--;
  //       } else {
  //         buffer[--bufferIndex] = data[i];
  //       }
  //     }
  //   }
  // }

  // Method to disconnect bluetooth
  void _disconnect() async {
    setState(() {
      _isButtonUnavailable = true;
      _deviceState = 0;
    });

    await connection!.close();
    show('Device disconnected');
    if (!connection!.isConnected) {
      setState(() {
        _connected = false;
        _isButtonUnavailable = false;
      });
    }
  }

  // Method to send message,
  // for turning the Bluetooth device on
  void _sendOnMessageToBluetooth() async {
    connection!.output.add(Uint8List.fromList(utf8.encode("0" "\r\n")));
    await connection!.output.allSent;
    show('Device Turned On');
    setState(() {
      _deviceState = 1; // device on
    });
  }

  // Method to send message,
  // for turning the Bluetooth device off
  void _sendOffMessageToBluetooth() async {
    connection!.output.add(Uint8List.fromList(utf8.encode("0" "\r\n")));
    await connection!.output.allSent;
    show('Device Turned Off');
    setState(() {
      _deviceState = -1; // device off
    });
  }

  // Method to show a Snack bar,
  // taking message as the text
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
