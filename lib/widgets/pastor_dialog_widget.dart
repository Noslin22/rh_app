import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';

import '../consts.dart';
import 'input_field_widget.dart';

class PastorDialog extends StatelessWidget {
  PastorDialog({Key? key}) : super(key: key);
  final TextEditingController nome = TextEditingController();
  final TextEditingController cpf =
      MaskedTextController(mask: '000.000.000-00');

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Adicionar Pastor"),
      content: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: InputField(
              controller: nome,
              icon: Icons.person,
              label: "Obreiro",
            ),
          ),
          const SizedBox(width: 10),
          Flexible(
            child: InputField(
              controller: cpf,
              icon: Icons.payment,
              label: "CPF",
            ),
          ),
        ],
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            db.collection("pastores").add({
              "nome": nome.text,
              "cpf": cpf.text,
            });
          },
          child: const Text("Salvar"),
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(Colors.green),
          ),
        ),
      ],
    );
  }
}
