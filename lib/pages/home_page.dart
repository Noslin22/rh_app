import 'dart:async';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:printing/printing.dart';
import 'package:rh_app/models/despesa_model.dart';
import 'package:rh_app/models/pastor_model.dart';
import 'package:rh_app/models/value_model.dart';
import 'package:rh_app/pages/pdf_page.dart';
import 'package:rh_app/pdf/despesas_pdf.dart';
import 'package:rh_app/provider/auth_provider.dart';
import 'package:rh_app/widgets/despesa_dialog_widget.dart';
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
  AuthProvider provider = AuthProvider(auth: FirebaseAuth.instance);
  String? nome;

  final TextEditingController pastorController = TextEditingController();
  final TextEditingController despesaController = TextEditingController();
  final Stream<QuerySnapshot> pastores = db.collection("pastores").snapshots();
  final Stream<QuerySnapshot> despesas =
      db.collection("despesas").orderBy("nome").snapshots();

  Uint8List? data;
  bool pdfSelected = false;

  List<DespesaModel> list = [];

  @override
  void initState() {
    super.initState();

    List<String> nomes =
        provider.auth.currentUser!.email!.replaceAll("_", " ").split(" ");
    List<String> first = nomes[0].split("");
    List<String> last = nomes[1].split("@")[0].split("");
    first = [first.first.toUpperCase(), ...first.sublist(1, first.length)];
    last = [last.first.toUpperCase(), ...last.sublist(1, last.length)];
    nome = "${first.join()} ${last.join()}";
  }

  List<String> fields = [
    "Apresentado",
    "N° Documento",
    "Valor Aceito",
    "Valor Recusado",
    "Motivo",
  ];

  void clearFields({bool all = false}) {
    if (all) {
      pastorController.clear();
      cpf = "";
      periodoController.clear();
    }
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
          title: const Text("Sistema de Conferência de Relatório"),
          elevation: 0,
          actions: [
            Tooltip(
              message: "Sair",
              child: IconButton(
                onPressed: () {
                  AuthProvider(auth: FirebaseAuth.instance).signOut();
                },
                icon: const Icon(Icons.vpn_key),
              ),
            ),
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
              message: "Gerenciar Despesa",
              child: IconButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => const DespesaDialog(),
                  );
                },
                icon: const Icon(Icons.note_add),
              ),
            ),
            Tooltip(
              message: "Novo Relatório",
              child: IconButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text("Novo Relatório"),
                      content: const Text(
                          "Deseja começar um novo relatório de outro obreiro"),
                      actions: [
                        ElevatedButton(
                          onPressed: () {
                            pdfSelected = false;
                            clearFields(all: true);
                            list = [];
                            Navigator.pop(context);
                            setState(() {});
                          },
                          child: const Text("Sim"),
                        ),
                        ElevatedButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text("Não"),
                        ),
                      ],
                    ),
                  );
                },
                icon: const Icon(Icons.add_chart),
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
                            child: StreamBuilder<String?>(
                              stream: db
                                  .collection("users")
                                  .where("nome", isEqualTo: nome)
                                  .get()
                                  .then(
                                (value) {
                                  provider.campo =
                                      value.docs.single["campo"].toString();
                                  return value.docs.single["campo"].toString();
                                },
                              ).asStream(),
                              builder: (_, campo) {
                                if (campo.hasData) {
                                  return StreamBuilder<QuerySnapshot>(
                                      stream: pastores,
                                      builder: (context, snapshot) {
                                        if (snapshot.hasData) {
                                          List<PastorModel> pastores = snapshot
                                              .data!.docs
                                              .map((e) =>
                                                  PastorModel.fromDocument(e))
                                              .where((element) =>
                                                  element.campo == campo.data)
                                              .toList();
                                          obreiros = pastores;
                                          return ListField<PastorModel>(
                                            icon: Icons.person,
                                            label: "Obreiro",
                                            focusNode: nodes[0],
                                            controller: pastorController,
                                            suggestions: pastores,
                                            searchBy: "nome",
                                            box: pastorBox,
                                            selected: (pastor) {
                                              setState(() {
                                                cpf = pastor.cpf;
                                              });
                                              pastorController.text =
                                                  pastor.nome.trim();
                                              FocusScope.of(context)
                                                  .requestFocus(nodes[1]);
                                              showMonthPicker(
                                                locale:
                                                    const Locale("pt", "BR"),
                                                context: context,
                                                initialDate: DateTime.now(),
                                                firstDate: DateTime(
                                                  DateTime.now().year,
                                                ),
                                                lastDate: DateTime(
                                                    DateTime.now().year, 12),
                                              )
                                                  .then(
                                                    (value) => periodoController
                                                            .text =
                                                        "${value!.month < 10 ? "0" + value.month.toString() : value.month.toString()}/${value.year.toString()}",
                                                  )
                                                  .then(
                                                    (_) => FocusScope.of(
                                                            context)
                                                        .requestFocus(nodes[1]),
                                                  );
                                            },
                                          );
                                        } else {
                                          return const LinearProgressIndicator();
                                        }
                                      });
                                } else {
                                  return const LinearProgressIndicator();
                                }
                              },
                            ),
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
                            child: StreamBuilder<QuerySnapshot>(
                                stream: despesas,
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    List<String> despesas = snapshot.data!.docs
                                        .map((e) => e["nome"].toString() + " ")
                                        .toList();
                                    despesasList = despesas;
                                    return ListField<String>(
                                      focusNode: nodes[1],
                                      icon: Icons.sticky_note_2,
                                      label: "Despesa",
                                      selected: (despesa) {
                                        despesaController.text = despesa.trim();
                                        FocusScope.of(context)
                                            .requestFocus(nodes[2]);
                                      },
                                      controller: despesaController,
                                      suggestions: despesasList,
                                      box: despesaBox,
                                    );
                                  } else {
                                    return const LinearProgressIndicator();
                                  }
                                }),
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
                        child: const Text("Imprimir"),
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
                          itemCount: list.length,
                          shrinkWrap: true,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  width: 16,
                ),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(10)),
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
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
