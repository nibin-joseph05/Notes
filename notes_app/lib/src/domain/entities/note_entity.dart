class NoteEntity {
  final String id;
  final String title;
  final String body;
  final String? imageUrl;
  final int? bgColor;
  final String? fontFamily;
  final String? audioUrl;
  final bool isPinned;
  final DateTime createdAt;
  final DateTime updatedAt;

  NoteEntity({
    required this.id,
    required this.title,
    required this.body,
    this.imageUrl,
    this.bgColor,
    this.fontFamily,
    this.audioUrl,
    required this.isPinned,
    required this.createdAt,
    required this.updatedAt,
  });

  NoteEntity copyWith({
    String? title,
    String? body,
    String? imageUrl,
    int? bgColor,
    String? fontFamily,
    String? audioUrl,
    bool? isPinned,
    DateTime? updatedAt,
  }) {
    return NoteEntity(
      id: id,
      title: title ?? this.title,
      body: body ?? this.body,
      imageUrl: imageUrl ?? this.imageUrl,
      bgColor: bgColor ?? this.bgColor,
      fontFamily: fontFamily ?? this.fontFamily,
      audioUrl: audioUrl ?? this.audioUrl,
      isPinned: isPinned ?? this.isPinned,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
