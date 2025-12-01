import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../data/models/note_hive_model.dart';
import '../../domain/entities/note_entity.dart';
import 'note_repository.dart';

class NoteRepositoryImpl implements NoteRepository {
  final notesBox = Hive.box('notesBox');
  final firestore = FirebaseFirestore.instance.collection('notes');

  @override
  Future<void> saveNote(NoteEntity note) async {
    final model = NoteHiveModel(
      id: note.id,
      title: note.title,
      body: note.body,
      imageUrl: note.imageUrl,
      bgColor: note.bgColor,
      fontFamily: note.fontFamily,
      pinned: note.isPinned,
      createdAt: note.createdAt,
      updatedAt: note.updatedAt,
    );

    // save to hive (offline instant)
    await notesBox.put(note.id, model);

    // save to Firestore (sync cloud)
    await firestore.doc(note.id).set({
      'title': note.title,
      'body': note.body,
      'imageUrl': note.imageUrl,
      'bgColor': note.bgColor,
      'fontFamily': note.fontFamily,
      'pinned': note.isPinned,
      'createdAt': note.createdAt.toIso8601String(),
      'updatedAt': note.updatedAt.toIso8601String(),
    });
  }

  @override
  Future<List<NoteEntity>> getNotes() async {
    final hiveNotes = notesBox.values.cast<NoteHiveModel>().toList();
    return hiveNotes.map((n) => NoteEntity(
      id: n.id,
      title: n.title,
      body: n.body,
      imageUrl: n.imageUrl,
      bgColor: n.bgColor,
      fontFamily: n.fontFamily,
      isPinned: n.pinned,
      createdAt: n.createdAt,
      updatedAt: n.updatedAt,
    )).toList();
  }

  @override
  Future<void> deleteNote(String id) async {
    await notesBox.delete(id);
    await firestore.doc(id).delete();
  }
}
