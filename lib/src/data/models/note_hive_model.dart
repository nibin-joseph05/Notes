import 'package:hive_flutter/hive_flutter.dart';

part 'note_hive_model.g.dart';

@HiveType(typeId: 0)
class NoteHiveModel {
  @HiveField(0)
  String id;

  @HiveField(1)
  String title;

  @HiveField(2)
  String body;

  @HiveField(3)
  String? imageUrl;

  @HiveField(7)
  int? bgColor;

  @HiveField(8)
  String? fontFamily;

  @HiveField(9)
  String? audioUrl;

  @HiveField(4)
  bool pinned;

  @HiveField(5)
  DateTime createdAt;

  @HiveField(6)
  DateTime updatedAt;

  NoteHiveModel({
    required this.id,
    required this.title,
    required this.body,
    this.imageUrl,
    this.bgColor,
    this.fontFamily,
    this.audioUrl,
    required this.pinned,
    required this.createdAt,
    required this.updatedAt,
  });
}
