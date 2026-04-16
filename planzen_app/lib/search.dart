import 'package:flutter/material.dart';
import 'package:planzen_app/plant_service.dart';
import 'package:planzen_app/plant_task_service.dart';
import 'package:planzen_app/widgets/plant_item.dart';
import 'main.dart';
import 'hive.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
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

class Search extends StatefulWidget {
  const Search({super.key, required this.title});

  final String title;

  @override
  State<Search> createState() => SearchState();
}

class SearchState extends State<Search> {
  List<PlantTask> matchingTasks = [];
  List<Widget> taskWidgets = [];

  whichMatchingPlants(input) {
    setState(() {
      matchingTasks = PlantTaskService.instance()
          .getAllTasks()
          .where((task) => task.whatToDo.toLowerCase().contains(input) || task.getPlant().name.toLowerCase().contains(input))
          .toList();
      taskWidgets=  matchingTasks.map(
              (task) => PlantItem(task: task, onChange: () => setState(() {}))
      ).toList();

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: SearchBar(
          hintText: 'Suchen',
          leading: Icon(Icons.search),
          onChanged: (value) {
            whichMatchingPlants(value.toLowerCase());
          },
          padding: const WidgetStatePropertyAll<EdgeInsets>(
            EdgeInsets.symmetric(horizontal: 16.0),
          ),
        ),
      ),
      body: ListView(children: taskWidgets),
    );
  }
}
