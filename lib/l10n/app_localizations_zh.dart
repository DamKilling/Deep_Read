// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appName => 'LexiRead';

  @override
  String get homeLibrary => '书库';

  @override
  String get homeVocab => '生词本';

  @override
  String get homeProfile => '我的';

  @override
  String get searchWebTitle => '搜索网络书库';

  @override
  String get searchLocalTitle => '搜索本地书库';

  @override
  String get searchHint => '书名、作者或关键词...';

  @override
  String get settingsTitle => '设置';

  @override
  String get settingsLanguage => '语言';

  @override
  String get settingsLanguageSystem => '跟随系统';

  @override
  String get settingsLanguageEn => 'English';

  @override
  String get settingsLanguageZh => '简体中文';

  @override
  String get settingsTheme => '主题';

  @override
  String get settingsAbout => '关于';

  @override
  String get settingsLogout => '退出登录';

  @override
  String get loginTitle => '欢迎使用 LexiRead';

  @override
  String get loginEmailHint => '邮箱';

  @override
  String get loginPasswordHint => '密码';

  @override
  String get loginButton => '登录';

  @override
  String get registerButton => '创建账号';

  @override
  String get readerSettings => '阅读设置';

  @override
  String get readerFontSize => '字体大小';

  @override
  String get readerLineHeight => '行高';

  @override
  String get readerShowTranslation => '显示翻译';

  @override
  String get readerTableOfContents => '目录';

  @override
  String get vocabMyVocab => '我的生词本';

  @override
  String get vocabSearch => '搜索单词...';

  @override
  String get vocabEmpty => '暂无生词。开始阅读并点击单词来添加吧！';
}
