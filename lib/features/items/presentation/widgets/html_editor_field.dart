import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

import '../../../../core/utils/html_utils.dart';
import '../../../../l10n/app_localizations.dart';

class HtmlEditorField extends StatefulWidget {
  const HtmlEditorField({
    super.key,
    required this.controller,
    required this.previewStyle,
  });

  final TextEditingController controller;
  final Style previewStyle;

  @override
  State<HtmlEditorField> createState() => _HtmlEditorFieldState();
}

class _HtmlEditorFieldState extends State<HtmlEditorField>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _wrapSelection(String before, String after) {
    final selection = widget.controller.selection;
    final text = widget.controller.text;
    final start = selection.start >= 0 ? selection.start : text.length;
    final end = selection.end >= 0 ? selection.end : text.length;
    final selected = text.substring(start, end);
    final replacement = '$before$selected$after';
    final updated = text.replaceRange(start, end, replacement);
    widget.controller.value = TextEditingValue(
      text: updated,
      selection: TextSelection.collapsed(offset: start + replacement.length),
    );
    setState(() {});
  }

  void _insert(String value) {
    _wrapSelection(value, '');
  }

  void _clearFormatting() {
    final selection = widget.controller.selection;
    final text = widget.controller.text;
    final start = selection.start >= 0 ? selection.start : 0;
    final end = selection.end >= 0 ? selection.end : text.length;
    final selected = text.substring(start, end);
    final plain = HtmlUtils.stripHtml(selected);
    final updated = text.replaceRange(start, end, plain);
    widget.controller.value = TextEditingValue(
      text: updated,
      selection: TextSelection.collapsed(offset: start + plain.length),
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _ToolbarButton(label: 'P', onPressed: () => _wrapSelection('<p>', '</p>')),
              _ToolbarButton(label: 'H1', onPressed: () => _wrapSelection('<h1>', '</h1>')),
              _ToolbarButton(label: 'H2', onPressed: () => _wrapSelection('<h2>', '</h2>')),
              _ToolbarButton(label: 'B', onPressed: () => _wrapSelection('<strong>', '</strong>')),
              _ToolbarButton(label: 'I', onPressed: () => _wrapSelection('<em>', '</em>')),
              _ToolbarButton(label: 'UL', onPressed: () => _wrapSelection('<ul><li>', '</li></ul>')),
              _ToolbarButton(label: 'OL', onPressed: () => _wrapSelection('<ol><li>', '</li></ol>')),
              _ToolbarButton(label: 'L', onPressed: () => _wrapSelection('<p style="text-align:left">', '</p>')),
              _ToolbarButton(label: 'C', onPressed: () => _wrapSelection('<p style="text-align:center">', '</p>')),
              _ToolbarButton(label: 'J', onPressed: () => _wrapSelection('<p style="text-align:justify">', '</p>')),
              _ToolbarButton(label: 'Red', onPressed: () => _wrapSelection('<span style="color:red">', '</span>')),
              _ToolbarButton(label: 'BR', onPressed: () => _insert('<br/>')),
              _ToolbarButton(label: l10n.clear, onPressed: _clearFormatting),
            ],
          ),
        ),
        const SizedBox(height: 12),
        TabBar(
          controller: _tabController,
          tabs: [Tab(text: l10n.htmlSource), Tab(text: l10n.previewText)],
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 320,
          child: TabBarView(
            controller: _tabController,
            children: [
              TextFormField(
                controller: widget.controller,
                maxLines: null,
                expands: true,
                textAlignVertical: TextAlignVertical.top,
                decoration: InputDecoration(
                  hintText: l10n.sourceModeHint,
                  alignLabelWithHint: true,
                ),
              ),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  color: Theme.of(context).colorScheme.surfaceVariant,
                ),
                child: SingleChildScrollView(
                  child: Html(
                    data: HtmlUtils.sanitize(widget.controller.text),
                    style: {
                      'body': widget.previewStyle,
                      'p': widget.previewStyle,
                      'span': widget.previewStyle,
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ToolbarButton extends StatelessWidget {
  const _ToolbarButton({required this.label, required this.onPressed});

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: OutlinedButton(
        onPressed: onPressed,
        child: Text(label),
      ),
    );
  }
}
