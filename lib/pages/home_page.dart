import 'dart:async';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:printing/printing.dart';
import 'package:rh_app/models/despesa_model.dart';
import 'package:rh_app/models/pastor_model.dart';
import 'package:rh_app/models/value_model.dart';
import 'package:rh_app/pages/pdf_page.dart';
import 'package:rh_app/pdf/despesas_pdf.dart';
import 'package:rh_app/widgets/input_field_widget.dart';
import 'package:rh_app/widgets/list_field_widget.dart';
import 'package:rh_app/widgets/pastor_dialog_widget.dart';

import '../consts.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late TextEditingController cpfController;
  final Stream<QuerySnapshot> pastores = db.collection("pastores").snapshots();

  Uint8List? data;
  bool pdfSelected = false;

  List<DespesaModel> list = [];

  List<String> fields = [
    "Apresentado",
    "Cupom",
    "Valor",
    "Valor Recusado",
    "Motivo",
  ];

  List<String> despesas = [
    "Veículo" " ",
    "Internet" " ",
    "Medicamento" " ",
    "Equipamento Profissional" " ",
    "Água/Esgoto" " ",
    "Climatização" " ",
    "Telefone" " ",
  ];

  void clearFields() {
    despesaController.clear();
    apresentadoController.text = "R\$0,00";
    cupomController.clear();
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

  @override
  Widget build(BuildContext context) {
    cpfController = TextEditingController(text: cpf);
    return GestureDetector(
      onTap: () {
        pastorBox.close!();
        despesaBox.close!();
        pastorController.text = "";
        despesaController.text = "";
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.indigo,
          title: const Text("Conferência de Relatório"),
          elevation: 0,
          actions: [
            Tooltip(
              message: "Gerenciar Obreiro",
              child: IconButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => const PastorDialog(),
                  );
                },
                icon: const Icon(Icons.person),
              ),
            ),
            Tooltip(
              message: "Imprimir",
              child: IconButton(
                onPressed: () {
                  Printing.layoutPdf(onLayout: (format) {
                    return buildPdf(
                      despesas: list,
                      date: meses[int.parse(
                              periodoController.text.split("/")[0])]! +
                          " / " +
                          periodoController.text.split("/")[1],
                    );
                  });
                },
                icon: const Icon(Icons.print),
              ),
            ),
          ],
        ),
        body: Container(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: formKey,
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            flex: 6,
                            child: StreamBuilder<QuerySnapshot>(
                                stream: pastores,
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    List<PastorModel> pastores = snapshot
                                        .data!.docs
                                        .map((e) => PastorModel.fromDocument(e))
                                        .toList();
                                    obreiros = pastores;
                                    return ListField(
                                      icon: Icons.person,
                                      label: "Obreiro",
                                      focusNode: nodes[0],
                                      controller: pastorController,
                                      suggestions: pastores,
                                      searchBy: true,
                                      box: pastorBox,
                                      selected: (pastor) {
                                        setState(() {
                                          cpf = pastor['cpf'];
                                        });
                                        pastorController.text =
                                            pastor["nome"].trim();
                                        FocusScope.of(context)
                                            .requestFocus(nodes[1]);
                                        showMonthPicker(
                                          locale: const Locale("pt", "BR"),
                                          context: context,
                                          initialDate: DateTime.now(),
                                          firstDate: DateTime(
                                            DateTime.now().year,
                                          ),
                                          lastDate:
                                              DateTime(DateTime.now().year, 12),
                                        )
                                            .then(
                                              (value) => periodoController
                                                      .text =
                                                  "${value!.month < 10 ? "0" + value.month.toString() : value.month.toString()}/${value.year.toString()}",
                                            )
                                            .then(
                                              (_) => FocusScope.of(context)
                                                  .requestFocus(nodes[1]),
                                            );
                                      },
                                    );
                                  } else {
                                    return const LinearProgressIndicator();
                                  }
                                }),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            flex: 2,
                            child: InputField(
                              icon: Icons.payment,
                              controller: cpfController,
                              label: "CPF",
                              readOnly: true,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Expanded(
                              child: InputField(
                            controller: periodoController,
                            icon: Icons.today,
                            label: "Período",
                          )),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: ListField(
                              focusNode: nodes[1],
                              icon: Icons.sticky_note_2,
                              label: "Despesa",
                              selected: (despesa) {
                                despesaController.text = despesa.trim();
                                FocusScope.of(context).requestFocus(nodes[2]);
                              },
                              controller: despesaController,
                              suggestions: despesas,
                              box: despesaBox,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: InputField(
                              icon: Icons.monetization_on,
                              label: fields[0],
                              controller: apresentadoController,
                              focusNode: nodes[2],
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: InputField(
                              icon: Icons.payments,
                              label: fields[1],
                              controller: cupomController,
                              focusNode: nodes[3],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: InputField(
                              icon: Icons.attach_money,
                              label: fields[2],
                              controller: valorController,
                              focusNode: nodes[4],
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: InputField(
                              icon: Icons.money_off,
                              label: fields[3],
                              controller: valorRecusadoController,
                              focusNode: nodes[5],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      InputField(
                          icon: Icons.not_listed_location,
                          label: fields[4],
                          controller: motivoController,
                          focusNode: nodes[6],
                          submit: () {
                            submit();
                            if (formKey.currentState!.validate()) {
                              clearFields();
                              setState(() {});
                            }
                          }),
                      const SizedBox(
                        height: 10,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          submit();
                          if (formKey.currentState!.validate()) {
                            clearFields();
                            setState(() {});
                          }
                        },
                        child: const Text("Inserir"),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Flexible(
                        child: ListView.builder(
                          itemBuilder: (context, index) {
                            DespesaModel despesa = list[index];
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
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  subtitle: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      ...List.generate(
                                        5,
                                        (index) => Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              fields[index],
                                              style: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                              ),
                                            ),
                                            ...List.generate(values.length,
                                                (i) {
                                              ValueModel value = values[i];
                                              late String variable;
                                              switch (index) {
                                                case 0:
                                                  variable = value.apresentado;
                                                  break;
                                                case 1:
                                                  variable = value.cupom;
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
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 8),
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
                                          ...List.generate(values.length,
                                              (index) {
                                            return Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 8),
                                              child: GestureDetector(
                                                onTap: () {
                                                  showModalBottomSheet(
                                                    context: context,
                                                    builder: (context) {
                                                      return Row(
                                                        children: [
                                                          Expanded(
                                                            child: Container(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(30),
                                                              child: TextButton(
                                                                child: const Text(
                                                                    "Editar"),
                                                                onPressed: () {
                                                                  pastorController
                                                                      .text = values[
                                                                          index]
                                                                      .pastor;
                                                                  despesaController
                                                                          .text =
                                                                      despesa
                                                                          .name;
                                                                  periodoController
                                                                      .text = values[
                                                                          index]
                                                                      .periodo;
                                                                  apresentadoController
                                                                      .text = values[
                                                                          index]
                                                                      .apresentado;
                                                                  cupomController
                                                                          .text =
                                                                      values[index]
                                                                          .cupom;
                                                                  valorController
                                                                          .text =
                                                                      values[index]
                                                                          .valor;
                                                                  valorRecusadoController
                                                                      .text = values[
                                                                          index]
                                                                      .recusado;
                                                                  motivoController
                                                                      .text = values[
                                                                          index]
                                                                      .motivo;
                                                                  despesa.values
                                                                      .removeAt(
                                                                          index);
                                                                  if (despesa
                                                                      .values
                                                                      .isEmpty) {
                                                                    list.removeWhere((element) =>
                                                                        element
                                                                            .name ==
                                                                        despesa
                                                                            .name);
                                                                  }
                                                                  Navigator.pop(
                                                                      context);
                                                                  setState(
                                                                      () {});
                                                                },
                                                              ),
                                                            ),
                                                          ),
                                                          Expanded(
                                                            child: Container(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(30),
                                                              child: TextButton(
                                                                child: const Text(
                                                                    "Excluir"),
                                                                onPressed: () {
                                                                  despesa.values
                                                                      .removeAt(
                                                                          index);
                                                                  if (despesa
                                                                      .values
                                                                      .isEmpty) {
                                                                    list.removeWhere((element) =>
                                                                        element
                                                                            .name ==
                                                                        despesa
                                                                            .name);
                                                                  }
                                                                  Navigator.pop(
                                                                      context);
                                                                  setState(
                                                                      () {});
                                                                },
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      );
                                                    },
                                                  );
                                                },
                                                child: const Icon(
                                                  Icons.menu,
                                                  size: 14,
                                                  color: Colors.orange,
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
                          itemCount: list.length,
                          shrinkWrap: true,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: pdfSelected
                      ? PdfView(
                          data: data!,
                        )
                      : Center(
                          child: ElevatedButton(
                            onPressed: () async {
                              FilePickerResult? result =
                                  await FilePicker.platform.pickFiles();
                              if (result != null) {
                                data = result.files.single.bytes!;
                                setState(() {
                                  pdfSelected = true;
                                });
                              }
                            },
                            child: const Text("Selecionar o PDF"),
                          ),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
