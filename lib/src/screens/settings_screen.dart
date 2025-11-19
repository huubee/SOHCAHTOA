import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myapp/src/config/theme/app_theme_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(themeProvider);
    final themeNotifier = ref.read(themeProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Dark Mode'),
                Switch(
                  value: theme.isDarkMode,
                  onChanged: (value) => themeNotifier.toggleTheme(),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text('Theme'),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () => themeNotifier.setTheme(0),
                  child: const Text('Theme 1'),
                ),
                ElevatedButton(
                  onPressed: () => themeNotifier.setTheme(1),
                  child: const Text('Theme 2'),
                ),
                ElevatedButton(
                  onPressed: () => themeNotifier.setTheme(2),
                  child: const Text('Theme 3'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
