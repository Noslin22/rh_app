import 'package:field_suggestion/field_suggestion.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:rh_app/widgets/list_field_widget.dart';

import '../consts.dart';
import 'input_field_widget.dart';

class PastorDialog extends StatefulWidget {
  const PastorDialog({Key? key}) : super(key: key);

  @override
  State<PastorDialog> createState() => _PastorDialogState();
}

class _PastorDialogState extends State<PastorDialog> {
  final TextEditingController cpf =
      MaskedTextController(mask: '000.000.000-00');

  int mode = 0;

  List<String> modes = ["Adicionar", "Atualizar", "Excluir"];

  @override
  Widget build(BuildContext context) {
    final TextEditingController obreiroController = TextEditingController();
    final BoxController obreiroBox = BoxController();
    return AlertDialog(
      contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      title: Text(modes[mode] + " Obreiro"),
      content: Container(
        constraints: const BoxConstraints(
          minWidth: 260,
          maxWidth: 300,
          minHeight: 50,
          maxHeight: 50,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            mode == 0
                ? Container(
                    constraints: const BoxConstraints(
                      minWidth: 100,
                      maxWidth: 160,
                      minHeight: 40,
                      maxHeight: 100,
                    ),
                    child: Flexible(
                      child: InputField(
                        error: true,
                        controller: obreiroController,
                        icon: Icons.person,
                        label: "Obreiro",
                      ),
                    ),
                  )
                : ConstrainedBox(
                    constraints: BoxConstraints(
                      minWidth: 100,
                      maxWidth: mode == 2 ? 260 : 160,
                      minHeight: 40,
                      maxHeight: 100,
                    ),
                    child: Flexible(
                      child: ListField(
                        icon: Icons.person,
                        label: "Obreiro",
                        controller: obreiroController,
                        suggestions: obreiros.map((e) => e.nome).toList(),
                        box: obreiroBox,
                        selected: (element) {
                          obreiroController.text = element.trim();
                        },
                      ),
                    ),
                  ),
            mode != 2
                ? const SizedBox(width: 10)
                : Container(
                    width: 0,
                  ),
            mode != 2
                ? Flexible(
                    child: InputField(
                      error: true,
                      controller: cpf,
                      icon: Icons.payment,
                      label: "CPF",
                    ),
                  )
                : Container(
                    width: 0,
                  ),
          ],
        ),
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            obreiroController.text = "";
            if (mode != 2) {
              mode += 1;
            } else {
              mode = 0;
            }
            setState(() {});
          },
          child: const Text("Modo"),
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            if (cpf.text == "") {
              if (mode == 2) {
                db
                    .collection("pastores")
                    .where("nome", isEqualTo: obreiroController.text)
                    .get()
                    .then(
                      (value) => db
                          .collection("pastores")
                          .doc(value.docs.single.id)
                          .delete(),
                    );
              }
            } else {
              switch (mode) {
                case 0:
                  db.collection("pastores").add({
                    "nome": obreiroController.text,
                    "cpf": cpf.text,
                  });
                  break;
                case 1:
                  db
                      .collection("pastores")
                      .where("nome", isEqualTo: obreiroController.text)
                      .get()
                      .then((value) {
                    return db
                        .collection("pastores")
                        .doc(value.docs.single.id)
                        .update({
                      "nome": obreiroController.text,
                      "cpf": cpf.text,
                    });
                  });
                  break;
              }
            }
            Navigator.of(context).pop();
          },
          child: Text(modes[mode]),
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(Colors.green),
          ),
        ),
      ],
    );
  }
}
