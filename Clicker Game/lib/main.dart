import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'dart:async';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox('StorageNum');
  await Hive.openBox('record');
  await Hive.openBox('CPS');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Clicker Test',
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
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.black),
      ),
      home: const MyHomePage(title: 'Clicker Game'),
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

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  int rest = 0;
  int Rekord = 0;
  int interval = 0;
  int increment = 0;
  int costCPS = 10;
  int costACPS = 500;
  int currentCPS = 1;
  int currentACPS = 0;
  bool varstartAutoClicker = false;
  Timer? _autoClickTimer;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter = _counter + currentCPS;
      recordshow();
    });
    recordshow();
  }

  void startAutoClicker() {
    if (_autoClickTimer != null && _autoClickTimer!.isActive) {
    } else {
      if (currentACPS >= 1) {
        interval = 1000;
      }
    }

    _autoClickTimer = Timer.periodic(Duration(milliseconds: interval), (timer) {
      setState(() {
        recordshow();
        increment = currentACPS;
        _counter = _counter + increment;
        recordshow();
        saveNum();
      });
      recordshow();
    });
  }

  void initState() {
    super.initState();
    var CPSPrice = Hive.box('CPS');
    CPSPrice.put('costCPS', costCPS);
    CPSPrice.put('costACPS', costACPS);
    recordshow();
  }

  void recordshow() {
    setState(() {
      var record = Hive.box('record');
      Rekord = record.get('record', defaultValue: 0);
      if (_counter >= Rekord + 1) {
        record.put('record', _counter);
        rest = 0;
      } else {
        rest = Rekord - _counter;
      }
    });
  }

  void saveNum() {
    var storage = Hive.box('StorageNum');
    storage.put('counter', _counter);
    print('Deine Zahl wurde erfolgreich gespeichert');
  }

  void loadNum() {
    var storage = Hive.box('StorageNum');
    setState(() {
      _counter = storage.get('counter', defaultValue: 0);
    });
    var cps = Hive.box('CPS');
    setState(() {
      costACPS = cps.get('costACPS');
      costCPS = cps.get('costCPS');
      currentCPS = cps.get('CPS');
      currentACPS = cps.get('ACPS');
      recordshow();
    });
  }

  void resetRecord() {
    setState(() {
      Rekord = 0;
      currentCPS = 1;
      costCPS = 10;
      currentACPS = 0;
      costACPS = 500;
      _counter = 0;
      recordshow();
    });
    _autoClickTimer?.cancel();
  }

  
  void UpgradeFailed(context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Not Enough Clicks"),
          content: Text("Don't have enough Clicks to buy this Upgrade."),
          actions: [
            TextButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void buyCPS(type) {
    var CPSPrice = Hive.box('CPS');
    var costofthis = 0;
    CPSPrice.put('costCPS', costCPS);
    CPSPrice.put('costACPS', costACPS);
    costofthis = CPSPrice.get(type);
    setState(() {
      _counter = _counter - costofthis;
    });
    if (type == 'costCPS') {
      currentCPS++;
      var CPS = Hive.box('CPS');
      CPS.put('CPS', currentCPS);
      costCPS = costCPS + 10;
      CPSPrice.put('costCPS', costCPS);
    } else if (type == 'costACPS') {
      currentACPS = currentACPS + 5;
      print(currentACPS);
      var ACPS = Hive.box('CPS');
      ACPS.put('ACPS', currentACPS);
      costACPS = costACPS + 100;
      ACPS.put('costACPS', costACPS);
      if (varstartAutoClicker == false) {
        varstartAutoClicker = true;
        startAutoClicker();
      }
    }
  }

  void proofPrice(whereToGo, int cost) {
    if (_counter >= cost) {
      print('KP2');
      print('$whereToGo,$cost, $_counter');
      if (whereToGo == 'buyCPS') {
        print('KP');
        buyCPS('costCPS');
      } else if (whereToGo == 'buyACPS') {
        buyCPS('costACPS');
      }
    } else {
      UpgradeFailed(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(widget.title),
        centerTitle: true,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),

        child: SizedBox.expand(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,

            children: <Widget>[
              Container(
                margin: EdgeInsets.only(bottom: 15),
                child: Column(
                  children: [
                    const SizedBox(height: 16),
                    Text(
                      'Dein Rekord: $Rekord Münzen',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Münzen/Klick: $currentCPS',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 16),
                    Text(
                      'Münzen/Sekunde: $currentACPS',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 30),
                child: Column(
                  spacing: 18,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        proofPrice('buyCPS', costCPS);
                      },
                      child: Text(
                          '+1 Münzen/Klick:\n(Kosten: $costCPS Klicks)',
                        textAlign: TextAlign.center,
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purple,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(
                          horizontal: 25,
                          vertical: 15,
                        ),
                        textStyle: TextStyle(fontSize: 19),
                        elevation: 10,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        proofPrice('buyACPS', costACPS);
                      },
                      child: Text(
                        '+5 automatische Münzen/Sekunde:\n(Kosten: $costACPS Klicks)',
                        textAlign: TextAlign.center,
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purple,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 15,
                        ),
                        textStyle: TextStyle(fontSize: 19),
                        elevation: 10,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),

                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),
              Text(
                'Coins: $_counter',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w600,
                  decoration: TextDecoration.underline,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                rest > 0
                    ? 'Noch $rest mal bis zum Rekord!'
                    : 'Rekord erreicht!',
                style: TextStyle(
                  fontSize: 18,
                  color: rest > 0 ? Colors.orange : Colors.green,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 18),
              ElevatedButton.icon(
                onPressed: _incrementCounter,
                icon: Icon(Icons.ads_click),
                label: Text('Geld verdienen'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 100, vertical: 20),
                  textStyle: TextStyle(fontSize: 20),
                  elevation: 10,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: Row(
        spacing: 20,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FloatingActionButton(
            onPressed: saveNum,
            tooltip: 'Zahl speichern',
            backgroundColor: Colors.lightBlueAccent,
            child: const Icon(Icons.download),
          ),
          FloatingActionButton(
            onPressed: resetRecord,
            tooltip: 'Alles zurücksetzen',
            backgroundColor: Colors.red,
            child: const Icon(Icons.lock_reset),
          ),
          FloatingActionButton(
            onPressed: loadNum,
            tooltip: 'Zahl laden',
            backgroundColor: Colors.green,
            child: const Icon(Icons.upload),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
