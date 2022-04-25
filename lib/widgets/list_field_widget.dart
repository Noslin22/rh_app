import 'package:field_suggestion/field_suggestion.dart';
import 'package:flutter/material.dart';
import 'package:rh_app/models/despesa_model.dart';
import 'package:rh_app/models/pastor_model.dart';

class ListField<T> extends StatelessWidget {
  const ListField({
    Key? key,
    required this.icon,
    required this.label,
    this.focusNode,
    required this.controller,
    required this.suggestions,
    this.searchBy,
    required this.box,
    required this.selected,
  }) : super(key: key);
  final IconData icon;
  final String label;
  final FocusNode? focusNode;
  final TextEditingController controller;
  final List<T> suggestions;
  final String? searchBy;
  final BoxController box;
  final Function(T) selected;

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
      searchBy: searchBy == null ? null : [searchBy!],
      boxController: box,
      onItemSelected: (e) {
        if (T == PastorModel) {
          selected(PastorModel.fromMap(e) as T);
        } else {
          selected(e);
        }
      },
    );
  }
}
