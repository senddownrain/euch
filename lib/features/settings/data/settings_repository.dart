import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../domain/app_settings.dart';

final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('SharedPreferences must be overridden in main.dart');
});

final settingsRepositoryProvider = Provider<SettingsRepository>((ref) {
  return SettingsRepository(ref.watch(sharedPreferencesProvider));
});

class SettingsRepository {
  SettingsRepository(this._preferences);

  final SharedPreferences _preferences;

  static const _themeModeKey = 'themeMode';
  static const _keepScreenOnKey = 'keepScreenOn';
  static const _fontFamilyKey = 'fontFamily';
  static const _fontSizeKey = 'fontSize';
  static const _viewModeKey = 'viewMode';
  static const _pinnedIdsKey = 'pinnedIds';

  AppSettings load() {
    final themeModeName = _preferences.getString(_themeModeKey);
    final themeMode = ThemeMode.values.firstWhere(
      (mode) => mode.name == themeModeName,
      orElse: () => ThemeMode.system,
    );

    final viewModeName = _preferences.getString(_viewModeKey);
    final viewMode = ItemListViewMode.values.firstWhere(
      (mode) => mode.name == viewModeName,
      orElse: () => ItemListViewMode.compact,
    );

    return AppSettings(
      themeMode: themeMode,
      keepScreenOn: _preferences.getBool(_keepScreenOnKey) ?? false,
      fontFamily: _preferences.getString(_fontFamilyKey) ?? 'System',
      fontSizeMultiplier: _preferences.getDouble(_fontSizeKey) ?? 1,
      viewMode: viewMode,
      pinnedIds: _preferences.getStringList(_pinnedIdsKey) ?? const [],
    );
  }

  Future<void> save(AppSettings settings) async {
    await Future.wait([
      _preferences.setString(_themeModeKey, settings.themeMode.name),
      _preferences.setBool(_keepScreenOnKey, settings.keepScreenOn),
      _preferences.setString(_fontFamilyKey, settings.fontFamily),
      _preferences.setDouble(_fontSizeKey, settings.fontSizeMultiplier),
      _preferences.setString(_viewModeKey, settings.viewMode.name),
      _preferences.setStringList(_pinnedIdsKey, settings.pinnedIds),
    ]);
  }
}
