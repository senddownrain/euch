import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/widgets/confirmation_dialog.dart';
import '../../../core/widgets/snackbar_helper.dart';
import '../../../l10n/app_localizations.dart';
import '../../items/data/items_repository.dart';
import '../../items/presentation/items_controller.dart';
import '../../../core/services/share_service.dart';

class AdminScreen extends ConsumerStatefulWidget {
  const AdminScreen({super.key});

  @override
  ConsumerState<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends ConsumerState<AdminScreen> {
  ImportMode _importMode = ImportMode.addOnly;
  bool _busy = false;

  Future<void> _export(BuildContext context) async {
    final l10n = AppLocalizations.of(context);
    setState(() => _busy = true);
    try {
      final file = await ref.read(itemsRepositoryProvider).exportToJson();
      await ref.read(shareServiceProvider).shareFile(file, text: l10n.exportSuccess);
      if (mounted) SnackbarHelper.show(context, l10n.exportSuccess);
    } catch (_) {
      if (mounted) SnackbarHelper.show(context, l10n.genericError, isError: true);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _import(BuildContext context) async {
    final l10n = AppLocalizations.of(context);
    setState(() => _busy = true);
    try {
      final parsed = await ref.read(itemsRepositoryProvider).parseImportFile();
      final confirmed = await showConfirmationDialog(
        context: context,
        title: l10n.confirmImportTitle,
        content: l10n.confirmImportBody(parsed.length),
        cancelLabel: l10n.cancel,
        confirmLabel: l10n.confirm,
      );
      if (!confirmed) return;
      final imported = await ref.read(itemsRepositoryProvider).importItems(parsed, _importMode);
      if (mounted) SnackbarHelper.show(context, '${l10n.importSuccess}: $imported');
    } catch (_) {
      if (mounted) SnackbarHelper.show(context, l10n.invalidJson, isError: true);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final items = ref.watch(allItemsProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.admin)),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          items.when(
            data: (list) => Text(l10n.itemsCount(list.length)),
            error: (_, _) => Text(l10n.genericError),
            loading: () => Text(l10n.loading),
          ),
          const SizedBox(height: 20),
          SegmentedButton<ImportMode>(
            segments: [
              ButtonSegment(value: ImportMode.addOnly, label: Text(l10n.importAddOnly)),
              ButtonSegment(value: ImportMode.overwrite, label: Text(l10n.importOverwrite)),
            ],
            selected: {_importMode},
            onSelectionChanged: _busy ? null : (value) => setState(() => _importMode = value.first),
          ),
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: _busy ? null : () => _export(context),
            icon: const Icon(Icons.ios_share_outlined),
            label: Text(l10n.exportJson),
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: _busy ? null : () => _import(context),
            icon: const Icon(Icons.upload_file_outlined),
            label: Text(l10n.importJson),
          ),
          if (_busy) ...[
            const SizedBox(height: 20),
            const LinearProgressIndicator(),
          ],
        ],
      ),
    );
  }
}
