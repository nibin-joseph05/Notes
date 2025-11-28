import '../entities/note_entity.dart';

abstract class NoteRepository {
  Future<void> saveNote(NoteEntity note);
  Future<List<NoteEntity>> getNotes();
  Future<void> deleteNote(String id);
}
