import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('zh')
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'LexiRead'**
  String get appName;

  /// No description provided for @homeLibrary.
  ///
  /// In en, this message translates to:
  /// **'Library'**
  String get homeLibrary;

  /// No description provided for @homeVocab.
  ///
  /// In en, this message translates to:
  /// **'Vocab'**
  String get homeVocab;

  /// No description provided for @homeProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get homeProfile;

  /// No description provided for @searchWebTitle.
  ///
  /// In en, this message translates to:
  /// **'Search Web'**
  String get searchWebTitle;

  /// No description provided for @searchLocalTitle.
  ///
  /// In en, this message translates to:
  /// **'Search Library'**
  String get searchLocalTitle;

  /// No description provided for @searchHint.
  ///
  /// In en, this message translates to:
  /// **'Title, Author, or keyword...'**
  String get searchHint;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @settingsLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get settingsLanguage;

  /// No description provided for @settingsLanguageSystem.
  ///
  /// In en, this message translates to:
  /// **'Follow System'**
  String get settingsLanguageSystem;

  /// No description provided for @settingsLanguageEn.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get settingsLanguageEn;

  /// No description provided for @settingsLanguageZh.
  ///
  /// In en, this message translates to:
  /// **'简体中文'**
  String get settingsLanguageZh;

  /// No description provided for @settingsTheme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get settingsTheme;

  /// No description provided for @settingsAbout.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get settingsAbout;

  /// No description provided for @settingsLogout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get settingsLogout;

  /// No description provided for @loginTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome to LexiRead'**
  String get loginTitle;

  /// No description provided for @loginEmailHint.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get loginEmailHint;

  /// No description provided for @loginPasswordHint.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get loginPasswordHint;

  /// No description provided for @loginButton.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get loginButton;

  /// No description provided for @registerButton.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get registerButton;

  /// No description provided for @readerSettings.
  ///
  /// In en, this message translates to:
  /// **'Reader Settings'**
  String get readerSettings;

  /// No description provided for @readerFontSize.
  ///
  /// In en, this message translates to:
  /// **'Font Size'**
  String get readerFontSize;

  /// No description provided for @readerLineHeight.
  ///
  /// In en, this message translates to:
  /// **'Line Height'**
  String get readerLineHeight;

  /// No description provided for @readerShowTranslation.
  ///
  /// In en, this message translates to:
  /// **'Show Translation'**
  String get readerShowTranslation;

  /// No description provided for @readerTableOfContents.
  ///
  /// In en, this message translates to:
  /// **'Table of Contents'**
  String get readerTableOfContents;

  /// No description provided for @vocabMyVocab.
  ///
  /// In en, this message translates to:
  /// **'My Vocabulary'**
  String get vocabMyVocab;

  /// No description provided for @vocabSearch.
  ///
  /// In en, this message translates to:
  /// **'Search words...'**
  String get vocabSearch;

  /// No description provided for @vocabEmpty.
  ///
  /// In en, this message translates to:
  /// **'No vocabulary yet. Start reading and tap words to add them!'**
  String get vocabEmpty;

  /// No description provided for @filterAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get filterAll;

  /// No description provided for @filterClassic.
  ///
  /// In en, this message translates to:
  /// **'Classic'**
  String get filterClassic;

  /// No description provided for @filterHorror.
  ///
  /// In en, this message translates to:
  /// **'Horror'**
  String get filterHorror;

  /// No description provided for @filterFantasy.
  ///
  /// In en, this message translates to:
  /// **'Fantasy'**
  String get filterFantasy;

  /// No description provided for @filterMystery.
  ///
  /// In en, this message translates to:
  /// **'Mystery'**
  String get filterMystery;

  /// No description provided for @filterRomance.
  ///
  /// In en, this message translates to:
  /// **'Romance'**
  String get filterRomance;

  /// No description provided for @filterAdventure.
  ///
  /// In en, this message translates to:
  /// **'Adventure'**
  String get filterAdventure;

  /// No description provided for @filterSciFi.
  ///
  /// In en, this message translates to:
  /// **'Sci-Fi'**
  String get filterSciFi;

  /// No description provided for @filterOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get filterOther;

  /// No description provided for @filterDifficulty.
  ///
  /// In en, this message translates to:
  /// **'Difficulty'**
  String get filterDifficulty;

  /// No description provided for @filterReadingStatus.
  ///
  /// In en, this message translates to:
  /// **'Reading Status'**
  String get filterReadingStatus;

  /// No description provided for @statusNotStarted.
  ///
  /// In en, this message translates to:
  /// **'Not Started'**
  String get statusNotStarted;

  /// No description provided for @statusReading.
  ///
  /// In en, this message translates to:
  /// **'Reading'**
  String get statusReading;

  /// No description provided for @statusFinished.
  ///
  /// In en, this message translates to:
  /// **'Finished'**
  String get statusFinished;

  /// No description provided for @filterReset.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get filterReset;

  /// No description provided for @filterClear.
  ///
  /// In en, this message translates to:
  /// **'Clear Filters'**
  String get filterClear;

  /// No description provided for @filterEmpty.
  ///
  /// In en, this message translates to:
  /// **'No books found matching your filters.'**
  String get filterEmpty;

  /// No description provided for @searchBooksHint.
  ///
  /// In en, this message translates to:
  /// **'Search your books...'**
  String get searchBooksHint;

  /// No description provided for @filterTitle.
  ///
  /// In en, this message translates to:
  /// **'Filters'**
  String get filterTitle;

  /// No description provided for @continueReading.
  ///
  /// In en, this message translates to:
  /// **'Continue Reading'**
  String get continueReading;

  /// No description provided for @bookDetailAuthor.
  ///
  /// In en, this message translates to:
  /// **'Author'**
  String get bookDetailAuthor;

  /// No description provided for @bookDetailCategory.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get bookDetailCategory;

  /// No description provided for @bookDetailDifficulty.
  ///
  /// In en, this message translates to:
  /// **'Difficulty'**
  String get bookDetailDifficulty;

  /// No description provided for @bookDetailChapters.
  ///
  /// In en, this message translates to:
  /// **'Chapters'**
  String get bookDetailChapters;

  /// No description provided for @bookDetailDescription.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get bookDetailDescription;

  /// No description provided for @bookDetailStartReading.
  ///
  /// In en, this message translates to:
  /// **'Start Reading'**
  String get bookDetailStartReading;

  /// No description provided for @bookDetailContinueReading.
  ///
  /// In en, this message translates to:
  /// **'Continue Reading'**
  String get bookDetailContinueReading;

  /// No description provided for @bookDetailReadAgain.
  ///
  /// In en, this message translates to:
  /// **'Read Again'**
  String get bookDetailReadAgain;

  /// No description provided for @bookDetailChapterProgress.
  ///
  /// In en, this message translates to:
  /// **'Chapter {current} of {total}'**
  String bookDetailChapterProgress(int current, int total);

  /// No description provided for @bookDetailSource.
  ///
  /// In en, this message translates to:
  /// **'Source'**
  String get bookDetailSource;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
