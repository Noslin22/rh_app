import 'package:flutter/material.dart';

import 'package:scr_project/consts.dart';

class InputField extends StatelessWidget {
  final TextEditingController controller;
  final IconData icon;
  final String label;
  final bool readOnly;
  final bool error;
  final FocusNode? focusNode;
  final String? initialValue;
  final VoidCallback? submit;
  final VoidCallback? onTap;
  const InputField({
    super.key,
    required this.controller,
    required this.icon,
    required this.label,
    this.readOnly = false,
    this.error = false,
    this.focusNode,
    this.initialValue,
    this.submit,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      readOnly: readOnly,
      initialValue: initialValue,
      focusNode: focusNode,
      onTap: onTap,
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
            Flexible(child: Text(label)),
          ],
        ),
      ),
    );
  }
}
