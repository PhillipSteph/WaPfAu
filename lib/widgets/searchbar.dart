// lib/widgets/searchbar.dart
import 'package:flutter/material.dart';

class CourseSearchBar extends StatefulWidget {
  const CourseSearchBar({
    super.key,
    required this.onQueryChanged,
    this.onSubmitted,
    this.hintText = 'Module durchsuchen…',
    this.initialQuery = '',
    this.padding = const EdgeInsets.fromLTRB(16, 16, 16, 8),
  });

  /// Wird bei jeder Textänderung aufgerufen.
  final ValueChanged<String> onQueryChanged;

  /// Optional: wird aufgerufen, wenn der Nutzer Enter/"Search" drückt.
  final ValueChanged<String>? onSubmitted;

  /// Placeholder-Text.
  final String hintText;

  /// Startwert für den Suchtext.
  final String initialQuery;

  /// Außenabstand der SearchBar.
  final EdgeInsets padding;

  @override
  State<CourseSearchBar> createState() => _CourseSearchBarState();
}

class _CourseSearchBarState extends State<CourseSearchBar> {
  // Farben an dein Design angelehnt
  static const Color _bgColor     = Color(0xFFF6F7F9); // sehr helles Grau
  static const Color _idleBorder  = Color(0xFFBDBDBD); // grauer Rand (idle)
  static const Color _focusBorder = Color(0xFF8E8E93); // dunklerer Rand (Focus)
  static const Color _hintColor   = Color(0xFF8E8E93); // dezenter Hint
  static const Color _iconColor   = Color(0xFF6E6E73); // Such-/Clear-Icon

  late final SearchController _controller;
  String _query = '';

  @override
  void initState() {
    super.initState();
    _controller = SearchController();
    _controller.text = widget.initialQuery;
    _query = widget.initialQuery;
    _controller.addListener(_handleControllerChange);
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // M3-Styles je nach Zustand (hover/focus)
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
      child: SearchBar(
        controller: _controller,
        hintText: widget.hintText,
        leading: const Icon(Icons.search, color: _iconColor),
        padding: const WidgetStatePropertyAll<EdgeInsets>(
          EdgeInsets.symmetric(horizontal: 16),
        ),
        shape: shape,
        side: side,
        elevation: elevation,
        backgroundColor: backgroundColor,
        constraints: const BoxConstraints(minHeight: 44), // schlank
        surfaceTintColor: const WidgetStatePropertyAll<Color>(Colors.transparent),
        overlayColor: const WidgetStatePropertyAll<Color>(Colors.transparent),

        hintStyle: const WidgetStatePropertyAll<TextStyle>(
          TextStyle(color: _hintColor),
        ),
        textStyle: WidgetStatePropertyAll<TextStyle>(
          Theme.of(context).textTheme.bodyMedium!,
        ),

        onChanged: (_) {}, // Listener übernimmt das Handling
        onSubmitted: (value) => widget.onSubmitted?.call(value.trim()),
        trailing: [
          if (_query.isNotEmpty)
            IconButton(
              tooltip: 'Suche leeren',
              onPressed: () => _controller.clear(), // triggert Listener
              icon: const Icon(Icons.clear, color: _iconColor),
            ),
        ],
      ),
    );
  }
}
