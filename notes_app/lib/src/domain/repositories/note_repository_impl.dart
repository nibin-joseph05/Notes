import 'dart:io';
import 'package:hive_flutter/hive_flutter.dart';
import '../../data/models/note_hive_model.dart';
import '../../data/services/api_service.dart';
import '../../domain/entities/note_entity.dart';
import 'note_repository.dart';

class NoteRepositoryImpl implements NoteRepository {
  final notesBox = Hive.box('notesBox');
  final _api = ApiService();

  @override
  Future<void> saveNote(NoteEntity note) async {
    print('[REPO] saveNote — id=${note.id} title="${note.title}" pinned=${note.isPinned}');

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
          print('[REPO] saveNote — deleted old audio: $oldAudioPath');
        } catch (_) {}
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
    print('[REPO] saveNote — written to Hive, syncing to backend...');

    _syncToBackend(note);
  }

  Future<void> _syncToBackend(NoteEntity note) async {
    try {
      String? remoteImageUrl = note.imageUrl;
      if (remoteImageUrl != null && remoteImageUrl.isNotEmpty && !remoteImageUrl.startsWith('http')) {
        final uploadedUrl = await _api.uploadImage(remoteImageUrl);
        if (uploadedUrl != null) remoteImageUrl = uploadedUrl;
      }

      String? remoteAudioUrl = note.audioUrl;
      if (remoteAudioUrl != null && remoteAudioUrl.isNotEmpty && !remoteAudioUrl.startsWith('http')) {
        final uploadedUrl = await _api.uploadAudio(remoteAudioUrl);
        if (uploadedUrl != null) remoteAudioUrl = uploadedUrl;
      }

      final apiNote = note.copyWith(
        imageUrl: remoteImageUrl,
        audioUrl: remoteAudioUrl,
      );

      await _api.upsertNote(apiNote);
    } catch (e) {
      print('[REPO] _syncToBackend failed: $e');
    }
  }

  @override
  Future<List<NoteEntity>> getNotes() async {
    print('[REPO] getNotes — loading from Hive local storage');
    final hiveNotes = notesBox.values.cast<NoteHiveModel>().toList();
    print('[REPO] getNotes — found ${hiveNotes.length} notes in Hive');
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
    print('[REPO] deleteNote — id=$id');

    final note = notesBox.get(id);
    if (note != null && note is NoteHiveModel) {
      if (note.audioUrl != null && note.audioUrl!.isNotEmpty) {
        final audioFile = File(note.audioUrl!);
        if (audioFile.existsSync()) {
          try {
            await audioFile.delete();
            print('[REPO] deleteNote — deleted audio file: ${note.audioUrl}');
          } catch (_) {}
        }
      }
    }

    await notesBox.delete(id);
    print('[REPO] deleteNote — removed from Hive, syncing to backend...');

    _api.deleteNote(id);
  }
}
