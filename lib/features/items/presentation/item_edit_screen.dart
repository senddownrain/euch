import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/models/item.dart';
import '../../../core/utils/html_utils.dart';
import '../../../core/widgets/loading_indicator.dart';
import '../../../core/widgets/snackbar_helper.dart';
import '../../settings/presentation/settings_controller.dart';
import '../data/items_repository.dart';
import 'items_controller.dart';
import 'widgets/html_editor_field.dart';

class ItemEditScreen extends ConsumerStatefulWidget {
  const ItemEditScreen({super.key, this.itemId});

  final String? itemId;

  @override
  ConsumerState<ItemEditScreen> createState() => _ItemEditScreenState();
}

class _ItemEditScreenState extends ConsumerState<ItemEditScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _htmlController = TextEditingController();
  final _tagController = TextEditingController();
  final List<String> _tags = [];
  bool _initialized = false;
  bool _saving = false;

  @override
  void dispose() {
    _titleController.dispose();
    _htmlController.dispose();
    _tagController.dispose();
    super.dispose();
  }

  void _load(Item item) {
    if (_initialized) return;
    _initialized = true;
    _titleController.text = item.title;
    _htmlController.text = item.text;
    _tags
      ..clear()
      ..addAll(item.tags);
  }

  void _addTag() {
    final tag = _tagController.text.trim();
    if (tag.isEmpty || _tags.contains(tag)) return;
    setState(() {
      _tags.add(tag);
      _tagController.clear();
    });
  }

  Future<void> _save(Item? existing) async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _saving = true);
    try {
      final item = Item(
        id: existing?.id ?? generateItemId(),
        title: _titleController.text.trim(),
        text: HtmlUtils.sanitize(_htmlController.text.trim()),
        tags: _tags,
        createdAt: existing?.createdAt ?? DateTime.now(),
        updatedAt: DateTime.now(),
        hidden: existing?.hidden ?? false,
        language: existing?.language ?? AppStrings.defaultItemLanguage,
        relatedIds: existing?.relatedIds ?? const [],
        isNovena: existing?.isNovena ?? false,
        recommendedDate: existing?.recommendedDate,
        metadata: existing?.metadata ?? const {},
      );
      await ref.read(itemsRepositoryProvider).saveItem(item);
      if (mounted) {
        SnackbarHelper.show(context, AppStrings.saveSuccess);
        context.go('/');
      }
    } catch (_) {
      if (mounted) SnackbarHelper.show(context, AppStrings.genericError, isError: true);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(settingsControllerProvider);
    final isEditing = widget.itemId != null;

    if (!isEditing) {
      _initialized = true;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? AppStrings.editItem : AppStrings.addItem),
        actions: [
          TextButton(
            onPressed: _saving ? null : () => _save(_editingItem(ref)),
            child: const Text(AppStrings.save),
          ),
        ],
      ),
      body: isEditing
          ? ref.watch(_singleItemFutureProvider(widget.itemId!)).when(
                data: (item) {
                  if (item == null) {
                    return const Center(child: Text(AppStrings.notFound));
                  }
                  _load(item);
                  return _EditForm(
                    formKey: _formKey,
                    titleController: _titleController,
                    htmlController: _htmlController,
                    tagController: _tagController,
                    tags: _tags,
                    onAddTag: _addTag,
                    onRemoveTag: (tag) => setState(() => _tags.remove(tag)),
                    previewStyle: Style(
                      fontFamily: Theme.of(context).textTheme.bodyLarge?.fontFamily,
                      fontSize: FontSize(16 * settings.fontSizeMultiplier),
                      lineHeight: const LineHeight(1.55),
                    ),
                    saving: _saving,
                  );
                },
                error: (_, __) => const Center(child: Text(AppStrings.genericError)),
                loading: () => const LoadingIndicator(label: AppStrings.loading),
              )
          : _EditForm(
              formKey: _formKey,
              titleController: _titleController,
              htmlController: _htmlController,
              tagController: _tagController,
              tags: _tags,
              onAddTag: _addTag,
              onRemoveTag: (tag) => setState(() => _tags.remove(tag)),
              previewStyle: Style(
                fontFamily: Theme.of(context).textTheme.bodyLarge?.fontFamily,
                fontSize: FontSize(16 * settings.fontSizeMultiplier),
                lineHeight: const LineHeight(1.55),
              ),
              saving: _saving,
            ),
    );
  }

  Item? _editingItem(WidgetRef ref) {
    if (widget.itemId == null) return null;
    return ref.read(_singleItemFutureProvider(widget.itemId!)).value;
  }
}

class _EditForm extends StatelessWidget {
  const _EditForm({
    required this.formKey,
    required this.titleController,
    required this.htmlController,
    required this.tagController,
    required this.tags,
    required this.onAddTag,
    required this.onRemoveTag,
    required this.previewStyle,
    required this.saving,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController titleController;
  final TextEditingController htmlController;
  final TextEditingController tagController;
  final List<String> tags;
  final VoidCallback onAddTag;
  final ValueChanged<String> onRemoveTag;
  final Style previewStyle;
  final bool saving;

  @override
  Widget build(BuildContext context) {
    return AbsorbPointer(
      absorbing: saving,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: titleController,
                decoration: const InputDecoration(labelText: AppStrings.title),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return AppStrings.title;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              Text(AppStrings.tags, style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: tagController,
                      onSubmitted: (_) => onAddTag(),
                      decoration: const InputDecoration(hintText: AppStrings.addTagHint),
                    ),
                  ),
                  const SizedBox(width: 12),
                  FilledButton(
                    onPressed: onAddTag,
                    child: const Icon(Icons.add),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final tag in tags)
                    InputChip(
                      label: Text(tag),
                      onDeleted: () => onRemoveTag(tag),
                    ),
                ],
              ),
              const SizedBox(height: 20),
              Text(AppStrings.content, style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              HtmlEditorField(
                controller: htmlController,
                previewStyle: previewStyle,
              ),
              if (saving) ...[
                const SizedBox(height: 20),
                const LinearProgressIndicator(),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

final _singleItemFutureProvider = FutureProvider.family((ref, String id) {
  return ref.watch(itemsRepositoryProvider).getItem(id);
});
