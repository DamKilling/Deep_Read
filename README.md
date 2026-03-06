# Deep Read 📚

Deep Read is a production-ready, Apple/X-inspired minimalist English Graded Reading application built with Flutter. It features interactive reading (tap-to-translate, full-sentence translation), a local Vocabulary Book (错词本), and a Supabase backend for managing real books and chapters.

## ✨ Features
- **Minimalist UI/UX:** Clean, monochromatic aesthetics with squircle cards, high contrast, and elegant typography (`Inter` for system, `Lora` for reading).
- **Interactive Reading:** Tap any word to get a dictionary lookup (Free Dictionary API + MyMemory API) with phonetics and examples.
- **Full Sentence Translation:** Click the `G Translate` icon at the end of any sentence to translate the entire context block into Chinese.
- **Smart Text Parsing:** Accurately detects sentence boundaries, ignoring common abbreviations (like `Mr.`, `Mrs.`, `Phd.`, `J. K. Rowling`).
- **Vocabulary Book:** Save unknown words along with their original context sentences. Stored locally using `shared_preferences`.
- **Chapter Navigation:** Pull up the Table of Contents drawer to jump between chapters, or use bottom navigation when finishing a chapter. Generates a beautiful "Completion Poster" to track your progress!

---

## 🛠️ Technical Documentation & Architecture

### 1. Data Ingestion & Formatting (Python ETL)
*Scripts: `clean_and_import.py`, `upload_covers.py`*

**The Challenge:** Project Gutenberg raw text files use "hard wraps" (newlines fixed at ~70 characters) which breaks sentence context and mobile layout.
**Our Solution:** 
- A Python pipeline connects to the Supabase backend via `supabase-py`.
- **Regex Parsing:** Dynamically recognizes `CHAPTER` and `SCENE` tags to support both classic novels and play scripts.
- **Paragraph Re-construction:** Splits by double newlines (`\n\n`) to isolate true paragraphs. Single `\n` characters are swapped with spaces ` ` to reflow text seamlessly.
- **Cover Images:** Automatically provisions public storage buckets on Supabase, uploads local `ebooks/` covers, and associates the URLs to the database.

### 2. Sentence Boundary Detection & Translation
*Files: `text_parser.dart`, `dictionary_service.dart`, `interactive_paragraph.dart`*

**The Challenge:** Simple `.` matching for sentences breaks when encountering common abbreviations (e.g., `Mr.`, `Dr.`), fragmenting translations.
**Our Solution:**
- **Lookbehind Parsing:** `TextParser` checks the preceding token against a local `HashSet` of known abbreviations (`mr`, `mrs`, `dr`, `etc.`) or single-character initials. If matched, it bypasses the sentence break.
- **MyMemory API Integration:** Context-aware full sentence translations. The sentence index tracks identical tokens, reconstructing the string smoothly before the network fetch.

### 3. Reader Typography & UI/UX
*Files: `reader_screen.dart`, `app_theme.dart`*

**The Challenge:** Text felt homogenous; headers and dialog tags lacked typographic hierarchy. Book navigation was linear and tedious.
**Our Solution:**
- **Dynamic Header Formatting:** `InteractiveParagraph` computes context parameters. The first index of any chapter forces a header style (28px bold, centered). It also detects short, all-caps strings (like `SCENE I`) as subtitles automatically.
- **Chapter Navigation:** Rendered a modal bottom sheet Table of Contents driven by a Riverpod `FutureProvider`. Implemented intuitive `Next/Previous Chapter` buttons.

### 4. Vocabulary Notebook
*Files: `vocab_provider.dart`, `vocab_view.dart`*

**Architecture:**
Local persistence implemented with `shared_preferences`. Tapping tokens queries `DictionaryService`. Upon clicking "Add to Vocab", the word, phonetic, definitions, and contextual sentences are persisted to the device and accessible via the global library bottom navigation bar.

---

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (latest stable)
- Supabase Project & Credentials

### Run the App
1. Clone the repository
2. Run `flutter pub get` to install dependencies
3. Update `SUPABASE_URL` and `SUPABASE_ANON_KEY` in `main.dart` with your credentials
4. Run `flutter run`

### Import Books
1. Add `.txt` files to the root directory
2. Update the Python script `clean_and_import.py` with your Supabase Secret Key
3. Run `python clean_and_import.py` to populate your database
