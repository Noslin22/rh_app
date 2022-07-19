import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';

import '../../../consts.dart';
import '../../../models/despesa_model.dart';
import '../../../models/value_model.dart';
import 'variables.dart';

void init() {
  List<String> nomes =
      provider.auth.currentUser!.email!.replaceAll("_", " ").split(" ");
  List<String> first = nomes[0].split("");
  List<String> last = nomes[1].split("@")[0].split("");
  first = [first.first.toUpperCase(), ...first.sublist(1, first.length)];
  last = [last.first.toUpperCase(), ...last.sublist(1, last.length)];
  nome = "${first.join()} ${last.join()}";
  db.collection("users").where("nome", isEqualTo: nome).get().then(
    (value) {
      return provider.campo = value.docs.single["campo"].toString();
    },
  );
}

void clearFields({bool all = false}) {
  if (all) {
    pastorController.clear();
    cpfs = ["", ""];
    cpf = "";
    periodoController.clear();
  }
  despesaController.clear();
  apresentadoController.text = "R\$0,00";
  cupomController.clear();
  dateController.clear();
  valorController.text = "R\$0,00";
  valorRecusadoController.text = "R\$0,00";
  motivoController.clear();
}

void submit() {
  String despesa = despesaController.text;
  if (despesa.isNotEmpty &&
      pastorController.text.isNotEmpty &&
      cupomController.text.isNotEmpty &&
      periodoController.text.isNotEmpty) {
    if (list.where((element) => element.name == despesa).isNotEmpty) {
      list.where((element) => element.name == despesa).first.values.add(
            ValueModel(
              pastor: pastorController.text,
              cpf: cpfController.text,
              periodo: periodoController.text,
              apresentado: apresentadoController.text,
              cupom: cupomController.text,
              valor: valorController.text,
              recusado: valorRecusadoController.text,
              motivo: motivoController.text,
              date: dateController.text,
            ),
          );
    } else {
      list.add(
        DespesaModel(
          name: despesa,
          values: [
            ValueModel(
              pastor: pastorController.text,
              cpf: cpfController.text,
              periodo: periodoController.text,
              apresentado: apresentadoController.text,
              cupom: cupomController.text,
              valor: valorController.text,
              recusado: valorRecusadoController.text,
              motivo: motivoController.text,
              date: dateController.text,
            ),
          ],
        ),
      );
    }
  }
}

Widget generateTotal(int index) {
  double aceito = 0;
  double recusado = 0;
  double apresentado = 0;
  for (var e in list[index].values) {
    aceito += parse(e.valor);
    recusado += parse(e.recusado);
    apresentado += parse(e.apresentado);
  }
  return Padding(
    padding: const EdgeInsets.only(top: 4, bottom: 4),
    child: Row(
      children: [
        Text(
          "Total Apresentado: R\$${MoneyMaskedTextController(initialValue: apresentado).text}",
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
            fontSize: 16,
          ),
        ),
        const SizedBox(width: 26),
        Container(
          decoration: BoxDecoration(
            color: Colors.grey[300],
            border: Border.all(),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Text(
              "Total Aceito: R\$${MoneyMaskedTextController(initialValue: aceito).text}",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
                fontSize: 16,
              ),
            ),
          ),
        ),
        const SizedBox(width: 26),
        Text(
          "Total Recusado: R\$${MoneyMaskedTextController(initialValue: recusado).text}",
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
            fontSize: 16,
          ),
        ),
      ],
    ),
  );
}
