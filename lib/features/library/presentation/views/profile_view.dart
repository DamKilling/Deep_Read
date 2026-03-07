import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../auth/providers/auth_provider.dart';
import '../../providers/library_provider.dart';
import '../../../../core/providers/locale_provider.dart';
import 'package:lexiread/l10n/app_localizations.dart';

class ProfileView extends ConsumerWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authStateChangesProvider).value?.session?.user;
    final progress = ref.watch(userProgressProvider);
    final locale = ref.watch(localeProvider);
    final l10n = AppLocalizations.of(context)!;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 32),
          // Avatar
          CircleAvatar(
            radius: 50,
            backgroundColor: Theme.of(context).primaryColor,
            child: Text(
              user?.email?.substring(0, 1).toUpperCase() ?? 'U',
              style: const TextStyle(fontSize: 32, color: Colors.white),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            user?.email ?? 'User Email',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 32),
          // Stats Row
          progress.when(
            data: (data) => Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildStatItem(context, '${data.consecutiveDays}', 'Days Streak'),
                _buildStatItem(context, '${data.totalWordsRead}', 'Words Read'),
                _buildStatItem(context, '${data.booksCompleted}', 'Books Finished'),
              ],
            ),
            loading: () => const CircularProgressIndicator(),
            error: (error, stack) => Text('Failed to load stats: $error'),
          ),
          const SizedBox(height: 48),
          // Actions
          ListTile(
            leading: const Icon(Icons.language),
            title: Text(l10n.settingsLanguage),
            trailing: DropdownButton<String>(
              value: locale?.languageCode ?? 'system',
              underline: const SizedBox(),
              items: [
                DropdownMenuItem(
                  value: 'system',
                  child: Text(l10n.settingsLanguageSystem),
                ),
                DropdownMenuItem(
                  value: 'en',
                  child: Text(l10n.settingsLanguageEn),
                ),
                DropdownMenuItem(
                  value: 'zh',
                  child: Text(l10n.settingsLanguageZh),
                ),
              ],
              onChanged: (String? newValue) {
                if (newValue == 'system') {
                  ref.read(localeProvider.notifier).setLocale(null);
                } else if (newValue != null) {
                  ref.read(localeProvider.notifier).setLocale(Locale(newValue));
                }
              },
            ),
          ),
          ListTile(
            leading: const Icon(Icons.help_outline),
            title: Text(l10n.settingsAbout),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              // TODO: Help
            },
          ),
          const Divider(height: 32),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: Text(
              l10n.settingsLogout,
              style: const TextStyle(color: Colors.red),
            ),
            onTap: () {
              ref.read(authNotifierProvider.notifier).signOut();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(BuildContext context, String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }
}
