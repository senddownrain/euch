import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import '../data/settings_repository.dart';
import '../domain/app_settings.dart';

final settingsControllerProvider = NotifierProvider<SettingsController, AppSettings>(
  SettingsController.new,
);

class SettingsController extends Notifier<AppSettings> {
  SettingsRepository get _repository => ref.read(settingsRepositoryProvider);

  @override
  AppSettings build() {
    final settings = _repository.load();
    _applyWakelock(settings.keepScreenOn);
    return settings;
  }

  Future<void> updateThemeMode(ThemeMode value) => _update(state.copyWith(themeMode: value));

  Future<void> updateKeepScreenOn(bool value) async {
    await _applyWakelock(value);
    await _update(state.copyWith(keepScreenOn: value));
  }

  Future<void> updateFontFamily(String value) => _update(state.copyWith(fontFamily: value));

  Future<void> updateFontSize(double value) => _update(state.copyWith(fontSizeMultiplier: value));

  Future<void> updateViewMode(ItemListViewMode value) => _update(state.copyWith(viewMode: value));

  Future<void> togglePin(String itemId) {
    final current = [...state.pinnedIds];
    if (current.contains(itemId)) {
      current.remove(itemId);
    } else {
      current.add(itemId);
    }
    return _update(state.copyWith(pinnedIds: current));
  }

  Future<void> _applyWakelock(bool enabled) {
    return enabled ? WakelockPlus.enable() : WakelockPlus.disable();
  }

  Future<void> _update(AppSettings value) async {
    state = value;
    await _repository.save(value);
  }
}
