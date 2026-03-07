import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../domain/models/reader_settings.dart';

final readerSettingsProvider = StateNotifierProvider<ReaderSettingsNotifier, ReaderSettings>((ref) {
  return ReaderSettingsNotifier();
});

class ReaderSettingsNotifier extends StateNotifier<ReaderSettings> {
  ReaderSettingsNotifier() : super(const ReaderSettings()) {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    state = ReaderSettings(
      fontSize: prefs.getDouble('fontSize') ?? 20.0,
      lineHeight: prefs.getDouble('lineHeight') ?? 1.8,
      showTranslation: prefs.getBool('showTranslation') ?? true,
      theme: prefs.getString('theme') ?? 'light',
    );
  }

  Future<void> updateFontSize(double size) async {
    state = state.copyWith(fontSize: size);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('fontSize', size);
  }

  Future<void> updateLineHeight(double height) async {
    state = state.copyWith(lineHeight: height);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('lineHeight', height);
  }
  
  Future<void> toggleTranslation(bool show) async {
    state = state.copyWith(showTranslation: show);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('showTranslation', show);
  }
}
