import 'package:hive/hive.dart';
import 'package:planzen_app/plant_service.dart';
import 'package:planzen_app/plant_task_service.dart';

part 'hive.g.dart';

//var for Hive-Keys (easier (Autocompletion); no spelling Mistakes)
const String dataKey = 'dataSaves';
const String idKey = 'maxPlantId';
const String objectPlantKey = 'plantObjectSaves';

int buildNewPlantId() {
  var box = Hive.box(objectPlantKey);
  int oldMaxId = box.get(idKey, defaultValue: 0);
  int newMaxId = oldMaxId + 1;
  box.put(idKey, newMaxId);
  return newMaxId;
}

bool isAlreadyOpened() {
  var boxHiveOpen = Hive.box(dataKey);
  bool alreadyOpened = boxHiveOpen.get('alreadyOpened', defaultValue: false);
  return alreadyOpened;
}

void hivePutMyPlantsList(List<AllPlants> saveList) {
  var boxHive = Hive.box(objectPlantKey);
  boxHive.put('plantObjectList', saveList);
}





@HiveType(typeId: 0)
class AllPlants {
  @HiveField(0)
  String name;

  @HiveField(1)
  int age;

  @HiveField(2)
  int id;

  @HiveField(3)
  String imagePath;

  AllPlants(this.name, this.age, this.id, this.imagePath);

  void addTask(String whatToDo, int interval, DateTime lastCompletion){
    var task = PlantTask(id, whatToDo, interval, lastCompletion);
    PlantTaskService.instance().insertTask(task);
  }
}

@HiveType(typeId: 1)
class PlantTask {
  @HiveField(0)
  String whatToDo;

  @HiveField(1)
  int interval;

  DateTime? prevLastCompletion;

  @HiveField(2)
  DateTime lastCompletion;

  @HiveField(3)
  int plantId;

  PlantTask(
    this.plantId,
    this.whatToDo,
    this.interval,
    this.lastCompletion
  );

  AllPlants getPlant() {
    return PlantService.instance().getPlant(plantId);
  }
}
