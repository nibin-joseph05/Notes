import 'dart:io';
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
    final existingNote = notesBox.get(note.id);
    String? oldAudioPath;

    if (existingNote != null && existingNote is NoteHiveModel) {
      oldAudioPath = existingNote.audioUrl;
    }

    if (oldAudioPath != null && oldAudioPath.isNotEmpty) {
      final oldAudioFile = File(oldAudioPath);

      bool shouldDeleteOldAudio =
          note.audioUrl == null ||
          note.audioUrl!.isEmpty ||
          oldAudioPath != note.audioUrl;

      if (shouldDeleteOldAudio && oldAudioFile.existsSync()) {
        try {
          await oldAudioFile.delete();
          print('Deleted old audio file: $oldAudioPath');
        } catch (e) {
          print('Error deleting old audio file: $e');
        }
      }
    }

    final model = NoteHiveModel(
      id: note.id,
      title: note.title,
      body: note.body,
      imageUrl: note.imageUrl,
      bgColor: note.bgColor,
      fontFamily: note.fontFamily,
      audioUrl: note.audioUrl,
      pinned: note.isPinned,
      createdAt: note.createdAt,
      updatedAt: note.updatedAt,
    );

    await notesBox.put(note.id, model);

    final Map<String, dynamic> firestoreData = {
      'title': note.title,
      'body': note.body,
      'pinned': note.isPinned,
      'createdAt': note.createdAt.toIso8601String(),
      'updatedAt': note.updatedAt.toIso8601String(),
    };

    if (note.imageUrl != null && note.imageUrl!.isNotEmpty) {
      firestoreData['imageUrl'] = note.imageUrl;
    } else {
      firestoreData['imageUrl'] = FieldValue.delete();
    }

    if (note.bgColor != null) {
      firestoreData['bgColor'] = note.bgColor;
    } else {
      firestoreData['bgColor'] = FieldValue.delete();
    }

    if (note.fontFamily != null && note.fontFamily!.isNotEmpty) {
      firestoreData['fontFamily'] = note.fontFamily;
    } else {
      firestoreData['fontFamily'] = FieldValue.delete();
    }

    if (note.audioUrl != null && note.audioUrl!.isNotEmpty) {
      firestoreData['audioUrl'] = note.audioUrl;
    } else {
      firestoreData['audioUrl'] = FieldValue.delete();
    }

    await firestore.doc(note.id).set(firestoreData, SetOptions(merge: true));
  }

  @override
  Future<List<NoteEntity>> getNotes() async {
    final hiveNotes = notesBox.values.cast<NoteHiveModel>().toList();
    return hiveNotes
        .map(
          (n) => NoteEntity(
            id: n.id,
            title: n.title,
            body: n.body,
            imageUrl: n.imageUrl,
            bgColor: n.bgColor,
            fontFamily: n.fontFamily,
            audioUrl: n.audioUrl,
            isPinned: n.pinned,
            createdAt: n.createdAt,
            updatedAt: n.updatedAt,
          ),
        )
        .toList();
  }

  @override
  Future<void> deleteNote(String id) async {
    final note = notesBox.get(id);
    if (note != null && note is NoteHiveModel) {
      if (note.audioUrl != null && note.audioUrl!.isNotEmpty) {
        final audioFile = File(note.audioUrl!);
        if (audioFile.existsSync()) {
          try {
            await audioFile.delete();
            print('Deleted audio file: ${note.audioUrl}');
          } catch (e) {
            print('Error deleting audio file: $e');
          }
        }
      }
    }

    await notesBox.delete(id);
    await firestore.doc(id).delete();
  }
}
