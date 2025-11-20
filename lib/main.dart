import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trig_sct/src/config/theme/app_theme_provider.dart';
import 'package:trig_sct/src/features/settings/application/locale_provider.dart';
import 'package:trig_sct/src/localization/app_localizations.dart';
import 'package:trig_sct/src/router.dart';

void main() {
  runApp(const ProviderScope(child: TrigSCTApp()));
}

class TrigSCTApp extends ConsumerWidget {
  const TrigSCTApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeTheme = ref.watch(activeThemeProvider);
    final locale = ref.watch(localeProvider);

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'SOH CAH TOA',
      theme: activeTheme,
      locale: locale,
      routerConfig: router,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
    );
  }
}
