import 'package:flutter/material.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:planzen_app/newplant.dart';
import 'package:planzen_app/plant_service.dart';
import 'package:planzen_app/settings.dart';
import 'package:planzen_app/widgets/plant_item.dart';
import 'hive.dart';
import 'search.dart';
import 'achievements.dart';
import 'impressum.dart';
import 'plants_overview.dart';
import 'package:intl/intl.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(AllPlantsAdapter()); //Hive-Adapter for Object-Saving
  await Hive.openBox(dataKey); //Hive-Create of Box for any other Data
  await Hive.openBox(objectPlantKey); //Hive-Create for plantObjects
  debugPrint('Hive initialisiert');
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  var darkMode = true;
  var theme = ThemeData.dark();

  void setTheme(bool darkMode) {
    setState(() {
      theme = darkMode ? ThemeData.dark() : ThemeData.light();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: theme.copyWith(
        //copies the Theme but changes the AppBar (Font size, Style,…)
        appBarTheme: AppBarTheme(
          centerTitle: true,
          toolbarHeight: 70,
          titleTextStyle: theme.textTheme.titleLarge?.copyWith(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
          iconTheme: IconThemeData(size: 30),
        ),
      ),

      home: const MyHomePage(title: 'Flutter Demo Home Page'),

      initialRoute: '/home',

      debugShowCheckedModeBanner: false,

      routes: {
        '/home': (context) => const MyHomePage(title: 'main'),
        '/search': (context) => const Search(title: 'search'),
        '/settings': (context) => const Settings(title: 'settings'),
        '/impressum': (context) => const Impressum(title: 'impressum'),
        '/achievements': (context) => const Achievements(title: 'achievements'),
        '/plants_overview': (context) =>
            const PlantsOverview(title: 'plants_overview'),
        '/newPlant': (context) => const NewPlant(title: 'newPlant'),
      }, //easier to switch between Screens; its the declaration of the routes
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  var plantDataBox = Hive.box(dataKey);
  var plantObjectBox = Hive.box(objectPlantKey);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Plan(t)er:\n Die Pflanzenübersicht',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        iconTheme: IconThemeData(size: 30),
        actions: [
          IconButton(
            padding: EdgeInsets.all(15),
            icon: Icon(Symbols.search),
            onPressed: () {
              Navigator.pushNamed(context, '/search');
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(child: Text('Menü')),
            ListTile(
              leading: Icon(Symbols.home),
              title: Text('Home'),
              onTap: () {
                Navigator.pushNamed(context, '/home');
              },
            ),
            ListTile(
              leading: Icon(Symbols.potted_plant_rounded),
              title: Text('Pflanzen Details'),
              onTap: () {
                Navigator.pushNamed(
                  context,
                  '/plants_overview',
                  arguments: 'Drawer Plant',
                );
              },
            ),
            ListTile(
              leading: Icon(Symbols.experiment),
              title: Text('Errungenschaften'),
              onTap: () {
                Navigator.pushNamed(context, '/achievements');
              },
            ),
            ListTile(
              leading: Icon(Symbols.add_2_rounded),
              title: Text('Eine weitere Pflanze hinzufügen'),
              onTap: () async {
                await Navigator.pushNamed(context, '/newPlant');
                setState(() {});
              },
            ),
            ListTile(
              leading: Icon(Symbols.settings),
              title: Text('Einstellungen'),
              onTap: () {
                Navigator.pushNamed(context, '/settings');
              },
            ),
            ListTile(
              leading: Icon(Symbols.info),
              title: Text('Impressum'),
              onTap: () {
                Navigator.pushNamed(context, '/impressum');
              },
            ),
          ],
        ),
      ),
      body: RefreshIndicator(
        child: ListView(children: plantsHomescreen()),
        onRefresh: () async {
          setState(() {
            debugPrint('Seite refreshed');
          });
        },
      ),
    );
  }

  List<Widget> plantsHomescreen() {
    List<Widget> plantsNext = [];
    var whichList = PlantService.instance().getAllPlants();

    //TODO Cleanup
    for (var plantvar in whichList) {
      plantsNext.add(PlantItem(plant: plantvar, onChange: () => setState(() {})));
    }
    if (plantsNext.isEmpty) {
      plantsNext.add(
        Center(
          child: Text(
            'Es gibt in den nächsten 2 Monaten nichts zu tun',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ),
      );
    }
    return plantsNext;
  }
}

DateTime now = DateTime.now();
DateTime date = DateTime(now.year, now.month, now.day);
final formatter = DateFormat('dd.MM.yyyy');
//    String formattedDate = formatter.format(now); //TODO Für richtiges Programm
final formattedDate = formatter.parse(
  '07.11.2025',
); // TODO Vorrübergehende Lösung

