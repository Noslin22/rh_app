import 'package:flutter/material.dart';
import 'package:scr_project/core/extensions.dart';

import '../../../consts.dart';
import '../../../models/despesa_model.dart';
import '../../../models/value_model.dart';
import '../core/function.dart';
import '../core/variables.dart';

class DisplayDespesas extends StatefulWidget {
  const DisplayDespesas({
    super.key,
  });

  @override
  State<DisplayDespesas> createState() => _DisplayDespesasState();
}

class _DisplayDespesasState extends State<DisplayDespesas> {
  List<DespesaModel> despesas = list.allDespesas;

  @override
  void initState() {
    super.initState();
    list.addListener(
      () {
        setState(() {
          despesas = list.allDespesas;
          for (var despesa in despesas) {
            despesa.values.sort(
              (a, b) => a.date.toDate().compareTo(b.date.toDate()),
            );
          }
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: ListView.builder(
        itemCount: despesas.length,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          DespesaModel despesa = despesas[index];
          List<ValueModel> values = despesa.values;
          return Column(
            children: [
              ListTile(
                title: Container(
                  padding: const EdgeInsets.only(left: 16),
                  color: Colors.grey[300],
                  child: Text(
                    despesa.name,
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                subtitle: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ...List.generate(
                      5,
                      (index) => Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            fields[index],
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          ...List.generate(values.length, (i) {
                            ValueModel value = values[i];
                            late String variable;
                            switch (index) {
                              case 0:
                                variable = value.apresentado;
                                break;
                              case 1:
                                variable = "${value.cupom} - ${value.date}";
                                break;
                              case 2:
                                variable = value.valor;
                                break;
                              case 3:
                                variable = value.recusado;
                                break;
                              case 4:
                                variable = value.motivo;
                                break;
                              default:
                                variable = "";
                            }
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: Text(
                                variable,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black,
                                ),
                              ),
                            );
                          }),
                        ],
                      ),
                    ),
                    Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 6,
                            horizontal: 6,
                          ),
                        ),
                        ...List.generate(values.length, (index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: GestureDetector(
                              onTap: () {
                                showModalBottomSheet(
                                  context: context,
                                  builder: (context) {
                                    return Row(
                                      children: [
                                        Expanded(
                                          child: Container(
                                            padding: const EdgeInsets.all(30),
                                            child: TextButton(
                                              child: const Text("Editar"),
                                              onPressed: () {
                                                pastorController.text =
                                                    values[index].pastor;
                                                despesaController.text =
                                                    despesa.name;
                                                periodoController.text =
                                                    values[index].periodo;
                                                dateController.text =
                                                    values[index].date;
                                                apresentadoController.text =
                                                    values[index].apresentado;
                                                cupomController.text =
                                                    values[index].cupom;
                                                valorController.text =
                                                    values[index].valor;
                                                valorRecusadoController.text =
                                                    values[index].recusado;
                                                motivoController.text =
                                                    values[index].motivo;
                                                despesa.values.removeAt(index);
                                                if (despesa.values.isEmpty) {
                                                  list.deleteDespesa(despesa);
                                                }
                                                Navigator.pop(context);
                                                setState(() {});
                                              },
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Container(
                                            padding: const EdgeInsets.all(30),
                                            child: TextButton(
                                              child: const Text("Excluir"),
                                              onPressed: () {
                                                despesa.values.removeAt(index);
                                                if (despesa.values.isEmpty) {
                                                  list.deleteDespesa(despesa);
                                                }
                                                Navigator.pop(context);
                                                setState(() {});
                                              },
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                              child: Icon(
                                Icons.menu,
                                size: 14,
                                color: Colors.orange[800],
                              ),
                            ),
                          );
                        }),
                      ],
                    ),
                  ],
                ),
              ),
              generateTotal(index),
            ],
          );
        },
      ),
    );
  }
}
