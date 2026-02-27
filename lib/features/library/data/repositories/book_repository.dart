import 'package:supabase_flutter/supabase_flutter.dart' as supa;
import '../../domain/models/book.dart';

class BookRepository {
  final supa.SupabaseClient _client;

  BookRepository(this._client);

  Future<List<Book>> getBooks() async {
    final response = await _client.from('books').select().order('created_at');
    
    return (response as List<dynamic>).map((json) {
      return Book(
        id: json['id'] as String,
        title: json['title'] as String,
        author: json['author'] as String,
        coverUrl: json['cover_url'] as String? ?? '',
        difficultyLevel: json['difficulty_level'] as String? ?? 'N/A',
        totalChapters: json['total_chapters'] as int? ?? 0,
        description: json['description'] as String? ?? '',
      );
    }).toList();
  }
}
