import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter/services.dart';
import 'package:otp/otp.dart';
import 'dart:async';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:base32/base32.dart';
import 'package:simple_icons/simple_icons.dart';
import 'package:timezone/data/latest.dart' as timezone;
import 'package:timezone/timezone.dart' as timezone;

void main() async {
  await Hive.initFlutter();
  await Hive.openBox('Secrets');
  await Hive.openBox('issuer');
  await Hive.openBox('issuer2');
  runApp(const MyApp());
}

final Map<String, IconData> issuerIconMap = {
  // die ersten 40 von vorher
  'google': SimpleIcons.google,
  'facebook': SimpleIcons.facebook,
  'instagram': SimpleIcons.instagram,
  'amazon': SimpleIcons.amazon,
  'github': SimpleIcons.github,
  'steam': SimpleIcons.steam,
  'spotify': SimpleIcons.spotify,
  'dropbox': SimpleIcons.dropbox,
  'netflix': SimpleIcons.netflix,
  'apple': SimpleIcons.apple,
  'paypal': SimpleIcons.paypal,
  'discord': SimpleIcons.discord,
  'reddit': SimpleIcons.reddit,
  'snapchat': SimpleIcons.snapchat,
  'tiktok': SimpleIcons.tiktok,
  'whatsapp': SimpleIcons.whatsapp,
  'youtube': SimpleIcons.youtube,
  'telegram': SimpleIcons.telegram,
  'ebay': SimpleIcons.ebay,
  'fitbit': SimpleIcons.fitbit,
  'icloud': SimpleIcons.icloud,
  'samsung': SimpleIcons.samsung,
  'slack': SimpleIcons.slack,
  'uber': SimpleIcons.uber,
  'viber': SimpleIcons.viber,
  'wikipedia': SimpleIcons.wikipedia,
  'zoom': SimpleIcons.zoom,
  'twitch': SimpleIcons.twitch,
  'signal': SimpleIcons.signal,
  'protonmail': SimpleIcons.protonmail,
  'nextcloud': SimpleIcons.nextcloud,
  'bitwarden': SimpleIcons.bitwarden,
  'duo': SimpleIcons.google,

  // jetzt 60 weitere:
  'airbnb': SimpleIcons.airbnb,
  'android': SimpleIcons.android,
  'angular': SimpleIcons.angular,
  'apache': SimpleIcons.apache,
  'arduino': SimpleIcons.arduino,
  'atlassian': SimpleIcons.atlassian,
  'behance': SimpleIcons.behance,
  'bootstrap': SimpleIcons.bootstrap,
  'cisco': SimpleIcons.cisco,
  'coursera': SimpleIcons.coursera,
  'docker': SimpleIcons.docker,
  'dribbble': SimpleIcons.dribbble,
  'dropbox': SimpleIcons.dropbox,
  'etsy': SimpleIcons.etsy,
  'flutter': SimpleIcons.flutter,
  'flutter': SimpleIcons.flutter,
  'gitlab': SimpleIcons.gitlab,
  'gmail': SimpleIcons.gmail,
  'googlechrome': SimpleIcons.googlechrome,
  'heroku': SimpleIcons.heroku,
  'huawei': SimpleIcons.huawei,
  'invision': SimpleIcons.invision,
  'jetbrains': SimpleIcons.jetbrains,
  'kotlin': SimpleIcons.kotlin,
  'laravel': SimpleIcons.laravel,
  'linux': SimpleIcons.linux,
  'mariadb': SimpleIcons.mariadb,
  'materialdesign': SimpleIcons.materialdesign,
  'mongodb': SimpleIcons.mongodb,
  'mozilla': SimpleIcons.mozilla,
  'npm': SimpleIcons.npm,
  'php': SimpleIcons.php,
  'python': SimpleIcons.python,
  'react': SimpleIcons.react,
  'redux': SimpleIcons.redux,
  'ruby': SimpleIcons.ruby,
  'rust': SimpleIcons.rust,
  'sass': SimpleIcons.sass,
  'scala': SimpleIcons.scala,
  'stackoverflow': SimpleIcons.stackoverflow,
  'stripe': SimpleIcons.stripe,
  'svelte': SimpleIcons.svelte,
  'swift': SimpleIcons.swift,
  'telegram': SimpleIcons.telegram,
  'tensorflow': SimpleIcons.tensorflow,
  'typescript': SimpleIcons.typescript,
  'ubuntu': SimpleIcons.ubuntu,
  'webpack': SimpleIcons.webpack,
  'wordpress': SimpleIcons.wordpress,
  'yelp': SimpleIcons.yelp,
  'zendesk': SimpleIcons.zendesk,
  'zoom': SimpleIcons.zoom,
  'zulip': SimpleIcons.zulip,
};

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Authenticator-App (sicher)',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
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
      appBar: AppBar(title: Text('QR Code Scanner (Bitte scannen)')),
      body: GestureDetector(
        child: RotatedBox(
          quarterTurns: 0,
          child: MobileScanner(
            controller: controller,
            onDetect: (capture) {
              if (found == true) return;

              final QRcode = capture.barcodes.first;
              final String? QRcodeString = QRcode.rawValue;

              if (QRcodeString != null &&
                  QRcodeString.startsWith('otpauth://totp') &&
                  QRcodeString.contains('secret=')) {
                // ignore: unnecessary_null_comparison
                if (QRcode != null) {
                  found = true;
                  Navigator.pop(context, QRcodeString);

                  Uri url = Uri.parse(QRcodeString);
                  var secret = url.queryParameters['secret'];
                  var issuer2 = url.queryParameters['issuer'];
                  var isuser =
                      QRcodeString.split('otpauth://totp/')[1].split('?')[0];

                  if (secret != null) {
                    String code = OTP.generateTOTPCodeString(
                      secret,
                      DateTime.now().millisecondsSinceEpoch,
                      length: 6,
                      algorithm: Algorithm.SHA1,
                      isGoogle: true,
                    );

                    var box = Hive.box('Secrets');
                    box.put(secretNum, secret);
                    var issuer = Hive.box('issuer');
                    issuer.put(secretNum, isuser);
                    var issuer2Box = Hive.box('issuer2');
                    issuer2Box.put(secretNum, issuer2);
                    secretNum++;
                    debugPrint(DateTime.now().millisecondsSinceEpoch.toString());
                    debugPrint(secret);
                  }
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
        child: const Icon(Icons.qr_code_scanner_rounded),
      ),
    );
  }

  List<Widget> codeGeneration() {
    var secrets = Hive.box('Secrets');
    var issuer = Hive.box('issuer');
    var issuer2 = Hive.box('issuer2');
    List<Widget> widgets = [];

    final now = DateTime.now();
    final msEpoch = now.millisecondsSinceEpoch;
    timezone.initializeTimeZones();

    final pacificTimeZone = timezone.getLocation('America/Los_Angeles');
    final date = timezone.TZDateTime.from(now, pacificTimeZone);
    final dateMsEpoch = date.millisecondsSinceEpoch;
    final test =  OTP.generateTOTPCodeString("JBSWY3DPEHPK3PXP", dateMsEpoch);
    if(msEpoch != dateMsEpoch)
      debugPrint("$test bes ist mist");



    for (var i in secrets.keys) {
      if (secrets.get(i) == null || issuer.get(i) == null) continue;

      var secret = secrets.get(i);
      String code = OTP.generateTOTPCodeString(
        secret,
     DateTime.now().millisecondsSinceEpoch,
        algorithm: Algorithm.SHA1,
        isGoogle: true,
      );

      widgets.add(
        ListTile(
          leading: getlogo(issuer2.get(i).toString()),
          title: Text(code, style: TextStyle(fontSize: 17)),
          subtitle: Text(
            issuer.get(i).toString(),
            style: TextStyle(fontSize: 14),
          ),
          onTap: () {
            Clipboard.setData(ClipboardData(text: code));
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Der Code wurde in die Zwischenablage kopiert.'),
              ),
            );
          },
          trailing: PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'delete') {
                deleteCode(i);
              } else if (value == 'generate QR-Code') {
                generatQRCode(i);
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
    }
    return widgets;
  }

  Widget? getlogo(String issuer) {
    var pic = issuer.toLowerCase();
    if (issuerIconMap.containsKey(pic)) {
      return Icon(issuerIconMap[pic], size: 30);
    } else {
      // Standard-Icon, wenn keiner passt
      return Icon(Icons.account_circle, size: 30);
    }
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
