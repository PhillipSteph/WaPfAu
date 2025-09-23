import 'package:flutter/material.dart';
import 'package:wapfau/models/course.dart';

class CourseSearchBar extends StatefulWidget {
  const CourseSearchBar({
    super.key,
    required this.onQueryChanged,
    this.onSubmitted,
    this.hintText = 'Module durchsuchen…',
    this.initialQuery = '',
    this.padding = const EdgeInsets.fromLTRB(16, 16, 16, 8),
    this.showInlineSuggestions = false,
    this.suggestionsSource = const <Course>[],
    this.maxSuggestions = 8,
    this.noResultsText = 'Keine Treffer',
  });

  final ValueChanged<String> onQueryChanged;
  final ValueChanged<String>? onSubmitted;

  final String hintText;
  final String initialQuery;
  final EdgeInsets padding;

  // Optional: Inline-Vorschläge direkt unter dem Feld
  final bool showInlineSuggestions;
  final List<Course> suggestionsSource;
  final int maxSuggestions;
  final String noResultsText;

  @override
  State<CourseSearchBar> createState() => _CourseSearchBarState();
}

class _CourseSearchBarState extends State<CourseSearchBar> {
  static const Color _bgColor       = Color(0xFFF6F7F9);
  static const Color _idleBorder    = Color(0xFFBDBDBD);
  static const Color _focusBorder   = Color(0xFF8E8E93);
  static const Color _hintColor     = Color(0xFF8E8E93);
  static const Color _iconColor     = Color(0xFF6E6E73);

  late final SearchController _controller;
  final FocusNode _focusNode = FocusNode();
  String _query = '';
  bool _focused = false;

  @override
  void initState() {
    super.initState();
    _controller = SearchController();
    _controller.text = widget.initialQuery;
    _query = widget.initialQuery;

    _controller.addListener(_handleControllerChange);
    _focusNode.addListener(() => setState(() => _focused = _focusNode.hasFocus));
  }

  void _handleControllerChange() {
    final text = _controller.text.trim();
    if (text != _query) {
      setState(() => _query = text);
      widget.onQueryChanged(text);
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_handleControllerChange);
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  List<Course> _computeSuggestions(String input) {
    if (input.isEmpty) return const [];
    final q = input.toLowerCase();
    final seen = <String>{};
    final out = <Course>[];
    for (final c in widget.suggestionsSource) {
      final title = c.title;
      if (title.toLowerCase().contains(q) && seen.add(title)) {
        out.add(c);
        if (out.length >= widget.maxSuggestions) break;
      }
    }
    return out;
  }

  @override
  Widget build(BuildContext context) {
    final suggestions = widget.showInlineSuggestions
        ? _computeSuggestions(_query)
        : const <Course>[];

    final shape = WidgetStatePropertyAll<RoundedRectangleBorder>(
      RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    );

    final side = WidgetStateProperty.resolveWith<BorderSide>((states) {
      if (states.contains(WidgetState.focused)) {
        return const BorderSide(color: _focusBorder, width: 1.6);
      }
      if (states.contains(WidgetState.hovered)) {
        return const BorderSide(color: _focusBorder, width: 1.3);
      }
      return const BorderSide(color: _idleBorder, width: 1.2);
    });

    final elevation = WidgetStateProperty.resolveWith<double>((states) {
      if (states.contains(WidgetState.focused)) return 1.6;
      if (states.contains(WidgetState.hovered)) return 1.0;
      return 0.5;
    });

    final backgroundColor = const WidgetStatePropertyAll<Color>(_bgColor);

    return Padding(
      padding: widget.padding,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SearchBar(
            controller: _controller,
            focusNode: _focusNode,
            hintText: widget.hintText,
            leading: const Icon(Icons.search, color: _iconColor),
            padding: const WidgetStatePropertyAll<EdgeInsets>(
              EdgeInsets.symmetric(horizontal: 16),
            ),
            shape: shape,
            side: side,
            elevation: elevation,
            backgroundColor: backgroundColor,
            constraints: const BoxConstraints(minHeight: 44), // schlanke Höhe
            surfaceTintColor: const WidgetStatePropertyAll<Color>(Colors.transparent),
            overlayColor: const WidgetStatePropertyAll<Color>(Colors.transparent),

            hintStyle: const WidgetStatePropertyAll<TextStyle>(
              TextStyle(color: _hintColor),
            ),
            textStyle: WidgetStatePropertyAll<TextStyle>(
              Theme.of(context).textTheme.bodyMedium!,
            ),

            onChanged: (_) {
            },
            onSubmitted: (value) => widget.onSubmitted?.call(value.trim()),
            trailing: [
              if (_query.isNotEmpty)
                IconButton(
                  tooltip: 'Suche leeren',
                  onPressed: () => _controller.clear(),
                  icon: const Icon(Icons.clear, color: _iconColor),
                ),
            ],
          ),

          if (widget.showInlineSuggestions && (_focused || _query.isNotEmpty))
            _InlineSuggestions(
              query: _query,
              compute: _computeSuggestions,
              noResultsText: widget.noResultsText,
            ),
        ],
      ),
    );
  }
}

class _InlineSuggestions extends StatelessWidget {
  const _InlineSuggestions({
    required this.query,
    required this.compute,
    required this.noResultsText,
  });

  final String query;
  final List<Course> Function(String) compute;
  final String noResultsText;

  @override
  Widget build(BuildContext context) {
    final items = compute(query);
    if (query.isEmpty) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.only(top: 6),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border.all(color: Theme.of(context).dividerColor),
        borderRadius: BorderRadius.circular(12),
      ),
      child: items.isEmpty
          ? Padding(
        padding: const EdgeInsets.all(12.0),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            noResultsText,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
      )
          : ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: items.length,
        separatorBuilder: (_, __) => const Divider(height: 1),
        itemBuilder: (context, i) {
          final c = items[i];
          return ListTile(
            dense: true,
            title: Text(c.title),
            onTap: () {
              FocusScope.of(context).unfocus();
            },
          );
        },
      ),
    );
  }
}
