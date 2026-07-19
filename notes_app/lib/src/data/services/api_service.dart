import 'package:dio/dio.dart';

import '../../core/config/app_config.dart';
import '../../domain/entities/note_entity.dart';

class ApiService {
  late final Dio _dio;

  ApiService() {
    _dio = Dio(BaseOptions(
      baseUrl: AppConfig.baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {'Content-Type': 'application/json'},
    ));
  }

  Future<List<NoteEntity>> getNotes() async {
    print('[API] GET ${AppConfig.baseUrl}/api/notes — fetching all notes from backend');
    try {
      final response = await _dio.get('/api/notes');
      final data = response.data['data'] as List;
      final notes = data.map((json) => _noteFromJson(json)).toList();
      print('[API] GET ${AppConfig.baseUrl}/api/notes — received ${notes.length} notes');
      return notes;
    } on DioException catch (e) {
      print('[API] GET ${AppConfig.baseUrl}/api/notes — FAILED: ${e.message}');
      return [];
    }
  }

  Future<void> upsertNote(NoteEntity note) async {
    final jsonData = _noteToJson(note);
    try {
      await _dio.post('/api/notes', data: jsonData);
      print('[API] POST /api/notes — success id=${note.id}');
    } on DioException catch (e) {
      print('[API] POST ${AppConfig.baseUrl}/api/notes — FAILED: ${e.message}');
    }
  }

  Future<void> deleteNote(String id) async {
    print('[API] DELETE ${AppConfig.baseUrl}/api/notes/$id — deleting note');
    try {
      await _dio.delete('/api/notes/$id');
      print('[API] DELETE /api/notes/$id — success');
    } on DioException catch (e) {
      print('[API] DELETE ${AppConfig.baseUrl}/api/notes/$id — FAILED: ${e.message}');
    }
  }

  Future<String?> uploadImage(String filePath) async {
    print('[API] POST ${AppConfig.baseUrl}/api/uploads/image — uploading image: $filePath');
    try {
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(filePath,
            filename: filePath.split('/').last),
      });
      final response = await _dio.post('/api/uploads/image', data: formData);
      final url = '${AppConfig.baseUrl}${response.data['data']['url']}';
      print('[API] POST /api/uploads/image — success url=$url');
      return url;
    } on DioException catch (e) {
      print('[API] POST ${AppConfig.baseUrl}/api/uploads/image — FAILED: ${e.message}');
      return null;
    }
  }

  Future<String?> uploadAudio(String filePath) async {
    print('[API] POST ${AppConfig.baseUrl}/api/uploads/audio — uploading audio: $filePath');
    try {
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(filePath,
            filename: filePath.split('/').last),
      });
      final response = await _dio.post('/api/uploads/audio', data: formData);
      final url = '${AppConfig.baseUrl}${response.data['data']['url']}';
      print('[API] POST /api/uploads/audio — success url=$url');
      return url;
    } on DioException catch (e) {
      print('[API] POST ${AppConfig.baseUrl}/api/uploads/audio — FAILED: ${e.message}');
      return null;
    }
  }

  Map<String, dynamic> _noteToJson(NoteEntity note) => {
        'id': note.id,
        'title': note.title,
        'body': note.body,
        'imageUrl': note.imageUrl,
        'bgColor': note.bgColor,
        'fontFamily': note.fontFamily,
        'audioUrl': note.audioUrl,
        'isPinned': note.isPinned,
        'createdAt': note.createdAt.toUtc().toIso8601String(),
        'updatedAt': note.updatedAt.toUtc().toIso8601String(),
      };

  NoteEntity _noteFromJson(Map<String, dynamic> json) => NoteEntity(
        id: json['id'],
        title: json['title'],
        body: json['body'],
        imageUrl: json['imageUrl'],
        bgColor: json['bgColor'],
        fontFamily: json['fontFamily'],
        audioUrl: json['audioUrl'],
        isPinned: json['isPinned'],
        createdAt: DateTime.parse(json['createdAt']),
        updatedAt: DateTime.parse(json['updatedAt']),
      );
}
