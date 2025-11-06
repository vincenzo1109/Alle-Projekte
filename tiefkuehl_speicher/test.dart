import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() async {
  await Hive.initFlutter();
  await Hive.openBox('Codes');
  await Hive.openBox('Produkte');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Authenticator-App (sicher)',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.purple.shade900),
        scaffoldBackgroundColor: Colors.white,
      ),
      home: const MyHomePage(title: 'Authenticator-App (sicher)'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

int secretNum = 0;
List<String> Secrets = [];

// ignore: must_be_immutable
class QRCodeScan extends StatelessWidget {
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
}

class _MyHomePageState extends State<MyHomePage> {
  var Box = Hive.box('Secrets');
  Timer? _refreshTimer;
  int secondsLeft = 30;
  double progress = 1.0;

  @override
  void initState() {
    super.initState();
    final box = Hive.box('Secrets');

    secretNum = box.length;
    setState(() {});
    _updateProgress();

    _refreshTimer = Timer.periodic(const Duration(milliseconds: 10), (timer) {
      _updateProgress();
    });
  }

  void _updateProgress() {
    var time = DateTime.now();
    var mseccomplete = 30000;
    secondsLeft = 30 - (time.second % 30);
    progress =
        1 - ((time.millisecond + (time.second % 30) * 1000) / mseccomplete);
    setState(() {});
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Die OTP-Codes :) (noch $secondsLeft Sekunden gültig)',
          style: TextStyle(fontSize: 19, color: Colors.white),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4.0),
          child: LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.white,
            color: Colors.green[500],
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: ListView(children: codeGeneration()),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => QRCodeScan()),
          );
          setState(() {});
        },
        tooltip: 'Add',
        child: const Icon(Icons.barcode_reader),
      ),
    );
  }

  List<Widget> codeGeneration() {
    List<Widget> widgets = [];

      widgets.add(
        ListTile(
//          leading:
          title: Text(code, style: TextStyle(fontSize: 17)),
          subtitle: Text(
            issuer.get(i).toString(),
            style: TextStyle(fontSize: 14),
          ),

          trailing: PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'delete') {
                deleteCode(i);
              }
            },
            itemBuilder:
                (context) => [
              PopupMenuItem(value: 'delete', child: Text('Löschen')),
              PopupMenuItem(
                value: 'generate QR-Code',
                child: Text('QR-Code erstellen'),
              ),
            ],
            initialValue: (i.toString()),
          ),
        ),
      );
    return widgets;
  }

  void deleteCode(int i) async {
    bool? delete = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
        title: Text('Löschen des Codes'),
        content: Text(
          'Bist du dir sicher, dass du den Code löschen möchtest?',
        ),
        actions: [
          TextButton(
            child: Text('Nein'),
            onPressed: () => Navigator.of(context).pop(false),
          ),
          TextButton(
            child: Text('Ja'),
            onPressed: () => Navigator.of(context).pop(true),
          ),
        ],
      ),
    );
    if (delete == true) {
      var secretsBox = Hive.box('Secrets');
      var issuer2Box = Hive.box('issuer2');
      var issuerBox = Hive.box('issuer');

      issuerBox.delete(i);
      secretsBox.delete(i);
      issuer2Box.delete(i);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Der Code und alle anderen Daten dieses Codes wurden erfolgreich entfernt.',
          ),
        ),
      );
    }
    setState(() {});
  }

  void generatQRCode(int i) {
    var secrets = Hive.box('Secrets');
    var secret = secrets.get(i);
    var issuers = Hive.box('issuer');
    var issuer = issuers.get(i);
    var issuer2Box = Hive.box('issuer2');
    var issuer2 = issuer2Box.get(i);

    String URL = 'otpauth://totp/$issuer?secret=$secret&issuer=$issuer2';
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
        title: Text('QR-Code'),
        content: SizedBox(
          width: 200,
          height: 200,
          child: QrImageView(
            data: URL,
            version: QrVersions.auto,
            size: 200.0,
          ),
        ),
        actions: [
          TextButton(
            child: Text('Schließen'),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }
}
