import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:planzen_app/hive.dart';
import 'package:planzen_app/plant_service.dart';

class PlantItem extends StatefulWidget {
  const PlantItem({super.key, required this.plant, required this.onChange});

  final AllPlants plant;

  final void Function() onChange;

  @override
  State<PlantItem> createState() => _PlantItemState();
}

class _PlantItemState extends State<PlantItem> {

  @override
  Widget build(BuildContext context) {
    AllPlants plant = widget.plant;
    DateTime now = DateTime.now();

    DateTime dueDate = plant.lastCompletion.add(
      Duration(days: plant.interval),
    );

    int doItInDays = dueDate.difference(now).inDays;

    String dueDateString = DateFormat('dd.MM').format(dueDate);

    var expiredSince = now.difference(dueDate).inDays;

    return ListTile(
      onTap: () {
        Navigator.pushNamed(
          context,
          '/plants_overview',
          arguments: plant.id,
        );
      },

      tileColor: dueDate.isBefore(DateTime.now())
          ? (dueDateString == DateFormat('dd.MM').format(now)
          ? Colors.blueAccent
          : Colors.red)
          : (null),

      leading: Text(dueDateString, style: TextStyle(fontSize: 20)),

      title: Center(
        child: Text(
          '${plant.name} ${plant.whatToDo}',
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
          ScaffoldMessenger.of(context).clearSnackBars();
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
                      setState(() => PlantService.instance().revertCheckTask(plant));
                      widget.onChange();
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
              setState(() {
                PlantService.instance().checkTask(plant);
                widget.onChange();
              });
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
                    '${plant.name} ${plant.whatToDo} hat noch Zeit :-)',
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
    );
  }
}
