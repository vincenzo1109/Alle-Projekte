// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hive.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AllPlantsAdapter extends TypeAdapter<AllPlants> {
  @override
  final int typeId = 0;

  @override
  AllPlants read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AllPlants(
      fields[0] as String,
      fields[1] as int,
      fields[2] as int,
      fields[3] as String,
    );
  }

  @override
  void write(BinaryWriter writer, AllPlants obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.age)
      ..writeByte(2)
      ..write(obj.id)
      ..writeByte(3)
      ..write(obj.imagePath);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AllPlantsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class PlantTaskAdapter extends TypeAdapter<PlantTask> {
  @override
  final int typeId = 1;

  @override
  PlantTask read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PlantTask(
      fields[3] as int,
      fields[0] as String,
      fields[1] as int,
      fields[2] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, PlantTask obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.whatToDo)
      ..writeByte(1)
      ..write(obj.interval)
      ..writeByte(2)
      ..write(obj.lastCompletion)
      ..writeByte(3)
      ..write(obj.plantId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PlantTaskAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
