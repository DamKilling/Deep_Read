import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:supabase_flutter/supabase_flutter.dart';
import 'core/constants/app_constants.dart';

import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'l10n/app_localizations.dart';
import 'core/providers/locale_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Supabase with placeholders.
  // IMPORTANT: The user must replace these with real credentials from the Supabase dashboard.
  try {
    await Supabase.initialize(
      url: AppConstants.supabaseUrl,
      anonKey: AppConstants.supabaseAnonKey,
    );
  } catch (e) {
    debugPrint('Supabase init failed (using mock config?): $e');
  }

  final prefs = await SharedPreferences.getInstance();

  // Log configurations on startup for easier debugging
  debugPrint('--- LexiRead Configuration ---');
  debugPrint('Backend API URL: ${AppConstants.backendApiUrl}');
  debugPrint('Supabase URL configured: ${AppConstants.supabaseUrl.isNotEmpty}');
  debugPrint('------------------------------');

  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
      ],
      child: const DeepReadApp(),
    ),
  );
}

class DeepReadApp extends ConsumerWidget {
  const DeepReadApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);
    final locale = ref.watch(localeProvider);

    return MaterialApp.router(
      title: 'LexiRead',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system, // Auto switch based on OS
      routerConfig: router,
      debugShowCheckedModeBanner: false,
      locale: locale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
    );
  }
}
