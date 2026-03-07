@echo off
git status
git add lib/features/reader/presentation/screens/reader_screen.dart
git add lib/features/reader/data/repositories/chapter_repository.dart
git add ingestion/text_cleaner.py
git add ingestion/chapter_parser.py
git commit -m "fix(reader): ensure accurate chapter title and correct TOC sorting order

- Removed newlines cleanup before splitting chapters to fix TOC over-merging into single line
- Allowed proper splitting of chapter chunks, skipping fragments smaller than 100/200 chars
- Added frontend fallback to truncate abnormally long legacy chapter titles (TOC merges)
- Fixed chapter list sorting to ensure ascending order by chapter_number"
git push
