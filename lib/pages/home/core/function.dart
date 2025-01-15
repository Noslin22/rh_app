import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:scr_project/service/auth_service.dart';

import '../../../consts.dart';
import '../../../models/despesa_model.dart';
import '../../../models/value_model.dart';
import 'variables.dart';

final _despesas = list.allDespesas;

void init() {
  nome = AuthService.instance.nome;
  db.collection("users").where("nome", isEqualTo: nome).get().then(
    (value) {
      return authService.campo = value.docs[0]["campo"].toString();
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
    if (_despesas.where((element) => element.name == despesa).isNotEmpty) {
      list.addValue(
        despesa,
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
      list.addDespesa(
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
  for (var e in _despesas[index].values) {
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
