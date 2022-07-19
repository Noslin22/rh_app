import 'package:flutter/material.dart';

import '../../../consts.dart';
import '../../../widgets/input_field_widget.dart';
import '../../../widgets/list_field_widget.dart';

class DespesaDialog extends StatefulWidget {
  const DespesaDialog({Key? key}) : super(key: key);

  @override
  _DespesaDialogState createState() => _DespesaDialogState();
}

class _DespesaDialogState extends State<DespesaDialog> {
  int mode = 0;

  final TextEditingController despesaController = TextEditingController();
  final FocusNode focus = FocusNode();
  List<String> modes = ["Adicionar", "Excluir"];

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 300),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                modes[mode] + " Despesa",
                style: Theme.of(context).textTheme.headline6,
              ),
              const SizedBox(
                height: 10,
              ),
              mode == 0
                  ? InputField(
                      error: true,
                      controller: despesaController,
                      icon: Icons.sticky_note_2,
                      label: "Despesa",
                    )
                  : ListField<String>(
                      icon: Icons.person,
                      label: "Despesa",
                      controller: despesaController,
                      suggestions: despesasList,
                      focusNode: focus,
                      selected: (element) {
                        despesaController.text = element.trim();
                      },
                    ),
              const SizedBox(
                height: 10,
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
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
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.blue),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
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
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.green),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
