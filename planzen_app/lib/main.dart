import 'package:flutter/material.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:planzen_app/settings.dart';
import 'search.dart';
import 'achievements.dart';
import 'impressum.dart';
import 'plants_overview.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    existingPlants();
  }

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
        appBarTheme: AppBarTheme(
          centerTitle: true,
          toolbarHeight: 70,
          titleTextStyle: theme.textTheme.titleLarge?.copyWith(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
          iconTheme: IconThemeData(size: 30), // Drawer + Actions Icons
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
      },
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
  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Plan(t)er:\n Die Pflanzenübersicht',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
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
                Navigator.pushNamed(context, '/plants_overview');
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
      body: ListView(children: plants_Homescreen()),
    );
  }

  List<Widget> plants_Homescreen() {
    List<Widget> plantsNext = [];
    for (var plantvar in MyPlants) {
      plantsNext.add(
        ListTile(
          title: Center(
            child: Text(plantvar.name, style: TextStyle(fontSize: 20)),
          ),
          subtitle: Center(
            child: Text(
              'Alter: ${plantvar.alter} Jahre (seit dem ${plantvar.lasttime} '
                  'nicht mehr gemacht)',
            ),
          ),
        ),
      );
    }
    return plantsNext;
  }
}

DateTime now = new DateTime.now();
DateTime date = new DateTime(now.year, now.month, now.day);
var formatter = DateFormat('dd.MM.yyyy HH:mm');
    String formattedDate = formatter.format(now);

List<allPlants> MyPlants = [];

void existingPlants() {
  addPlantMyPlants('Rose', 2, formattedDate);
  addPlantMyPlants('Himbeere', 4, formattedDate);
}

void addPlantMyPlants(String nameinc, var alterinc, var lasttime) {
  int alter = alterinc;
  String name = nameinc;
  MyPlants.add(allPlants(name, alter, lasttime));
  allPlants $name = allPlants(name, alter, lasttime);
}

class allPlants {
  String name;
  int alter;
  var lasttime;

  //constructor
  allPlants(this.name, this.alter, this.lasttime);
}
