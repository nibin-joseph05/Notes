class NoteEntity {
  final String id;
  final String title;
  final String body;
  final String? imageUrl;
  final bool pinned;
  final DateTime createdAt;
  final DateTime updatedAt;

  NoteEntity({
    required this.id,
    required this.title,
    required this.body,
    this.imageUrl,
    required this.pinned,
    required this.createdAt,
    required this.updatedAt,
  });
}
