import 'dart:io';

import 'package:field_suggestion/field_suggestion.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';
import 'package:native_pdf_view/native_pdf_view.dart';
import 'package:rh_app/consts.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart' as pdf;

import 'input_field_widget.dart';
import 'pastor_model.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const HomePage(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.indigo),
      title: "PDF View",
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late TextEditingController cpfController;
  String filePath = "";
  bool pdfSelected = false;

  List<PastorModel> pastores = [
    PastorModel(
      nome: "Denisson Dias",
      cpf: "192.168.915-68",
    ),
    PastorModel(
      nome: "João Nilson",
      cpf: "101.860.916-06",
    ),
    PastorModel(
      nome: "Pedro Dias",
      cpf: "012.345.678-90",
    ),
  ];

  List<String> despesas = [
    "Veículo",
    "Internet",
    "Medicamento",
    "Equipamento Profissional",
    "Água/Esgoto",
    "Climatização",
    "Telefone",
  ];

  @override
  Widget build(BuildContext context) {
    cpfController = TextEditingController(text: cpf);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        title: const Text("RH APP"),
        elevation: 0,
      ),
      body: Container(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        flex: 6,
                        child: FieldSuggestion.builder(
                          fieldDecoration: InputDecoration(
                            border: const OutlineInputBorder(),
                            label: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: const [
                                Icon(Icons.person),
                                Text("Pastores"),
                              ],
                            ),
                          ),
                          textController: pastorController,
                          suggestionList: pastores,
                          searchBy: const ["nome"],
                          boxController: pastorBox,
                          itemBuilder: (BuildContext context, int index) {
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  cpf = pastores[index].cpf;
                                });
                                pastorController.text = pastores[index].nome;
                              },
                              child: Card(
                                child: ListTile(
                                  title: Text(pastores[index].nome),
                                ),
                              ),
                            );
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
                        child: FieldSuggestion.builder(
                          fieldDecoration: InputDecoration(
                            border: const OutlineInputBorder(),
                            label: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: const [
                                Icon(Icons.sticky_note_2),
                                Text("Despesas"),
                              ],
                            ),
                          ),
                          textController: despesaController,
                          suggestionList: despesas,
                          boxController: despesaBox,
                          itemBuilder: (BuildContext context, int index) {
                            return GestureDetector(
                              onTap: () {
                                despesaController.text = despesas[index];
                              },
                              child: Card(
                                child: ListTile(
                                  title: Text(despesas[index]),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: InputField(
                          icon: Icons.today,
                          label: "Período",
                          controller: periodoController,
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
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(onPressed: () {}, child: const Text("Enviar")),
                ],
              ),
            ),
            Expanded(
              child: pdfSelected
                  ? PdfPage(
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
    );
  }
}

class PdfPage extends StatefulWidget {
  final String path;
  const PdfPage({
    Key? key,
    required this.path,
  }) : super(key: key);

  @override
  _PdfPageState createState() => _PdfPageState();
}

class _PdfPageState extends State<PdfPage> {
  
  @override
  Widget build(BuildContext context) {
    pdf.PdfDocument document =
    pdf.PdfDocument(inputBytes: File(widget.path).readAsBytesSync());
    final pdfController = PdfController(
      document: PdfDocument.openFile(widget.path),
    );

//Get first page
pdf.PdfPage page = document.pages[0];

//Get page rotation applied
pdf.PdfPageRotateAngle rotationAngle = page.rotation;

//Update rotation as 180 degree
page.rotation = pdf.PdfPageRotateAngle.rotateAngle180;

//Saves the document into a list of bytes
List<int> bytes = document.save();
    return Column(
      children: [
        Expanded(
          child: PdfView(controller: pdfController),
        ),
        const SizedBox(
          height: 10,
        ),
        Center(
          child: ElevatedButton(
            onPressed: () {
              pdfController.nextPage(
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeIn,
              );
            },
            child: const Text("Proxima pagina"),
          ),
        ),
      ],
    );
  }
}
