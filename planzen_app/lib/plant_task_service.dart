import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:planzen_app/hive.dart';

class PlantTaskService {
  static final PlantTaskService _service = PlantTaskService().._readAllTasks();

  static PlantTaskService instance() => _service;

  late List<PlantTask> allTasks;

  List<PlantTask> getAllTasks() => allTasks;

  final formatter = DateFormat('dd.MM.yyyy');

  void insertTask(PlantTask task) {
    allTasks.add(task);
    saveAllTasks();
  }

  void checkTask(PlantTask task) {
    task.prevLastCompletion = task.lastCompletion;
    task.lastCompletion = DateTime.now();
    saveAllTasks();
  }

  void saveAllTasks() {
    sortList();
    hivePutTaskList(allTasks);
  }

  void sortList() {
    allTasks.sort((a, b) {
      var dueA = a.lastCompletion.add(Duration(days: a.interval));
      var dueB = b.lastCompletion.add(Duration(days: b.interval));

      return dueA.compareTo(dueB);
    });
    debugPrint('Task-Liste sortiert');
  }

  void revertCheckTask(PlantTask plant) {
    plant.lastCompletion = plant.prevLastCompletion!;
    saveAllTasks();
  }

  void hivePutTaskList(List<PlantTask> taskList) {
    var boxHive = Hive.box(objectPlantKey);
    boxHive.put('plantTaskList', taskList);
  }

  void _readAllTasks() {
    var plantObjectBox = Hive.box(objectPlantKey);
    var taskList = plantObjectBox.get('plantTaskList');

    if (taskList != null) {
      allTasks = (taskList as List).cast<PlantTask>();
    } else {
      allTasks = [];

      final formattedDate = formatter.parse(
        '07.11.2025',
      ); // TODO Vorübergehende Lösung

      allTasks.add(PlantTask(-1, 'düngen', 14, formattedDate));
      allTasks.add(PlantTask(-2, 'verschneiden', 21, formattedDate));
      allTasks.add(PlantTask(-3, 'ernten', 6, formattedDate));
      allTasks.add(PlantTask(-4, 'gießen', 7, formattedDate));
      allTasks.add(PlantTask(-5, 'ausrotten', 7, formattedDate));
      allTasks.add(PlantTask(-6, 'verarbeiten', 90, formattedDate));

      saveAllTasks();
      _readAllTasks();
    }
    debugPrint('Read all tasks (${allTasks.length})');
  }

  void addTaskToPlant(
    int id,
    String whatToDo,
    int interval,
    DateTime prevLastCompletion,
    DateTime lastCompletion,
  ) {}
}
