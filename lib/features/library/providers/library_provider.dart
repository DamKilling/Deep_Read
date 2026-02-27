import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../auth/providers/auth_provider.dart';
import '../data/repositories/book_repository.dart';
import '../data/repositories/user_repository.dart';
import '../domain/models/book.dart';
import '../domain/models/user_progress.dart';

// --- Repositories ---

final bookRepositoryProvider = Provider<BookRepository>((ref) {
  return BookRepository(Supabase.instance.client);
});

final userRepositoryProvider = Provider<UserRepository>((ref) {
  return UserRepository(Supabase.instance.client);
});

// --- Async Data Providers ---

final libraryBooksProvider = FutureProvider<List<Book>>((ref) async {
  final repository = ref.watch(bookRepositoryProvider);
  return repository.getBooks();
});

final userProgressProvider = FutureProvider<UserProgress>((ref) async {
  final authState = ref.watch(authStateChangesProvider).value;
  final userId = authState?.session?.user.id;

  if (userId == null) return const UserProgress();

  final repository = ref.watch(userRepositoryProvider);
  return repository.getUserProgress(userId);
});

// Which book is currently being read (still mocking the selection logic for now, but using real data)
final currentReadingBookProvider = FutureProvider<Book?>((ref) async {
  final books = await ref.watch(libraryBooksProvider.future);
  return books.isNotEmpty ? books.first : null;
});
