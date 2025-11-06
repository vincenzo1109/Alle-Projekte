import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() async{
  await Hive.initFlutter();
  await Hive.openBox('Codes');
  await Hive.openBox('Produkte');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Die App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Deine Kühlmögl'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}
int a= 0;
class _MyHomePageState extends State<MyHomePage> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('You have pushed the button this many times:'),
            Text(
              'Test',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Hallo!")),
        );
      },
        tooltip: 'Increment',
        child: const Icon(Icons.barcode_reader),
      ),
    );
  }
}

class QRCodeScan extends StatefulWidget {

  bool found = false;
  final MobileScannerController controller = MobileScannerController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Barcode-Scanner (Bitte scannen)')),
      body: GestureDetector(
        child: RotatedBox(
          quarterTurns: 0,
          child: MobileScanner(
            controller: controller,
            onDetect: (capture) {
              if (found == true) return;

              final QRcode = capture.barcodes.first;
              final String? QRcodeString = QRcode.rawValue;

              if (QRcodeString != null) {
                // ignore: unnecessary_null_comparison
                if (QRcode != null) {
                  found = true;
                  String EAN = QRcodeString;
                  Navigator.pop(context, EAN);
                  }
                }

            },
          ),
        ),
      ),
    );
  }

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    throw UnimplementedError();
  }
}