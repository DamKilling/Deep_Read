import 'package:supabase_flutter/supabase_flutter.dart' as supa;
import '../../domain/models/user_progress.dart';

class UserRepository {
  final supa.SupabaseClient _client;

  UserRepository(this._client);

  Future<UserProgress> getUserProgress(String userId) async {
    try {
      final response = await _client
          .from('user_progress')
          .select()
          .eq('user_id', userId)
          .maybeSingle();

      if (response == null) {
        // Return default progress if no record exists yet
        return const UserProgress();
      }

      return UserProgress(
        consecutiveDays: response['consecutive_days'] as int? ?? 0,
        totalWordsRead: response['total_words_read'] as int? ?? 0,
        booksCompleted: response['books_completed'] as int? ?? 0,
        currentBookChaptersRead: 0, // This will be calculated from user_book_progress later
      );
    } catch (e) {
      // Fallback for errors
      return const UserProgress();
    }
  }

  // Optionally create default progress when user signs up
  Future<void> initializeUserProgress(String userId) async {
    await _client.from('user_progress').insert({
      'user_id': userId,
      'consecutive_days': 0,
      'total_words_read': 0,
      'books_completed': 0,
    });
  }
}
