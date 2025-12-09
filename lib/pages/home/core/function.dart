import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:scr_project/service/auth_service.dart';

import '../../../consts.dart';
import '../../../models/despesa_model.dart';
import '../../../models/value_model.dart';
import 'variables.dart';

final _despesas = list.allDespesas;

void valorListener() {
  valorRecusadoController.updateValue(
    apresentadoController.numberValue - valorController.numberValue,
  );
}

void valorRecusadoListener() {
  valorController.updateValue(
    apresentadoController.numberValue - valorRecusadoController.numberValue,
  );
}

void onFocus2Listener() {
  Future.delayed(const Duration(microseconds: 10), () {
    apresentadoController.selection = TextSelection.collapsed(
      offset: apresentadoController.text.length,
    );
  });
}

void onFocus4Listener() {
  Future.delayed(const Duration(microseconds: 10), () {
    valorController.selection = TextSelection.collapsed(
      offset: valorController.text.length,
    );
  });
}

void onFocus5Listener() {
  Future.delayed(const Duration(microseconds: 10), () {
    valorRecusadoController.selection = TextSelection.collapsed(
      offset: valorRecusadoController.text.length,
    );
  });
}

void init() {
  nome = AuthService.instance.nome;
  db.collection("users").where("nome", isEqualTo: nome).get().then(
    (value) {
      return authService.campo = value.docs[0]["campo"].toString();
    },
  );

  valorController.addListener(valorListener);
  valorRecusadoController.addListener(valorRecusadoListener);

  nodes[2].addListener(onFocus2Listener);
  nodes[4].addListener(onFocus4Listener);
  nodes[5].addListener(onFocus5Listener);
}

void submit(String cpf) {
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
          cpf: cpf,
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
              cpf: cpf,
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

void selectDate(BuildContext context) {
  showDatePicker(
    locale: const Locale("pt", "BR"),
    context: context,
    initialDate: DateTime.now(),
    firstDate: DateTime(DateTime.now().year - 1, 12),
    lastDate: DateTime(DateTime.now().year + 1, 1, 31),
  ).then(
    (value) {
      if (value == null) {
        Builder(
          builder: (context) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Selecione uma data"),
                duration: Duration(seconds: 2),
              ),
            );
            return Container();
          },
        );
      } else {
        dateController.text =
            "${value.day < 10 ? "0${value.day}" : value.day}/${value.month < 10 ? "0${value.month}" : value.month}/${value.year}";
      }
    },
  ).then(
    (_) {
      if (context.mounted) {
        nodes[2].requestFocus();

        Future.delayed(const Duration(microseconds: 10), () {
          apresentadoController.selection = TextSelection.collapsed(
            offset: apresentadoController.text.length,
          );
        });
      }
    },
  );
}

void selectMonth(BuildContext context) {
  showMonthPicker(
    context: context,
    monthPickerDialogSettings: const MonthPickerDialogSettings(
      dialogSettings: PickerDialogSettings(
        locale: Locale("pt", "BR"),
      ),
    ),
    initialDate: DateTime.now(),
    firstDate: DateTime(DateTime.now().year - 1, 12),
    lastDate: DateTime(DateTime.now().year, 12),
  ).then(
    (value) {
      if (value == null) {
        Builder(
          builder: (context) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  "Selecione um mês",
                ),
                duration: Duration(seconds: 2),
              ),
            );
            return Container();
          },
        );
      } else {
        periodoController.text =
            "${value.month < 10 ? "0${value.month}" : value.month.toString()}/${value.year.toString()}";
      }
    },
  ).then(
    (_) {
      if (context.mounted) {
        nodes[1].requestFocus();
      }
    },
  );
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
