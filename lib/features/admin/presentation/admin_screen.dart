import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/services/share_service.dart';
import '../../../core/widgets/confirmation_dialog.dart';
import '../../../core/widgets/snackbar_helper.dart';
import '../../items/data/items_repository.dart';
import '../../items/presentation/items_controller.dart';

class AdminScreen extends ConsumerStatefulWidget {
  const AdminScreen({super.key});

  @override
  ConsumerState<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends ConsumerState<AdminScreen> {
  ImportMode _importMode = ImportMode.addOnly;
  bool _busy = false;

  Future<void> _export(BuildContext context) async {
    setState(() => _busy = true);
    try {
      final file = await ref.read(itemsRepositoryProvider).exportToJson();
      await ref.read(shareServiceProvider).shareFile(file, text: AppStrings.exportSuccess);
      if (mounted) SnackbarHelper.show(context, AppStrings.exportSuccess);
    } catch (_) {
      if (mounted) SnackbarHelper.show(context, AppStrings.genericError, isError: true);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _import(BuildContext context) async {
    setState(() => _busy = true);
    try {
      final parsed = await ref.read(itemsRepositoryProvider).parseImportFile();
      final confirmed = await showConfirmationDialog(
        context: context,
        title: AppStrings.confirm,
        content: AppStrings.confirmImportBody(parsed.length),
        cancelLabel: AppStrings.cancel,
        confirmLabel: AppStrings.confirm,
      );
      if (!confirmed) return;
      final imported = await ref.read(itemsRepositoryProvider).importItems(parsed, _importMode);
      if (mounted) SnackbarHelper.show(context, '${AppStrings.importSuccess}: $imported');
    } catch (_) {
      if (mounted) SnackbarHelper.show(context, AppStrings.invalidJson, isError: true);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final items = ref.watch(allItemsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.admin)),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          items.when(
            data: (list) => Text(AppStrings.itemsCount(list.length)),
            error: (_, __) => const Text(AppStrings.genericError),
            loading: () => const Text(AppStrings.loading),
          ),
          const SizedBox(height: 20),
          SegmentedButton<ImportMode>(
            segments: [
              ButtonSegment(value: ImportMode.addOnly, label: Text(AppStrings.importAddOnly)),
              ButtonSegment(value: ImportMode.overwrite, label: Text(AppStrings.importOverwrite)),
            ],
            selected: {_importMode},
            onSelectionChanged: _busy ? null : (value) => setState(() => _importMode = value.first),
          ),
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: _busy ? null : () => _export(context),
            icon: const Icon(Icons.ios_share_outlined),
            label: const Text(AppStrings.exportJson),
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: _busy ? null : () => _import(context),
            icon: const Icon(Icons.upload_file_outlined),
            label: const Text(AppStrings.importJson),
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
