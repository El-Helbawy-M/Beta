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
  // Get the instance of the Bluetooth
  final FlutterBluetoothSerial _bluetooth = FlutterBluetoothSerial.instance;
  // Track the Bluetooth connection with the remote device
  BluetoothConnection? connection;

  bool isDisconnecting = false;

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
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

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
            setState(() {});
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

  void _disconnect() async {
    setState(() {
      _isButtonUnavailable = true;
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
