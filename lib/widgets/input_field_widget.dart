import 'package:flutter/material.dart';

import 'package:rh_app/consts.dart';

class InputField extends StatelessWidget {
  final TextEditingController controller;
  final IconData icon;
  final String label;
  final bool readOnly;
  final bool error;
  final FocusNode? focusNode;
  final String? initialValue;
  final VoidCallback? submit;
  const InputField({
    Key? key,
    required this.controller,
    required this.icon,
    required this.label,
    this.readOnly = false,
    this.error = false,
    this.focusNode,
    this.initialValue,
    this.submit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      readOnly: readOnly,
      initialValue: initialValue,
      focusNode: focusNode,
      validator: error
          ? (value) {
              if (value != null && value.isEmpty) {
                return "Informe o $label";
              } else {
                return null;
              }
            }
          : null,
      onFieldSubmitted: focusNode != null
          ? (_) {
              int index = nodes.indexOf(focusNode!) + 1;
              if (nodes.length > index) {
                FocusScope.of(context).requestFocus(nodes[index]);
              } else {
                submit!();
                FocusScope.of(context).requestFocus(nodes[1]);
              }
            }
          : null,
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
  }
}
