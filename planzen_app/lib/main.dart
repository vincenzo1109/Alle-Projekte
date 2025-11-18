import 'package:flutter/material.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:planzen_app/settings.dart';
import 'search.dart';
import 'achievements.dart';
import 'impressum.dart';
import 'plants_overview.dart';
import 'package:intl/intl.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'main.g.dart';

String objectPlantKey = 'plantObjectSaves';
String dataKey = 'dataSaves';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(AllPlantsAdapter());
  await Hive.openBox(dataKey);
  await Hive.openBox(objectPlantKey);
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
  List<AllPlants> plantsListHomeScreenFirstStart = [];
  List<AllPlants> plantsListHomeScreenNotFirstStart = [];

  var plantDataBox = Hive.box(dataKey);
  var plantObjectBox = Hive.box(objectPlantKey);

  void getObjectList() {
    var objectList = (plantObjectBox.get('plantObjectList'));
    if (objectList != null) {
      plantsListHomeScreenNotFirstStart = (objectList as List)
          .cast<AllPlants>();
    } else {
        print('Fehler beim getObjectList()');
    }
  }

  @override
  void initState() {
    super.initState();
    plantsListHomeScreenFirstStart = myPlants;
    var openend = plantDataBox.get('alreadyOpened', defaultValue: false);
    openend? getObjectList() : {};
  }

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
              leading: Icon(Symbols.add_2_rounded),
              title: Text('Eine weitere Pflanze hinzufügen'),
              onTap: () {
                Navigator.pushNamed(context, '/impressum');
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
      body: plantDataBox.get('alreadyOpened', defaultValue: false)
          ? ListView(
              children: plantsHomescreen(plantsListHomeScreenNotFirstStart),
            )
          : ListView(
              children: plantsHomescreen(plantsListHomeScreenFirstStart),
            ),
    );
  }

  List<Widget> plantsHomescreen(whichList) {
    List<Widget> plantsNext = [];
    var boxHiveOpen = Hive.box(dataKey);
    boxHiveOpen.put('alreadyOpened', true);

    void sortList() {
      whichList.sort((a, b) {
        var dueA = DateFormat(
          'dd.MM.yyyy',
        ).parse(a.lasttime).add(Duration(days: a.interval));
        var dueB = DateFormat(
          'dd.MM.yyyy',
        ).parse(b.lasttime).add(Duration(days: b.interval));

        return dueA.compareTo(dueB);
      });
    }

    sortList();
    for (var plantvar in whichList) {
      DateTime savedDate = DateFormat('dd.MM.yyyy').parse(plantvar.lasttime);
      DateTime dueDate = savedDate.add(Duration(days: plantvar.interval));
      int doItInDays = dueDate.difference(now).inDays;
      String dueDateString = DateFormat('dd.MM').format(dueDate);
      var expiredSince = now.difference(dueDate).inDays;

      plantsNext.add(
        ListTile(
          tileColor: dueDate.isBefore(now) ? Colors.red : null,
          leading: Text(dueDateString, style: TextStyle(fontSize: 20)),
          title: Center(
            child: Text(
              '${plantvar.name} ${plantvar.whatToDo}',
              style: TextStyle(fontSize: 20),
              textAlign: TextAlign.center,
            ),
          ),
          subtitle: Center(
            child: Text(
              dueDate.isAtSameMomentAs(now)
                  ? 'Muss heute gemacht werden'
                  : (dueDate.isBefore(now)
                        ? (expiredSince == 1
                              ? 'Seit $expiredSince Tag überfällig'
                              : 'Seit $expiredSince Tagen überfällig')
                        : (doItInDays == 1
                              ? 'In $doItInDays Tag anfällig'
                              : 'In $doItInDays Tagen anfällig')),
              textAlign: TextAlign.center,
            ),
          ),
          trailing: IconButton(
            onPressed: () {
              setState(() {
                if (dueDate.difference(now).inDays <= 4) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      showCloseIcon: true,
                      action: SnackBarAction(
                        label: 'Rückgängig',
                        onPressed: () {
                          plantvar.lasttime = lastLastTimeFunction(
                            plantvar.lasttime,
                            plantvar.interval,
                          );
                          plantvar.lastLastTime = lastLastTimeFunction(
                            plantvar.lastLastTime,
                            plantvar.interval,
                          );
                        },
                      ),
                      content: Text(
                        'Wieder etwas erledigt :)',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                  plantvar.lastLastTime = plantvar.lasttime;
                  plantvar.lasttime = DateFormat('dd.MM.yyyy').format(now);
                  hivePutMyPlantsList(whichList);
                  sortList();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      showCloseIcon: true,
                      content: Text(
                        '${plantvar.name} ${plantvar.whatToDo} hat noch Zeit :-)',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                }
              });
            },
            icon: Icon(Icons.check),
          ),
        ),
      );
    }
    getObjectList();
    return plantsNext;
  }
}

DateTime now = DateTime.now();
DateTime date = DateTime(now.year, now.month, now.day);
var formatter = DateFormat('dd.MM.yyyy');
//    String formattedDate = formatter.format(now); //Für richtiges Programm
String formattedDate = '07.11.2025'; // Vorrübergehende Lösung

List<AllPlants> myPlants = [];

lastLastTimeFunction(lasttime, interval) {
  DateTime lastLastTime = DateFormat(
    'dd.MM.yyyy',
  ).parse(lasttime).subtract(Duration(days: interval));
  String lastLastTimeString = lastLastTime.toString();
  return lastLastTimeString;
}

void addPlantMyPlants(
  String nameinc,
  var alterinc,
  String lasttime,
  String whatToDo,
  int interval,
) {
  int alter = alterinc;
  String name = nameinc;

  String lastLastTimeString = lastLastTimeFunction(lasttime, interval);

  AllPlants plant = AllPlants(
    name,
    alter,
    lastLastTimeString,
    lasttime,
    whatToDo,
    interval,
  );
  myPlants.add(plant);
}

@HiveType(typeId: 0)
class AllPlants {
  @HiveField(0)
  String name;

  @HiveField(1)
  int alter;

  @HiveField(2)
  String lastLastTime;

  @HiveField(3)
  String lasttime;

  @HiveField(4)
  int interval;

  @HiveField(5)
  String whatToDo;

  AllPlants(
    this.name,
    this.alter,
    this.lastLastTime,
    this.lasttime,
    this.whatToDo,
    this.interval,
  );
}

void hivePutMyPlantsList(List<AllPlants> saveList) {
  var boxHive = Hive.box(objectPlantKey);
  boxHive.put('plantObjectList', saveList);
}

void existingPlants() {
  var boxHiveOpen = Hive.box(dataKey);
  bool alreadyOpened = boxHiveOpen.get('alreadyOpened', defaultValue: false);
  if (!alreadyOpened) {
    addPlantMyPlants('Rose', 2, '08.11.2025', 'düngen', 14);
    addPlantMyPlants('Himbeere', 4, formattedDate, 'verschneiden', 21);
    addPlantMyPlants('Erdbeeren', 3, '31.08.2025', 'ernten', 3);
    addPlantMyPlants('Alle Blumen', 4, formattedDate, 'gießen', 7);
    addPlantMyPlants('Löwenzahn', 1, '01.11.2025', 'ausrotten', 7);
    addPlantMyPlants('Hanf-Pflanze', 1, '02.11.2025', 'verarbeiten', 90);
    hivePutMyPlantsList(myPlants);
  }
}
