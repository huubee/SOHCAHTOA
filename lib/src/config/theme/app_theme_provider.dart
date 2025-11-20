import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trig_sct/src/config/theme/app_theme.dart';

final activeThemeProvider = Provider<ThemeData>((ref) {
  final themeNotifier = ref.watch(themeProvider);
  if (themeNotifier.isDarkMode) {
    if (themeNotifier.themeIndex == 0) return AppTheme.darkTheme;
    if (themeNotifier.themeIndex == 1) return AppTheme.darkTheme2;
    return AppTheme.darkTheme3;
  } else {
    if (themeNotifier.themeIndex == 0) return AppTheme.lightTheme;
    if (themeNotifier.themeIndex == 1) return AppTheme.lightTheme2;
    return AppTheme.lightTheme3;
  }
});

final themeProvider = NotifierProvider<ThemeNotifier, ThemeState>(ThemeNotifier.new);

@immutable
class ThemeState {
  final bool isDarkMode;
  final int themeIndex;

  const ThemeState({this.isDarkMode = false, this.themeIndex = 0});

  ThemeState copyWith({bool? isDarkMode, int? themeIndex}) {
    return ThemeState(
      isDarkMode: isDarkMode ?? this.isDarkMode,
      themeIndex: themeIndex ?? this.themeIndex,
    );
  }
}

class ThemeNotifier extends Notifier<ThemeState> {
  @override
  ThemeState build() {
    return const ThemeState();
  }

  void toggleTheme() {
    state = state.copyWith(isDarkMode: !state.isDarkMode);
  }

  void setTheme(int themeIndex) {
    state = state.copyWith(themeIndex: themeIndex);
  }
}
