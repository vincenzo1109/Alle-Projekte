import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:planzen_app/newplant.dart';
import 'package:planzen_app/plant_task_service.dart';
import 'package:planzen_app/settings.dart';
import 'package:planzen_app/widgets/plant_item.dart';
import 'achievements.dart';
import 'hive.dart';
import 'impressum.dart';
import 'plants_overview.dart';
import 'search.dart';

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
            padding: const EdgeInsets.all(15),
            icon: const Icon(Symbols.search),
            onPressed: () {
              Navigator.pushNamed(context, '/search');
            },
          ),
        ],
      ),

      drawer: Drawer(
        child: ListView(
          children: [
            const DrawerHeader(child: Text('Menü')),
            ListTile(
              leading: const Icon(Symbols.home),
              title: const Text('Home'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Symbols.potted_plant_rounded),
              title: const Text('Pflanzen Details'),
              onTap: () {
                Navigator.pushNamed(
                  context,
                  '/plants_overview',
                  arguments: 'Drawer Plant',
                );
              },
            ),
            ListTile(
              leading: const Icon(Symbols.experiment),
              title: const Text('Errungenschaften'),
              onTap: () {
                Navigator.pushNamed(context, '/achievements');
              },
            ),
            ListTile(
              leading: const Icon(Symbols.add_2_rounded),
              title: const Text('Eine weitere Pflanze hinzufügen'),
              onTap: () async {
                await Navigator.pushNamed(context, '/newPlant');
                setState(() {});
              },
            ),
            ListTile(
              leading: const Icon(Symbols.settings),
              title: const Text('Einstellungen'),
              onTap: () {
                Navigator.pushNamed(context, '/settings');
              },
            ),
            ListTile(
              leading: const Icon(Symbols.info),
              title: const Text('Impressum'),
              onTap: () {
                Navigator.pushNamed(context, '/impressum');
              },
            ),
          ],
        ),
      ),

      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {
            debugPrint('Seite refreshed');
          });
        },
        child: plantsHomescreen(),
      ),
    );
  }

  Widget plantsHomescreen() {
    List<Widget> nextTasks = [];
    List<PlantTask> allTasks = PlantTaskService.instance().getAllTasks();

    if (allTasks.isEmpty) {
      return const Center(
        child: Text(
          'Es gibt in den nächsten 2 Monaten nichts zu tun',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
      );
    } else {
      return ListView.builder(
        itemCount: allTasks.length,
        itemBuilder: (context, index) {
          return PlantItem(
            task: allTasks[index],
            onChange: () => setState(() {}),
          );
        },
      );
    }

    for (var plantvar in allTasks) {
      nextTasks.add(PlantItem(task: plantvar, onChange: () => setState(() {})));
    }
  }
}
