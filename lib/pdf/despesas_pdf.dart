import 'package:flutter/services.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:scr_project/models/despesa_model.dart';
import 'package:scr_project/models/value_model.dart';

import '../consts.dart';

Future<Uint8List> buildPdf(
    {required List<DespesaModel> despesas, required String date}) async {
  final Document doc = Document();
  final ByteData image = await rootBundle.load("images/iasd-logo.png");
  final List<String> fields = [
    "Apresentado",
    "Nº Doc - Data",
    "Aceito",
    "Recusado",
    "Motivo",
  ];
  double totalAceito = 0;

  Widget generateTotal(int index) {
    double aceito = 0;
    double recusado = 0;
    double apresentado = 0;
    for (var e in despesas[index].values) {
      aceito += parse(e.valor);
      recusado += parse(e.recusado);
      apresentado += parse(e.apresentado);
    }
    totalAceito += aceito;

    return Padding(
      padding: const EdgeInsets.only(top: 4, bottom: 4),
      child: Row(
        children: [
          Text(
            "Total Apresentado: R\$${MoneyMaskedTextController(initialValue: apresentado).text}",
            style: const TextStyle(
              color: PdfColors.black,
              fontSize: 10,
            ),
          ),
          SizedBox(width: 26),
          Container(
            decoration: BoxDecoration(
              color: PdfColors.grey300,
              border: Border.all(),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Text(
                "Total Aceito: R\$${MoneyMaskedTextController(initialValue: aceito).text}",
                style: const TextStyle(
                  color: PdfColors.black,
                  fontSize: 10,
                ),
              ),
            ),
          ),
          SizedBox(width: 26),
          Text(
            "Total Recusado: R\$${MoneyMaskedTextController(initialValue: recusado).text}",
            style: const TextStyle(
              color: PdfColors.black,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }

  PdfPageFormat? format;
  doc.addPage(
    MultiPage(
      footer: (context) => Align(
        alignment: Alignment.centerRight,
        child: Text(
          "${context.pageNumber}/${context.pagesCount}",
        ),
      ),
      build: (Context context) {
        return [
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Image(
                    ImageProxy(
                      PdfImage.file(
                        doc.document,
                        bytes: image.buffer.asUint8List(),
                      ),
                    ),
                    height: 80,
                    width: 200),
                Text("Sistema de Conferência de Relatório - SCR"),
              ]),
          Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Obreiro: ${despesas[0].values[0].pastor}"),
              Text(date),
            ],
          ),
          Text("CPF: ${despesas[0].values[0].cpf}"),
          Divider(),
          SizedBox(height: 10),
          ...List.generate(
            despesas.length,
            (index) {
              DespesaModel despesa = despesas[index];
              List<ValueModel> values = despesa.values;
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: double.maxFinite,
                    padding: const EdgeInsets.only(left: 4),
                    color: PdfColors.grey300,
                    child: Text(
                      despesa.name,
                      style:
                          TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Flexible(
                    child: Row(
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
                                  fontSize: 10,
                                  color: PdfColors.black,
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
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 4),
                                  child: Text(
                                    variable.isEmpty ? "----------" : variable,
                                    style: const TextStyle(
                                      fontSize: 10,
                                      color: PdfColors.black,
                                    ),
                                  ),
                                );
                              }),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  generateTotal(index),
                ],
              );
            },
          ),
          Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Total Auxilio"),
              Text(MoneyMaskedTextController(initialValue: totalAceito).text),
            ],
          ),
          Divider(),
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text("Observação:"),
          ),
          Divider(),
        ];
      },
      pageFormat: format,
    ),
  );
  return await doc.save();
}
