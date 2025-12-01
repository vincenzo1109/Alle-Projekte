import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
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
  String name = '';
  int age = 0;
  String lastTime = '';
  String whatToDo = '';
  bool fertilizer = true;
  int interval = 0;

  @override
  Widget build(BuildContext context) {
    var mediaWidth = MediaQuery.of(context).size.width.toInt();
    lastTime = DateTime.now().toString();
    whatToDo = 'gießen';
    return Scaffold(
      appBar: AppBar(title: Text('Pflanze hinzufügen')),
      body: ListView(
        children: [
          ListTile(
            titleAlignment: ListTileTitleAlignment.center,
            title: Text('Name der Pflanze:'),
            leading: Icon(Symbols.abc),
            trailing: SizedBox(
              width: mediaWidth * 0.7,
              child: TextField(
                onChanged: (value) {
                  name = value;
                },
                decoration: InputDecoration(hintText: 'Name'),
              ),
            ),
          ),
          ListTile(
            titleAlignment: ListTileTitleAlignment.center,
            title: Text('Wie alt ist die Pflanze'),
            leading: Icon(Symbols.timelapse),
            trailing: SizedBox(
              width: mediaWidth * 0.7,
              child: TextField(
                onChanged: (value) {
                  age = int.parse(value);
                },
                decoration: InputDecoration(hintText: 'Anzahl in Jahren'),
              ),
            ),
          ),
          ListTile(
            titleAlignment: ListTileTitleAlignment.center,
            title: Text('Muss die Pflanze gedüngt werden'),
            leading: Icon(Symbols.coronavirus),
            trailing: SizedBox(
              width: mediaWidth * 0.7,
              child: Checkbox(
                value: fertilizer,
                onChanged: (value) => setState(() {
                  fertilizer = value!;
                }),
              ),
            ),
          ),
          ListTile(
            titleAlignment: ListTileTitleAlignment.center,
            title: Text('Gießhäufigkeit: aller ... Tage'),
            leading: Icon(Symbols.water_damage),
            trailing: SizedBox(
              width: mediaWidth * 0.7,
              child: TextField(
                onChanged: (value) {
                  interval = int.parse(value);
                },
                decoration: InputDecoration(hintText: 'Anzahl Tage'),
              ),
            ),
          ),
          ListTile(
            titleAlignment: ListTileTitleAlignment.center,
            title: Text('Wann wurde zulezt gegossen?'),
            leading: Icon(Symbols.water_damage),
            trailing: SizedBox(
              width: mediaWidth * 0.7,
              child: TextField(
                onChanged: (value) {
                  lastTime = value;
                },
                decoration: InputDecoration(hintText: 'Datum (dd.mm.yyyy)'),
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              addPlantMyPlants(name, age, lastTime, whatToDo, interval);
              hivePutMyPlantsList(myPlants);
              Navigator.pop(context);
            },
            child: Text('Pflanze hinzufügen'),
          ),
        ],
      ),
    );
  }

}
