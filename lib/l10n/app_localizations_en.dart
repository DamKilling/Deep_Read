// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'LexiRead';

  @override
  String get homeLibrary => 'Library';

  @override
  String get homeVocab => 'Vocab';

  @override
  String get homeProfile => 'Profile';

  @override
  String get searchWebTitle => 'Search Web';

  @override
  String get searchLocalTitle => 'Search Library';

  @override
  String get searchHint => 'Title, Author, or keyword...';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsLanguage => 'Language';

  @override
  String get settingsLanguageSystem => 'Follow System';

  @override
  String get settingsLanguageEn => 'English';

  @override
  String get settingsLanguageZh => '简体中文';

  @override
  String get settingsTheme => 'Theme';

  @override
  String get settingsAbout => 'About';

  @override
  String get settingsLogout => 'Logout';

  @override
  String get loginTitle => 'Welcome to LexiRead';

  @override
  String get loginEmailHint => 'Email';

  @override
  String get loginPasswordHint => 'Password';

  @override
  String get loginButton => 'Sign In';

  @override
  String get registerButton => 'Create Account';

  @override
  String get readerSettings => 'Reader Settings';

  @override
  String get readerFontSize => 'Font Size';

  @override
  String get readerLineHeight => 'Line Height';

  @override
  String get readerShowTranslation => 'Show Translation';

  @override
  String get readerTableOfContents => 'Table of Contents';

  @override
  String get vocabMyVocab => 'My Vocabulary';

  @override
  String get vocabSearch => 'Search words...';

  @override
  String get vocabEmpty =>
      'No vocabulary yet. Start reading and tap words to add them!';

  @override
  String get filterAll => 'All';

  @override
  String get filterClassic => 'Classic';

  @override
  String get filterHorror => 'Horror';

  @override
  String get filterFantasy => 'Fantasy';

  @override
  String get filterMystery => 'Mystery';

  @override
  String get filterRomance => 'Romance';

  @override
  String get filterAdventure => 'Adventure';

  @override
  String get filterSciFi => 'Sci-Fi';

  @override
  String get filterOther => 'Other';

  @override
  String get filterDifficulty => 'Difficulty';

  @override
  String get filterReadingStatus => 'Reading Status';

  @override
  String get statusNotStarted => 'Not Started';

  @override
  String get statusReading => 'Reading';

  @override
  String get statusFinished => 'Finished';

  @override
  String get filterReset => 'Reset';

  @override
  String get filterClear => 'Clear Filters';

  @override
  String get filterEmpty => 'No books found matching your filters.';

  @override
  String get searchBooksHint => 'Search your books...';

  @override
  String get filterTitle => 'Filters';

  @override
  String get continueReading => 'Continue Reading';

  @override
  String get bookDetailAuthor => 'Author';

  @override
  String get bookDetailCategory => 'Category';

  @override
  String get bookDetailDifficulty => 'Difficulty';

  @override
  String get bookDetailChapters => 'Chapters';

  @override
  String get bookDetailDescription => 'Description';

  @override
  String get bookDetailStartReading => 'Start Reading';

  @override
  String get bookDetailContinueReading => 'Continue Reading';

  @override
  String get bookDetailReadAgain => 'Read Again';

  @override
  String bookDetailChapterProgress(int current, int total) {
    return 'Chapter $current of $total';
  }

  @override
  String get bookDetailSource => 'Source';
}
