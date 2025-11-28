class NoteEntity {
  final String id;
  final String title;
  final String body;
  final String? imageUrl;
  final bool isPinned;
  final DateTime createdAt;
  final DateTime updatedAt;

  NoteEntity({
    required this.id,
    required this.title,
    required this.body,
    required this.imageUrl,
    required this.isPinned,
    required this.createdAt,
    required this.updatedAt,
  });
}
