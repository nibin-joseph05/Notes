// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings_hive_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SettingsHiveModelAdapter extends TypeAdapter<SettingsHiveModel> {
  @override
  final int typeId = 1;

  @override
  SettingsHiveModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SettingsHiveModel(
      voicePermission: fields[0] as bool,
      fontFamily: fields[1] as String,
      darkMode: fields[2] as bool,
      wallpaperPath: fields[3] as String,
    );
  }

  @override
  void write(BinaryWriter writer, SettingsHiveModel obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.voicePermission)
      ..writeByte(1)
      ..write(obj.fontFamily)
      ..writeByte(2)
      ..write(obj.darkMode)
      ..writeByte(3)
      ..write(obj.wallpaperPath);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SettingsHiveModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
