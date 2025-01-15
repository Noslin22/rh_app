import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:printing/printing.dart';
import 'package:scr_project/models/pastor_model.dart';
import 'package:scr_project/pages/home/widgets/display_despesas.dart';
import 'package:scr_project/pages/home/widgets/home_appbar.dart';
import 'package:scr_project/pages/pdf/pdf_page.dart' as pdf;
import 'package:scr_project/pdf/despesas_pdf.dart';
import 'package:scr_project/widgets/input_field_widget.dart';
import 'package:scr_project/widgets/list_field_widget.dart';
import 'package:url_launcher/link.dart';

import '../../consts.dart';
import 'core/function.dart';
import 'core/variables.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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

  @override
  void initState() {
    super.initState();
    init();
    valorController.addListener(valorListener);
    valorRecusadoController.addListener(valorRecusadoListener);

    nodes[2].addListener(onFocus2Listener);
    nodes[4].addListener(onFocus4Listener);
    nodes[5].addListener(onFocus5Listener);

    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) {
            return AlertDialog(
              title: const Text("Dê seu feedback"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Com o intuito de aprimorar o SCR pedimos que você contribua mandando melhorias.",
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 24, bottom: 6),
                    child: Text('Nossos Contatos:'),
                  ),
                  Link(
                    uri: Uri.parse(
                      'mailto:joaonilsoneto2@gmail.com?subject=Atualização%20SCR',
                    ),
                    target: LinkTarget.blank,
                    builder: (context, openLink) {
                      return Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text('Email:'),
                          TextButton(
                            onPressed: openLink,
                            child: const Text(
                              'joaonilsoneto2@gmail.com',
                              style: TextStyle(
                                color: Colors.blue,
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                  Link(
                    uri: Uri.parse(
                      'https://wa.me/75999302754?text=Gostaria%20de%20sugerir%20algumas%20melhorias%20para%20o%20SCR',
                    ),
                    target: LinkTarget.blank,
                    builder: (context, openLink) {
                      return Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text('Whatsapp:'),
                          TextButton(
                            onPressed: openLink,
                            child: const Text(
                              '(75) 99930-2754',
                              style: TextStyle(
                                color: Colors.blue,
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                  ...DateTime.now().isBefore(DateTime(2025, 02, 01))
                      ? [
                          const SizedBox(
                            height: 16,
                          ),
                          const Text(
                            'Atualizações:',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const Text(
                            '   Agora é possível acessar anos anteriores;',
                          ),
                          const Text(
                            '     Alteração sugerida por Katiuscia Souza - ABaC;',
                            style: TextStyle(fontSize: 14),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          const Text(
                            '   As despesas agora são todas indexadas automaticamente (Todas vão possuir um número);',
                          ),
                          const Text('   Correção de Bugs.'),
                          const SizedBox(
                            height: 20,
                          ),
                          const Text(
                            '   Versão 1.3.2',
                            style: TextStyle(fontSize: 10),
                          ),
                        ]
                      : []
                ],
              ),
              actions: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 16, right: 16),
                  child: TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text(
                      'OK',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void selectMonth() {
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

  void selectDate() {
    showDatePicker(
      locale: const Locale("pt", "BR"),
      context: context,
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
                                List<PastorModel> pastores = snapshot.data!.docs
                                    .map((e) => PastorModel.fromDocument(e))
                                    .where((element) {
                                  return element.campo == authService.campo;
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
                                      cpfs[0] = "${pastor.cpf} ";
                                      cpfs[1] = "${pastor.cpf2} ";
                                    });
                                    pastorController.text = pastor.nome.trim();
                                    selectMonth();
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
                                    .where((e) => e.isNotEmpty)
                                    .map(
                                      (e) => DropdownMenuItem<String>(
                                        value: e,
                                        child: Text(e),
                                      ),
                                    )
                                    .toList(),
                                onChanged: cpfs.any((e) => e.isEmpty)
                                    ? null
                                    : (cpf) {
                                        setState(() {
                                          if (cpf != null) {
                                            selectedCpf = cpfs.indexOf(cpf);
                                          }
                                        });
                                      },
                                icon: Container(),
                                hint: const Row(
                                  children: [
                                    Icon(Icons.payment),
                                    Text("CPF"),
                                  ],
                                ),
                                value: cpfs[selectedCpf] == ""
                                    ? null
                                    : cpfs[selectedCpf],
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
                            readOnly: true,
                            onTap: selectMonth,
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
                                    selectDate();
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
                            onTap: selectDate,
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
                            submit();
                            clearFields();
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
