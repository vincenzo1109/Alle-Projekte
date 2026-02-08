import 'package:flutter/material.dart';

// ignore: unused_import
import 'package:intl/intl.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:planzen_app/plant_service.dart';

import 'hive.dart';
import 'main.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class NewPlant extends StatefulWidget {
  const NewPlant({super.key, required this.title});

  final String title;

  @override
  State<NewPlant> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<NewPlant> {
  String? name;
  int age = 0;
  DateTime lastTime = DateTime.now();
  String whatToDo = '';
  bool wateringBool = true;
  int? interval;
  bool ageOk = true;
  bool intervalOk = true;
  bool nameOk = true;

  TextEditingController datePicked = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var allmediaWidth = MediaQuery.of(context).size.width.toInt() * 0.4;

    return Scaffold(
      appBar: AppBar(title: Text('Pflanze hinzufügen')),
      body: ListView(
        children: [
          ListTile(
            titleAlignment: ListTileTitleAlignment.center,
            title: Text('Name der Pflanze:'),
            leading: Icon(Symbols.abc),
            trailing: SizedBox(
              width: allmediaWidth,
              child: TextField(
                onChanged: (value) {
                  var maybeString = value.isEmpty ? null : value;
                  setState(() {
                    if (maybeString != null) {
                      name = maybeString;
                      nameOk = true;
                    } else {
                      nameOk = false;
                    }
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Name',
                  filled: !nameOk,
                  fillColor: Colors.red,
                  errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red),
                  ),
                ),
              ),
            ),
          ),
          ListTile(
            titleAlignment: ListTileTitleAlignment.center,
            title: Text('Wie alt ist die Pflanze'),
            leading: Icon(Symbols.timelapse),
            trailing: SizedBox(
              width: allmediaWidth,
              child: TextField(
                onChanged: (value) {
                  var maybeInt = value.isEmpty ? 0 : int.tryParse(value);
                  setState(() {
                    if (maybeInt != null && maybeInt >= 0) {
                      age = maybeInt;
                      ageOk = true;
                    } else {
                      ageOk = false;
                    }
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Anzahl in Jahren',
                  filled: !ageOk,
                  fillColor: Colors.red,
                  errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red),
                  ),
                ),
              ),
            ),
          ),
          ListTile(
            titleAlignment: ListTileTitleAlignment.center,
            title: Text('Muss die Pflanze gegossen werden'),
            leading: Icon(Symbols.water_do),
            trailing: SizedBox(
              width: allmediaWidth,
              child: Checkbox(
                value: wateringBool,
                onChanged: (value) => setState(() {
                  wateringBool = value!;
                  setState(() {});
                }),
              ),
            ),
          ),
          if (wateringBool)
            ListTile(
              titleAlignment: ListTileTitleAlignment.center,
              title: Text('Gießhäufigkeit: aller ... Tage'),
              leading: Icon(Symbols.water_damage),
              trailing: SizedBox(
                width: allmediaWidth,
                child: TextField(
                  onChanged: (value) {
                    final maybeInt = value.isEmpty ? null : int.tryParse(value);
                    setState(() {
                      if (maybeInt != null && maybeInt >= 0) {
                        interval = maybeInt;
                        intervalOk = true;
                      } else {
                        intervalOk = false;
                      }
                    });
                  },
                  decoration: InputDecoration(
                    hintText: 'Anzahl Tage',
                    filled: !intervalOk,
                    fillColor: Colors.red,
                    errorBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red),
                    ),
                  ),
                ),
              ),
            ),
          if (wateringBool)
            ListTile(
              minVerticalPadding: 22,
              titleAlignment: ListTileTitleAlignment.center,
              title: Text('Wann wurde zulezt gegossen?'),
              leading: Icon(Symbols.water_damage),
              trailing: SizedBox(
                width: allmediaWidth,
                child: TextField(
                  controller: datePicked,
                  decoration: InputDecoration(
                    labelText: 'Datum',
                    prefixIcon: Icon(Icons.calendar_today),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue),
                    ),
                  ),
                  readOnly: true,
                  onTap: () {
                    selectDate();
                  },
                ),
              ),
            ),
          TextButton(
            onPressed: () {
              if (intervalOk && ageOk && name != null && interval != null) {
                whatToDo = wateringBool ? 'gießen' : 'nicht angegeben';
                setState(() {
                  PlantService.instance().addPlantMyPlants(name!, age, lastTime, whatToDo, interval!, buildNewPlantId(), 'assets/image/icon.png');
                  PlantService.instance().saveAllPlants();
                });
                Navigator.pop(context);
              } else {
                setState(() {
                  intervalOk = false;
                  ageOk = false;
                  nameOk = false;
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    showCloseIcon: true,
                    duration: Duration(seconds: 2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    behavior: SnackBarBehavior.floating,
                    content: Text(
                      'Es gibt noch Fehler (rote Felder)',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              }
            },
            child: Text('Pflanze hinzufügen'),
          ),
        ],
      ),
    );
  }

  Future<void> selectDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        datePicked.text = DateFormat('dd.MM.yyyy').format(picked);
        lastTime = picked;
      });
    }
  }
}
