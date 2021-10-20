import 'dart:typed_data';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:rh_app/models/despesa_model.dart';
import 'package:rh_app/models/value_model.dart';

Future<Uint8List> buildPdf({required List<DespesaModel> despesas}) async {
  final Document doc = Document();

  final List<String> fields = [
    "Apresentado",
    "Cupom",
    "Valor",
    "Valor Recusado",
    "Motivo",
  ];

  Widget generateTotal(int index){
    double parse(String value) {
      value = value.replaceRange(0, 2, "");
      value = value.replaceAll(".", "").replaceAll(",", ".");
      return double.parse(value);
    }

    double aceito = 0;
    double recusado = 0;
    double apresentado = 0;
    for (var e in despesas[index].values) {
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
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: PdfColors.black,
              fontSize: 12,
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
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: PdfColors.black,
                  fontSize: 12,
                ),
              ),
            ),
          ),
          SizedBox(width: 26),
          Text(
            "Total Recusado: R\$${MoneyMaskedTextController(initialValue: recusado).text}",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: PdfColors.black,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  PdfPageFormat? format;
  doc.addPage(
    MultiPage(
      build: (Context context) {
        return List.generate(
          despesas.length,
          (index) {
            DespesaModel despesa = despesas[index];
            List<ValueModel> values = despesa.values;
            return Flex(
              mainAxisSize: MainAxisSize.min,
              direction: Axis.vertical,
              children: [
                Container(
                  width: double.maxFinite,
                  padding: const EdgeInsets.only(left: 16),
                  color: PdfColors.grey300,
                  child: Text(
                    despesa.name,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                Flexible(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ...List.generate(
                        5,
                        (index) => Column(
                          children: [
                            Text(
                              fields[index],
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
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
                                    const EdgeInsets.symmetric(vertical: 4),
                                child: Text(
                                  variable,
                                  style: const TextStyle(
                                    fontSize: 14,
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
        );
      },
      pageFormat: format,
    ),
  );
  return await doc.save();
}
