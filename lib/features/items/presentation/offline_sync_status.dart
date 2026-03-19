import 'package:flutter/material.dart';

import '../../../core/constants/app_strings.dart';

enum OfflineSyncStatus {
  idle,
  syncing,
  ready,
  error;

  String get label {
    switch (this) {
      case OfflineSyncStatus.idle:
        return AppStrings.offlineStatusIdle;
      case OfflineSyncStatus.syncing:
        return AppStrings.offlineStatusSyncing;
      case OfflineSyncStatus.ready:
        return AppStrings.offlineStatusReady;
      case OfflineSyncStatus.error:
        return AppStrings.offlineStatusError;
    }
  }

  IconData get icon {
    switch (this) {
      case OfflineSyncStatus.idle:
        return Icons.cloud_queue_outlined;
      case OfflineSyncStatus.syncing:
        return Icons.sync;
      case OfflineSyncStatus.ready:
        return Icons.cloud_done_outlined;
      case OfflineSyncStatus.error:
        return Icons.cloud_off_outlined;
    }
  }

  Color color(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    switch (this) {
      case OfflineSyncStatus.idle:
        return colorScheme.outline;
      case OfflineSyncStatus.syncing:
        return colorScheme.primary;
      case OfflineSyncStatus.ready:
        return colorScheme.tertiary;
      case OfflineSyncStatus.error:
        return colorScheme.error;
    }
  }
}
