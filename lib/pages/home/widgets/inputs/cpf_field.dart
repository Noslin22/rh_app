import 'package:flutter/material.dart';
import 'package:scr_project/pages/home/home_controller.dart';

class CpfField extends StatelessWidget {
  const CpfField({super.key, required this.controller});
  final HomeController controller;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 2,
      child: Padding(
        padding: const EdgeInsets.only(
          top: 4,
          left: 4,
          bottom: 4,
        ),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(4),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: DropdownButton<String>(
            items: controller.cpfs
                .where((e) => e.isNotEmpty)
                .map(
                  (e) => DropdownMenuItem<String>(
                    value: e,
                    child: Text(e),
                  ),
                )
                .toList(),
            onChanged: controller.cpfs.any((e) => e.isEmpty)
                ? null
                : (cpf) {
                    if (cpf != null) {
                      controller.selectedCpf = controller.cpfs.indexOf(cpf);
                    }
                  },
            icon: Container(),
            hint: const Row(
              children: [
                Icon(Icons.payment),
                Text("CPF"),
              ],
            ),
            value: controller.currentCpf == "" ? null : controller.currentCpf,
            underline: Container(),
            borderRadius: BorderRadius.circular(10),
            iconDisabledColor: Colors.black,
          ),
        ),
      ),
    );
  }
}
