import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:trig_sct/src/config/theme/app_theme_provider.dart';
import 'package:trig_sct/src/features/settings/application/locale_provider.dart';
import 'package:trig_sct/src/localization/app_localizations.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(themeProvider);
    final themeNotifier = ref.read(themeProvider.notifier);
    final locale = ref.watch(localeProvider);
    final localeNotifier = ref.read(localeProvider.notifier);
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.pageSettingsTitle),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/'),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(localizations.dark),
                Switch(
                  value: theme.isDarkMode,
                  onChanged: (value) => themeNotifier.toggleTheme(),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(localizations.theme),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: ElevatedButton(
                      onPressed: () => themeNotifier.setTheme(0),
                      child: Text(localizations.theme1),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: ElevatedButton(
                      onPressed: () => themeNotifier.setTheme(1),
                      child: Text(localizations.theme2),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: ElevatedButton(
                      onPressed: () => themeNotifier.setTheme(2),
                      child: Text(localizations.theme3),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            Text(localizations.language),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: ElevatedButton(
                      onPressed: () =>
                          localeNotifier.setLocale(const Locale('en')),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: locale.languageCode == 'en'
                            ? Theme.of(context).colorScheme.primary
                            : null,
                      ),
                      child: Text(localizations.english),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: ElevatedButton(
                      onPressed: () =>
                          localeNotifier.setLocale(const Locale('de')),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: locale.languageCode == 'de'
                            ? Theme.of(context).colorScheme.primary
                            : null,
                      ),
                      child: Text(localizations.german),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: ElevatedButton(
                      onPressed: () =>
                          localeNotifier.setLocale(const Locale('nl')),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: locale.languageCode == 'nl'
                            ? Theme.of(context).colorScheme.primary
                            : null,
                      ),
                      child: Text(localizations.dutch),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
