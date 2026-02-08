import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:planzen_app/hive.dart';

class PlantService {
  static final PlantService _service = PlantService().._readAllPlants();

  static PlantService instance() => _service;

  final formatter = DateFormat('dd.MM.yyyy');

  late List<AllPlants> allPlants;

  List<AllPlants> getAllPlants() => allPlants;

  void insertPlant(AllPlants plant) {
    allPlants.add(plant);
    saveAllPlants();
  }

  void checkTask(AllPlants plant) {
    plant.prevLastCompletion = plant.lastCompletion;
    plant.lastCompletion = DateTime.now();
    saveAllPlants();
  }

  void revertCheckTask(AllPlants plant) {
    plant.lastCompletion = plant.prevLastCompletion;
    saveAllPlants();
  }

  void saveAllPlants() {
    sortList();
    hivePutMyPlantsList(allPlants);
  }

  void _readAllPlants() {
    var plantObjectBox = Hive.box(objectPlantKey);
    var objectList = plantObjectBox.get(
      'plantObjectList',
    ); //TODO crossing hive! here. Separate
    if (objectList != null) {
      allPlants = (objectList as List).cast<AllPlants>();
    } else {
      allPlants = [];
      _addStandardPlants();
      _readAllPlants();
    }
    debugPrint('Read all plants (${allPlants.length})');

  }

  void sortList() {
    allPlants.sort((a, b) {
      var dueA = a.lastCompletion.add(Duration(days: a.interval));
      var dueB = b.lastCompletion.add(Duration(days: b.interval));

      return dueA.compareTo(dueB);
    });
    debugPrint('Liste sortiert');
  }

  void _addStandardPlants() {
    const String imagePath = 'assets/image/icon.png';
    final formattedDate = formatter.parse(
      '07.11.2025',
    ); // TODO Vorübergehende Lösung

    if (!isAlreadyOpened()) {
      addPlantMyPlants(
        'Rose',
        2,
        formatter.parse('08.11.2025'),
        'düngen',
        14,
        -1,
        imagePath,
      );
      addPlantMyPlants(
        'Himbeere',
        4,
        formattedDate,
        'verschneiden',
        21,
        -2,
        imagePath,
      );
      addPlantMyPlants(
        'Erdbeeren',
        3,
        formatter.parse('31.08.2025'),
        'ernten',
        6,
        -3,
        imagePath,
      );
      addPlantMyPlants(
        'Alle Blumen',
        4,
        formattedDate,
        'gießen',
        7,
        -4,
        imagePath,
      );
      addPlantMyPlants(
        'Löwenzahn',
        1,
        formatter.parse('01.11.2025'),
        'ausrotten',
        7,
        -5,
        imagePath,
      );
      addPlantMyPlants(
        'Hanf-Pflanze',
        1,
        formatter.parse('02.11.2025'),
        'verarbeiten',
        90,
        -6,
        imagePath,
      );
      saveAllPlants();
    }
  }

  void addPlantMyPlants( //TODO Beautify
    String name,
    int age,
    DateTime lastTime,
    String whatToDo,
    int interval,
    int id,
    String path,
  ) {
    AllPlants plant = AllPlants(
      name,
      age,
      lastTime.subtract(Duration(days: interval)),
      lastTime,
      whatToDo,
      interval,
      id,
      path,
    );
    allPlants.add(plant);
  }
}
