import 'package:flutter/material.dart';

enum ItemListViewMode { cards, compact }

class AppSettings {
  const AppSettings({
    this.themeMode = ThemeMode.system,
    this.keepScreenOn = false,
    this.fontFamily = 'System',
    this.fontSizeMultiplier = 1,
    this.viewMode = ItemListViewMode.compact,
    this.pinnedIds = const [],
  });

  final ThemeMode themeMode;
  final bool keepScreenOn;
  final String fontFamily;
  final double fontSizeMultiplier;
  final ItemListViewMode viewMode;
  final List<String> pinnedIds;

  AppSettings copyWith({
    ThemeMode? themeMode,
    bool? keepScreenOn,
    String? fontFamily,
    double? fontSizeMultiplier,
    ItemListViewMode? viewMode,
    List<String>? pinnedIds,
  }) {
    return AppSettings(
      themeMode: themeMode ?? this.themeMode,
      keepScreenOn: keepScreenOn ?? this.keepScreenOn,
      fontFamily: fontFamily ?? this.fontFamily,
      fontSizeMultiplier: fontSizeMultiplier ?? this.fontSizeMultiplier,
      viewMode: viewMode ?? this.viewMode,
      pinnedIds: pinnedIds ?? this.pinnedIds,
    );
  }
}
