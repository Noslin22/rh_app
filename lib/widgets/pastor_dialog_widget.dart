import 'package:field_suggestion/field_suggestion.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';

import 'package:rh_app/models/pastor_model.dart';
import 'package:rh_app/widgets/list_field_widget.dart';

import '../consts.dart';
import '../provider/auth_provider.dart';
import 'input_field_widget.dart';

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

  final TextEditingController obreiroController = TextEditingController();
  final TextEditingController campoController = TextEditingController();
  final BoxController obreiroBox = BoxController();
  int mode = 0;


  List<String> modes = ["Adicionar", "Atualizar", "Excluir"];

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => mode != 0 ? obreiroBox.close!() : null,
      child: AlertDialog(
        contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        title: Text(modes[mode] + " Obreiro"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
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
                    box: obreiroBox,
                    searchBy: "nome",
                    selected: (element) {
                      obreiroController.text = element.nome.trim();
                      cpf.text = element.cpf.trim();
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
                    controller: campoController,
                    icon: Icons.apartment,
                    label: "Campo",
                  )
                : Container(
                    width: 0,
                  ),
          ],
        ),
        actions: [
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
              backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
            ),
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
                    print(value.docs.map((e) => e.data()));
                    print(widget.provider.campo);
                    db
                        .collection("pastores")
                        .doc(value.docs
                            .where(
                                (element) => element["campo"] == widget.provider.campo)
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
                      "campo": campoController.text,
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
              backgroundColor: MaterialStateProperty.all<Color>(Colors.green),
            ),
          ),
        ],
      ),
    );
  }
}
