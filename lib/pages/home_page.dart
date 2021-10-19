import 'dart:async';
import 'dart:io';
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

  String filePath = "";
  bool pdfSelected = false;

  List<DespesaModel> list = [];

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

  @override
  Widget build(BuildContext context) {
    cpfController = TextEditingController(text: cpf);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        title: const Text("RH APP"),
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => PastorDialog(),
              );
            },
            icon: const Icon(Icons.person),
          ),
          IconButton(
            onPressed: () {
              Printing.layoutPdf(onLayout: (format) {
                return buildPdf(despesas: list);
              });
            },
            icon: const Icon(Icons.print),
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
                                  return ListField(
                                    icon: Icons.today,
                                    label: "Pastor",
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
                                            (value) => periodoController.text =
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
                              FocusScope.of(context).requestFocus(nodes[3]);
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
                            label: "Apresentado",
                            controller: apresentadoController,
                            focusNode: nodes[3],
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: InputField(
                            icon: Icons.payments,
                            label: "Cupom Fiscal",
                            controller: cupomController,
                            focusNode: nodes[4],
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
                            label: "Valor",
                            controller: valorController,
                            focusNode: nodes[5],
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: InputField(
                            icon: Icons.money_off,
                            label: "Valor Recusado",
                            controller: valorRecusadoController,
                            focusNode: nodes[6],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    InputField(
                        icon: Icons.not_listed_location,
                        label: "Motivo",
                        controller: motivoController,
                        focusNode: nodes[7],
                        submit: () {
                          String despesa = despesaController.text;
                          if (list
                              .where((element) => element.name == despesa)
                              .isNotEmpty) {
                            list
                                .where((element) => element.name == despesa)
                                .first
                                .values
                                .add(
                                  ValueModel(
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
                        String despesa = despesaController.text;

                        if (despesa.isNotEmpty &&
                            pastorController.text.isNotEmpty &&
                            cupomController.text.isNotEmpty &&
                            periodoController.text.isNotEmpty) {
                          if (list
                              .where((element) => element.name == despesa)
                              .isNotEmpty) {
                            list
                                .where((element) => element.name == despesa)
                                .first
                                .values
                                .add(
                                  ValueModel(
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
                          return ListTile(
                            title: Container(
                              padding: const EdgeInsets.only(left: 16),
                              color: Colors.grey[300],
                              child: Text(
                                despesa.name,
                                style: const TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                            ),
                            subtitle: Flexible(
                              child: ListView.builder(
                                itemBuilder: (context, index) {
                                  if (index == 0) {
                                    return Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 10),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: const [
                                          Text(
                                            "Apresentado",
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.black,
                                            ),
                                          ),
                                          Text(
                                            "CF",
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.black,
                                            ),
                                          ),
                                          Text(
                                            "Valor",
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.black,
                                            ),
                                          ),
                                          Text(
                                            "NF Rejeitada",
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.black,
                                            ),
                                          ),
                                          Text(
                                            "Motivo",
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  } else if (despesa.values.length + 1 ==
                                      index) {
                                    double parse(String value) {
                                      value = value.replaceRange(0, 2, "");
                                      value = value
                                          .replaceAll(".", "")
                                          .replaceAll(",", ".");
                                      return double.parse(value);
                                    }

                                    double aceito = 0;
                                    double recusado = 0;
                                    for (var e in despesa.values) {
                                      aceito += parse(e.valor);
                                      recusado += parse(e.recusado);
                                    }
                                    return Padding(
                                      padding: const EdgeInsets.only(top: 14),
                                      child: Row(
                                        children: [
                                          Text(
                                            "Total Apresentado: R\$${MoneyMaskedTextController(initialValue: recusado + aceito).text}",
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
                                  } else {
                                    ValueModel value =
                                        despesa.values[index - 1];
                                    return Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          value.apresentado,
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black,
                                          ),
                                        ),
                                        Text(
                                          value.cupom,
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black,
                                          ),
                                        ),
                                        Text(
                                          value.valor,
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black,
                                          ),
                                        ),
                                        Text(
                                          value.recusado,
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black,
                                          ),
                                        ),
                                        Text(
                                          value.motivo,
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ],
                                    );
                                  }
                                },
                                itemCount: despesa.values.length + 2,
                                shrinkWrap: true,
                              ),
                            ),
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
                        path: filePath,
                      )
                    : Center(
                        child: ElevatedButton(
                          onPressed: () async {
                            FilePickerResult? result =
                                await FilePicker.platform.pickFiles();
                            if (result != null) {
                              File file = File(result.files.single.path!);
                              filePath = file.path;
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
    );
  }
}
