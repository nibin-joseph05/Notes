import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/note_entity.dart';
import '../../domain/repositories/note_repository_impl.dart';

final noteRepositoryProvider = Provider((ref) => NoteRepositoryImpl());

final notesProvider = StateNotifierProvider<NotesNotifier, List<NoteEntity>>(
  (ref) => NotesNotifier(ref.read(noteRepositoryProvider)),
);

class NotesNotifier extends StateNotifier<List<NoteEntity>> {
  final NoteRepositoryImpl repository;

  NotesNotifier(this.repository) : super([]) {
    loadNotes();
  }

  Future<void> loadNotes() async {
    final list = await repository.getNotes();

    list.sort((a, b) {
      if (a.isPinned != b.isPinned) {
        return b.isPinned ? 1 : -1;
      }
      return b.updatedAt.compareTo(a.updatedAt);
    });

    state = list;
  }

  Future<void> addNote(NoteEntity note) async {
    await repository.saveNote(note);
    await loadNotes();
  }

  Future<void> deleteNote(String id) async {
    await repository.deleteNote(id);
    await loadNotes();
  }

  Future<void> togglePin(String id) async {
    final note = state.firstWhere((e) => e.id == id);
    final updated = note.copyWith(
      isPinned: !note.isPinned,
      updatedAt: DateTime.now(),
    );

    await repository.saveNote(updated);
    await loadNotes();
  }
}
