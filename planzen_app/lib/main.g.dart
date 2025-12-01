// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'main.dart';

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
      fields[2] as String,
      fields[3] as String,
      fields[5] as String,
      fields[4] as int,
    );
  }

  @override
  void write(BinaryWriter writer, AllPlants obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.age)
      ..writeByte(2)
      ..write(obj.lastLastTime)
      ..writeByte(3)
      ..write(obj.lastTime)
      ..writeByte(4)
      ..write(obj.interval)
      ..writeByte(5)
      ..write(obj.whatToDo);
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
