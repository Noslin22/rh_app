import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:printing/printing.dart';
import 'package:rh_app/models/pastor_model.dart';
import 'package:rh_app/pages/home/widgets/display_despesas.dart';
import 'package:rh_app/pages/home/widgets/home_appbar.dart';
import 'package:rh_app/pages/pdf/pdf_page.dart' as pdf;
import 'package:rh_app/pdf/despesas_pdf.dart';
import 'package:rh_app/widgets/input_field_widget.dart';
import 'package:rh_app/widgets/list_field_widget.dart';

import '../../consts.dart';
import '../../models/despesa_model.dart';
import 'core/function.dart';
import 'core/variables.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  Widget build(BuildContext context) {
    cpfController = TextEditingController(text: cpfs[0]);
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size(double.infinity, 50),
        child: HomeAppbar(),
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
                                      .where((element) {
                                    return element.campo == provider.campo;
                                  }).toList();
                                  obreiros = pastores;
                                  return ListField<PastorModel>(
                                    icon: Icons.person,
                                    label: "Obreiro",
                                    focusNode: nodes[0],
                                    controller: pastorController,
                                    suggestions: pastores,
                                    searchBy: "nome",
                                    selected: (pastor) {
                                      setState(() {
                                        cpfs[0] = pastor.cpf + " ";
                                        cpfs[1] = pastor.cpf2 + " ";
                                      });
                                      pastorController.text =
                                          pastor.nome.trim();
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
                                      ).then(
                                        (value) {
                                          if (value == null) {
                                            Builder(
                                              builder: (context) {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  const SnackBar(
                                                    content: Text(
                                                      "Selecione um mês",
                                                    ),
                                                    duration:
                                                        Duration(seconds: 2),
                                                  ),
                                                );
                                                return Container();
                                              },
                                            );
                                          } else {
                                            periodoController.text =
                                                "${value.month < 10 ? "0" + value.month.toString() : value.month.toString()}/${value.year.toString()}";
                                          }
                                        },
                                      ).then(
                                        (_) {
                                          FocusScope.of(context)
                                              .requestFocus(nodes[1]);
                                        },
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
                          child: Padding(
                            padding: const EdgeInsets.only(
                              top: 4,
                              left: 4,
                              bottom: 4,
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12),
                              child: DropdownButton<String>(
                                items: cpfs
                                    .map(
                                      (e) => DropdownMenuItem<String>(
                                        child: Text(e),
                                        value: e,
                                      ),
                                    )
                                    .toList(),
                                onChanged: cpfs.first == "" ? null : (_) {},
                                icon: Container(),
                                hint: Row(
                                  children: const [
                                    Icon(Icons.payment),
                                    Text("CPF"),
                                  ],
                                ),
                                value: cpfs[0] == "" ? null : cpfs[0],
                                underline: Container(),
                                borderRadius: BorderRadius.circular(10),
                                iconDisabledColor: Colors.black,
                              ),
                            ),
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
                            icon: Icons.event,
                            label: "Período",
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          flex: 2,
                          child: StreamBuilder<QuerySnapshot>(
                            stream: despesas,
                            builder: (_, snapshot) {
                              if (snapshot.hasData) {
                                List<String> despesas = snapshot.data!.docs
                                    .map((e) => e["nome"].toString() + " ")
                                    .toList();
                                despesasList = despesas;
                                return ListField<String>(
                                  focusNode: nodes[1],
                                  icon: Icons.sticky_note_2,
                                  controller: despesaController,
                                  suggestions: despesasList,
                                  label: "Despesa",
                                  selected: (value) {
                                    showDatePicker(
                                      locale: const Locale("pt", "BR"),
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime(
                                        DateTime.now().year,
                                      ),
                                      lastDate:
                                          DateTime(DateTime.now().year, 12),
                                    ).then(
                                      (value) {
                                        if (value == null) {
                                          Builder(
                                            builder: (context) {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                const SnackBar(
                                                  content: Text(
                                                      "Selecione uma data"),
                                                  duration:
                                                      Duration(seconds: 2),
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
                                        FocusScope.of(context)
                                            .requestFocus(nodes[2]);
                                      },
                                    );
                                  },
                                );
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
                          child: InputField(
                            controller: dateController,
                            icon: Icons.calendar_today,
                            label: "Data",
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
                            label: "N° Documento",
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
                          if (formKey.currentState!.validate()) {
                            clearFields();
                            submit();
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
                    const DisplayDespesas()
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
                      ? pdf.PdfView(
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
    );
  }
}
