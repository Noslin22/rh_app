import 'package:flutter/material.dart';

import 'package:rh_app/consts.dart';

class InputField extends StatelessWidget {
  final TextEditingController controller;
  final IconData icon;
  final String label;
  final bool readOnly;
  final FocusNode? focusNode;
  final VoidCallback? submit;
  const InputField({
    Key? key,
    required this.controller,
    required this.icon,
    required this.label,
    this.readOnly = false,
    this.focusNode,
    this.submit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      readOnly: readOnly,
      focusNode: focusNode,
      onSubmitted: focusNode != null
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
