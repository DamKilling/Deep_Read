import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lexiread/l10n/app_localizations.dart';

import '../../domain/models/book.dart';
import '../../providers/library_provider.dart';

class BookDetailScreen extends ConsumerWidget {
  final String bookId;

  const BookDetailScreen({super.key, required this.bookId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final booksAsync = ref.watch(libraryBooksProvider);
    final progressMapAsync = ref.watch(bookProgressMapProvider);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: const Text(''), // Maybe empty or book title if needed
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: booksAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
        data: (books) {
          final book = books.firstWhere(
            (b) => b.id == bookId,
            orElse: () => Book(
              id: '', title: 'Unknown', author: '', 
              coverUrl: '', description: '', difficultyLevel: '', 
              totalChapters: 0,
            ),
          );

          if (book.id.isEmpty) {
            return const Center(child: Text('Book not found'));
          }

          return progressMapAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, stack) => Center(child: Text('Error: $err')),
            data: (progressMap) {
              final currentChapter = progressMap[book.id];
              final isNotStarted = currentChapter == null;
              final isFinished = currentChapter != null && currentChapter >= book.totalChapters && book.totalChapters > 0;
              final displayChapter = currentChapter ?? 1;

              String buttonText = l10n.bookDetailStartReading;
              if (isFinished) {
                buttonText = l10n.bookDetailReadAgain;
              } else if (!isNotStarted) {
                buttonText = l10n.bookDetailContinueReading;
              }

              return SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Cover
                    Container(
                      width: 140,
                      height: 210,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 16,
                            offset: const Offset(0, 8),
                          )
                        ],
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: book.coverUrl.isNotEmpty
                          ? Image.network(book.coverUrl, fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                              return Icon(Icons.book, size: 64, color: Theme.of(context).colorScheme.onSurface.withOpacity(0.2));
                            })
                          : Icon(Icons.book, size: 64, color: Theme.of(context).colorScheme.onSurface.withOpacity(0.2)),
                    ),
                    const SizedBox(height: 24),
                    // Title
                    Text(
                      book.title,
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    // Author
                    Text(
                      book.author,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Stats Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildStatItem(context, l10n.bookDetailCategory, book.displayCategory),
                        _buildStatItem(context, l10n.bookDetailDifficulty, book.difficultyLevel),
                        _buildStatItem(context, l10n.bookDetailChapters, '${book.totalChapters}'),
                      ],
                    ),
                    const SizedBox(height: 32),
                    // Action Button
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: () {
                          // Determine the chapter to start from
                          int targetChapter = displayChapter;
                          if (isFinished) {
                            targetChapter = 1; // Start over if finished
                          }
                          context.push('/reader/${book.id}/$targetChapter');
                        },
                        style: FilledButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Column(
                          children: [
                            Text(
                              buttonText,
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            if (!isNotStarted && !isFinished)
                              Text(
                                l10n.bookDetailChapterProgress(displayChapter, book.totalChapters),
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.8),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    // Description
                    if (book.description.isNotEmpty) ...[
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          l10n.bookDetailDescription,
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          book.description,
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            height: 1.6,
                            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.8),
                          ),
                        ),
                      ),
                    ],
                    const SizedBox(height: 24),
                    // Source
                    if (book.source != null && book.source!.isNotEmpty) ...[
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          '${l10n.bookDetailSource}: ${book.source}',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                          ),
                        ),
                      ),
                    ]
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildStatItem(BuildContext context, String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
          ),
        ),
      ],
    );
  }
}
