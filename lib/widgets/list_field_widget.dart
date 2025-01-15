import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class ListField<T extends Object> extends StatelessWidget {
  const ListField({
    super.key,
    required this.icon,
    required this.label,
    this.focusNode,
    required this.controller,
    required this.suggestions,
    this.searchBy,
    required this.selected,
  });
  final IconData icon;
  final String label;
  final FocusNode? focusNode;
  final TextEditingController controller;
  final List<T> suggestions;
  final String? searchBy;
  final void Function(T) selected;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return RawAutocomplete<T>(
        focusNode: focusNode,
        textEditingController: controller,
        optionsBuilder: (value) {
          return suggestions.where((element) => element
              .toString()
              .toLowerCase()
              .contains(value.text.toLowerCase()));
        },
        onSelected: (e) {
          selected(e);
        },
        displayStringForOption: (e) {
          return e.toString();
        },
        fieldViewBuilder: (_, controller, focusNode, submit) {
          return TextField(
            focusNode: focusNode,
            controller: controller,
            onSubmitted: (_) {
              submit();
            },
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              label: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(icon),
                  Text(label),
                ],
              ),
            ),
          );
        },
        optionsViewBuilder: (context, onSelected, options) {
          return Align(
            alignment: Alignment.topLeft,
            child: Material(
              elevation: 4.0,
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: 200,
                  maxWidth: constraints.maxWidth,
                ),
                child: ListView.builder(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  itemCount: options.length,
                  itemBuilder: (BuildContext context, int index) {
                    final T option = options.elementAt(index);
                    return InkWell(
                      onTap: () {
                        onSelected(option);
                      },
                      child: Builder(builder: (BuildContext context) {
                        final bool highlight =
                            AutocompleteHighlightedOption.of(context) == index;
                        if (highlight) {
                          SchedulerBinding.instance
                              .addPostFrameCallback((Duration timeStamp) {
                            Scrollable.ensureVisible(context, alignment: 0.5);
                          });
                        }
                        return Container(
                          color:
                              highlight ? Theme.of(context).focusColor : null,
                          padding: const EdgeInsets.all(16.0),
                          child: Text(option.toString()),
                        );
                      }),
                    );
                  },
                ),
              ),
            ),
          );
        },
      );
    });
  }
}
