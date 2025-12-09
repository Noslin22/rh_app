import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:printing/printing.dart';
import 'package:scr_project/pages/home/home_controller.dart';
import 'package:scr_project/pages/home/widgets/display_despesas.dart';
import 'package:scr_project/pages/home/widgets/home_appbar.dart';
import 'package:scr_project/pages/home/widgets/initial_dialog.dart';
import 'package:scr_project/pages/home/widgets/inputs/cpf_field.dart';
import 'package:scr_project/pages/home/widgets/inputs/obreiro_field.dart';
import 'package:scr_project/pages/pdf/pdf_page.dart' as pdf;
import 'package:scr_project/pdf/despesas_pdf.dart';
import 'package:scr_project/widgets/input_field_widget.dart';
import 'package:scr_project/widgets/list_field_widget.dart';

import '../../consts.dart';
import 'core/function.dart';
import 'core/variables.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final controller = HomeController();

  @override
  void initState() {
    super.initState();
    init();
    showInitialDialog(context);
  }

  @override
  void dispose() {
    super.dispose();
    valorController.removeListener(valorListener);
    valorRecusadoController.removeListener(valorRecusadoListener);

    nodes[2].removeListener(onFocus2Listener);
    nodes[4].removeListener(onFocus4Listener);
    nodes[5].removeListener(onFocus5Listener);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(double.infinity, 50),
        child: HomeAppbar(
          controller: controller,
        ),
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
                        ObreiroField(controller: controller),
                        const SizedBox(
                          width: 10,
                        ),
                        CpfField(controller: controller),
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
                            readOnly: true,
                            onTap: () {
                              selectMonth(context);
                            },
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
                                    .map((e) => "${e["nome"]} ")
                                    .toList();
                                despesasList = despesas;
                                return ListField<String>(
                                  focusNode: nodes[1],
                                  icon: Icons.sticky_note_2,
                                  controller: despesaController,
                                  suggestions: despesasList,
                                  label: "Despesa",
                                  selected: (value) {
                                    despesaController.text = value;
                                    selectDate(context);
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
                            onTap: () => selectDate(context),
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
                            submit(controller.currentCpf);
                            controller.clearFields();
                            setState(() {});
                          }
                        }),
                    const SizedBox(
                      height: 10,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (list.allDespesas.isNotEmpty) {
                          Printing.layoutPdf(onLayout: (format) {
                            return buildPdf(
                              despesas: list.allDespesas,
                              date:
                                  "${meses[int.parse(periodoController.text.split("/")[0])]!} / ${periodoController.text.split("/")[1]}",
                            );
                          });
                        }
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
              ValueListenableBuilder(
                valueListenable: controller.pdfEnabledNotifier,
                builder: (context, pdfEnabled, _) {
                  if (pdfEnabled) {
                    return Expanded(
                      child: ValueListenableBuilder<bool>(
                        valueListenable: pdfSelectedNotifier,
                        builder: (context, selected, _) {
                          return Container(
                            decoration: BoxDecoration(
                                border: Border.all(),
                                borderRadius: BorderRadius.circular(10)),
                            child: selected
                                ? pdf.PdfView(
                                    data: data!,
                                  )
                                : Center(
                                    child: ElevatedButton(
                                      onPressed: () async {
                                        FilePickerResult? result =
                                            await FilePicker.platform
                                                .pickFiles();
                                        if (result != null) {
                                          data = result.files.single.bytes;
                                          setState(() {
                                            pdfSelected = true;
                                          });
                                        }
                                      },
                                      child: const Text("Selecionar o PDF"),
                                    ),
                                  ),
                          );
                        },
                      ),
                    );
                  } else {
                    return Container();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
