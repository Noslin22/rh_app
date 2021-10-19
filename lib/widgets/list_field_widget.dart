import 'package:field_suggestion/field_suggestion.dart';
import 'package:flutter/material.dart';

class ListField extends StatelessWidget {
  const ListField({
    Key? key,
    required this.icon,
    required this.label,
    required this.focusNode,
    required this.controller,
    required this.suggestions,
    this.searchBy = false,
    required this.box,
    required this.selected,
  }) : super(key: key);
  final IconData icon;
  final String label;
  final FocusNode focusNode;
  final TextEditingController controller;
  final List suggestions;
  final bool searchBy;
  final BoxController box;
  final Function(dynamic) selected;

  @override
  Widget build(BuildContext context) {
    return FieldSuggestion(
      fieldDecoration: InputDecoration(
        border: const OutlineInputBorder(),
        label: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon),
            Text(label),
          ],
        ),
      ),
      focusNode: focusNode,
      textController: controller,
      suggestionList: suggestions,
      disabledDefaultOnIconTap: true,
      disableItemTrailing: true,
      searchBy: searchBy ? ["nome"] : null,
      boxController: box,
      onItemSelected: selected,
    );
  }
}
