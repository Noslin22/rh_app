import 'package:field_suggestion/field_suggestion.dart';
import 'package:flutter/material.dart';

import '../consts.dart';
import 'input_field_widget.dart';
import 'list_field_widget.dart';

class DespesaDialog extends StatefulWidget {
  const DespesaDialog({ Key? key }) : super(key: key);

  @override
  _DespesaDialogState createState() => _DespesaDialogState();
}

class _DespesaDialogState extends State<DespesaDialog> {
  int mode = 0;

    final TextEditingController despesaController = TextEditingController();
    final BoxController despesaBox = BoxController();
  List<String> modes = ["Adicionar", "Excluir"];

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => mode == 1 ? despesaBox.close!() : null,
      child: AlertDialog(
        contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        title: Text(modes[mode] + " Despesa"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            mode == 0
                ? InputField(
                    error: true,
                    controller: despesaController,
                    icon: Icons.sticky_note_2,
                    label: "Despesa",
                  )
                : ListField(
                    icon: Icons.person,
                    label: "Despesa",
                    controller: despesaController,
                    suggestions: despesasList,
                    box: despesaBox,
                    selected: (element) {
                      despesaController.text = element.trim();
                    },
                  ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              despesaController.text = "";
              if (mode == 0) {
                mode = 1;
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
                if (mode == 1) {
                  db
                      .collection("despesas")
                      .where("nome", isEqualTo: despesaController.text)
                      .get()
                      .then(
                        (value) => db
                            .collection("despesas")
                            .doc(value.docs.single.id)
                            .delete(),
                      );
                
              } else {
                    db.collection("despesas").add({
                      "nome": despesaController.text.trim(),
                    });
              }
              Navigator.of(context).pop();
            },
            child: Text(modes[mode]),
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(Colors.green),
            ),
          ),
        ],
      ),
    );
  }
}