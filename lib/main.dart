import 'dart:async';
import 'package:flutter/material.dart';
import 'led_control_page.dart';
import 'package:flutter_blue/flutter_blue.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final FlutterBlue flutterBlue = FlutterBlue.instance;
  List<BluetoothDevice> devicesList = [];

  @override
  void initState() {
    super.initState();
    _startScan();
  }

  void _startScan() {
    flutterBlue.scanResults.listen((List<ScanResult> results) {
      setState(() {
        devicesList.clear();
      });
      for (ScanResult result in results) {
        setState(() {
          devicesList.add(result.device);
        });
      }
    });
    flutterBlue.startScan();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Control de LED RGB'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                enviarColorLed();
              },
              child: Text('Encender LED'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ColorPickerPage()),
                );
              },
              child: Text('Seleccionar Color'),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text('Dispositivos disponibles'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: devicesList.map((device) {
                    return ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text('Conectando...'),
                              content: Builder(
                                builder: (BuildContext context) {
                                  Future.delayed(Duration(seconds: 2), () {
                                    Navigator.of(context)
                                        .popUntil((route) => route.isFirst);
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: Text('Conectado'),
                                          content: Row(
                                            children: [
                                              Icon(Icons.check_circle,
                                                  color: Colors.green),
                                              SizedBox(width: 10),
                                              Text('Conexión establecida'),
                                            ],
                                          ),
                                          actions: <Widget>[
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: Text('Cerrar'),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  });
                                  return CircularProgressIndicator();
                                },
                              ),
                            );
                          },
                        );
                      },
                      child: Text(device.name),
                    );
                  }).toList(),
                ),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('Cerrar'),
                  ),
                ],
              );
            },
          );
        },
        icon: Icon(Icons.bluetooth),
        label: Text('Conectar Dispositivos'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
