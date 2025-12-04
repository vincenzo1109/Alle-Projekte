import 'package:flutter/material.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:planzen_app/newplant.dart';
import 'package:planzen_app/settings.dart';
import 'search.dart';
import 'achievements.dart';
import 'impressum.dart';
import 'plants_overview.dart';
import 'package:intl/intl.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'main.g.dart';

//var for Hive-Keys (easier (Autocompletion); no spelling Mistakes)
String objectPlantKey = 'plantObjectSaves';
String dataKey = 'dataSaves';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(AllPlantsAdapter()); //Hive-Adapter for Object-Saving
  await Hive.openBox(dataKey); //Hive-Create of Box for any other Data
  await Hive.openBox(objectPlantKey); //Hive-Create for plantObjects
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
  List<AllPlants> plantsListHomeScreen = [];

  var plantDataBox = Hive.box(dataKey);
  var plantObjectBox = Hive.box(objectPlantKey);

  void getObjectList() {
    var objectList = plantObjectBox.get('plantObjectList');
    if (objectList != null) {
      plantsListHomeScreen = (objectList as List).cast<AllPlants>();
      myPlants = plantsListHomeScreen;
    } else {
      debugPrint('Fehler beim getObjectList()');
    }
  }

  @override
  void initState() {
    super.initState();

    var opened = plantDataBox.get('alreadyOpened', defaultValue: false);
    opened ? getObjectList() : plantsListHomeScreen = myPlants;
  }

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
      body: ListView(children: plantsHomescreen(plantsListHomeScreen)),
    );
  }

  List<Widget> plantsHomescreen(List<AllPlants> whichList) {
    List<Widget> plantsNext = [];
    var boxHiveOpen = Hive.box(dataKey);
    boxHiveOpen.put('alreadyOpened', true);

    void sortList() {
      whichList.sort((a, b) {
        var dueA = a.lastCompletion.add(Duration(days: a.interval));
        var dueB = b.lastCompletion.add(Duration(days: b.interval));

        return dueA.compareTo(dueB);
      });
    }

    sortList();
    for (var plantvar in whichList) {
      DateTime dueDate = plantvar.lastCompletion.add(
        Duration(days: plantvar.interval),
      );

      int doItInDays = dueDate.difference(now).inDays;

      String dueDateString = DateFormat('dd.MM').format(dueDate);

      var expiredSince = now.difference(dueDate).inDays;

      plantsNext.add(
        ListTile(
          tileColor: dueDate.isBefore(now)
              ? (dueDateString == DateFormat('dd.MM').format(now)
                    ? Colors.blueAccent
                    : null)
              : (Colors.red),
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
              dueDateString == DateFormat('dd.MM').format(now)
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
                      duration: Duration(seconds: 2),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      behavior: SnackBarBehavior.floating,
                      action: SnackBarAction(
                        label: 'Rückgängig',
                        onPressed: () {
                          plantvar.lastCompletion = plantvar.prevLastCompletion;
                          hivePutMyPlantsList(whichList);
                          setState(() {});
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
                  plantvar.prevLastCompletion = plantvar.lastCompletion;
                  plantvar.lastCompletion = DateTime.now();
                  hivePutMyPlantsList(whichList);
                  sortList();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      showCloseIcon: true,
                      duration: Duration(seconds: 2),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      behavior: SnackBarBehavior.floating,
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

List<AllPlants> myPlants = [];

void addPlantMyPlants(
  String name,
  int age,
  DateTime lastTime,
  String whatToDo,
  int interval,
) {
  AllPlants plant = AllPlants(
    name,
    age,
    lastTime.subtract(Duration(days: interval)),
    lastTime,
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
  int age;

  @HiveField(2)
  DateTime prevLastCompletion;

  @HiveField(3)
  DateTime lastCompletion;

  @HiveField(4)
  int interval;

  @HiveField(5)
  String whatToDo;

  AllPlants(
    this.name,
    this.age,
    this.prevLastCompletion,
    this.lastCompletion,
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
    addPlantMyPlants('Rose', 2, formatter.parse('08.11.2025'), 'düngen', 14);
    addPlantMyPlants('Himbeere', 4, formattedDate, 'verschneiden', 21);
    addPlantMyPlants(
      'Erdbeeren',
      3,
      formatter.parse('31.08.2025'),
      'ernten',
      6,
    );
    addPlantMyPlants('Alle Blumen', 4, formattedDate, 'gießen', 7);
    addPlantMyPlants(
      'Löwenzahn',
      1,
      formatter.parse('01.11.2025'),
      'ausrotten',
      7,
    );
    addPlantMyPlants(
      'Hanf-Pflanze',
      1,
      formatter.parse('02.11.2025'),
      'verarbeiten',
      90,
    );
    hivePutMyPlantsList(myPlants);
  }
}
