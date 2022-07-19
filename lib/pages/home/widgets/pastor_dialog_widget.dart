import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';

import 'package:rh_app/models/pastor_model.dart';
import 'package:rh_app/widgets/list_field_widget.dart';

import '../../../consts.dart';
import '../../../provider/auth_provider.dart';
import '../../../widgets/input_field_widget.dart';

class PastorDialog extends StatefulWidget {
  const PastorDialog({
    Key? key,
    required this.provider,
  }) : super(key: key);
  final AuthProvider provider;

  @override
  State<PastorDialog> createState() => _PastorDialogState();
}

class _PastorDialogState extends State<PastorDialog> {
  final TextEditingController cpf =
      MaskedTextController(mask: '000.000.000-00');
  final TextEditingController cpf2 =
      MaskedTextController(mask: '000.000.000-00');

  final TextEditingController obreiroController = TextEditingController();
  final TextEditingController campoController = TextEditingController();
  final FocusNode obreiroFocus = FocusNode();
  int mode = 0;

  List<String> modes = ["Adicionar", "Atualizar", "Excluir"];

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
                modes[mode] + " Obreiro",
                style: Theme.of(context).textTheme.headline6,
              ),
              const SizedBox(
                height: 10,
              ),
              mode == 0
                  ? InputField(
                      error: true,
                      controller: obreiroController,
                      icon: Icons.person,
                      label: "Obreiro",
                    )
                  : ListField<PastorModel>(
                      icon: Icons.person,
                      label: "Obreiro",
                      controller: obreiroController,
                      suggestions: obreiros,
                      focusNode: obreiroFocus,
                      searchBy: "nome",
                      selected: (element) {
                        obreiroController.text = element.nome.trim();
                        cpf.text = element.cpf.trim();
                        cpf2.text = element.cpf2.trim();
                        campoController.text = element.campo.trim();
                      },
                    ),
              mode != 2
                  ? const SizedBox(height: 10)
                  : Container(
                      width: 0,
                    ),
              mode != 2
                  ? InputField(
                      error: true,
                      controller: cpf,
                      icon: Icons.payment,
                      label: "CPF",
                    )
                  : Container(
                      width: 0,
                    ),
              mode != 2
                  ? const SizedBox(height: 10)
                  : Container(
                      width: 0,
                    ),
              mode != 2
                  ? InputField(
                      error: true,
                      controller: cpf2,
                      icon: Icons.payment,
                      label: "CPF Cônjuge",
                    )
                  : Container(
                      width: 0,
                    ),
              mode != 2
                  ? const SizedBox(height: 10)
                  : Container(
                      width: 0,
                    ),
              mode == 1
                  ? InputField(
                      error: true,
                      controller: campoController,
                      icon: Icons.apartment,
                      label: "Campo",
                    )
                  : Container(
                      width: 0,
                    ),
              mode != 0
                  ? const SizedBox(height: 10)
                  : Container(
                      width: 0,
                    ),
              Align(
                alignment: Alignment.bottomRight,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        obreiroController.text = "";
                        cpf.text = "";
                        campoController.text = "";
                        if (mode != 2) {
                          mode += 1;
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
                        if (mode == 2) {
                          db
                              .collection("pastores")
                              .where("nome", isEqualTo: obreiroController.text)
                              .get()
                              .then(
                            (value) {
                              db
                                  .collection("pastores")
                                  .doc(value.docs
                                      .where((element) =>
                                          element["campo"] ==
                                          widget.provider.campo)
                                      .single
                                      .id)
                                  .delete();
                            },
                          );
                        } else {
                          switch (mode) {
                            case 0:
                              db.collection("pastores").add({
                                "nome": obreiroController.text,
                                "cpf": cpf.text,
                                "cpf2": cpf2.text,
                                "campo": widget.provider.campo,
                              });
                              break;
                            case 1:
                              db
                                  .collection("pastores")
                                  .where("nome",
                                      isEqualTo: obreiroController.text)
                                  .get()
                                  .then((value) {
                                return db
                                    .collection("pastores")
                                    .doc(value.docs.single.id)
                                    .update({
                                  "nome": obreiroController.text,
                                  "cpf": cpf.text,
                                  "cpf2": cpf2.text,
                                  "campo": campoController.text,
                                });
                              });
                              break;
                          }
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
