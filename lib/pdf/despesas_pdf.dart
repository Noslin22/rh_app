import 'dart:typed_data';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:rh_app/models/despesa_model.dart';
import 'package:rh_app/models/value_model.dart';

Future<Uint8List> buildPdf({required List<DespesaModel> despesas}) async {
  final Document doc = Document();

  PdfPageFormat? format;
  doc.addPage(
    MultiPage(
      build: (Context context) {
        return List.generate(
          despesas.length,
          (index) {
            DespesaModel despesa = despesas[index];
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
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Flexible(
                      child: ListView.builder(
                        itemBuilder: (context, index) {
                          if (index == 0) {
                                    return Padding(
                                      padding:
                                         const EdgeInsets.only(bottom: 10),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "Apresentado",
                                            style: const TextStyle(
                                              fontSize: 12,
                                              color: PdfColors.black,
                                            ),
                                          ),
                                          Text(
                                            "CF",
                                            style: const TextStyle(
                                              fontSize: 12,
                                              color: PdfColors.black,
                                            ),
                                          ),
                                          Text(
                                            "Valor",
                                            style: const TextStyle(
                                              fontSize: 12,
                                              color: PdfColors.black,
                                            ),
                                          ),
                                          Text(
                                            "NF Rejeitada",
                                            style: const TextStyle(
                                              fontSize: 12,
                                              color: PdfColors.black,
                                            ),
                                          ),
                                          Text(
                                            "Motivo",
                                            style: const TextStyle(
                                              fontSize: 12,
                                              color: PdfColors.black,
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
                                    double apresentado =0;
                                    for (var e in despesa.values) {
                                      aceito += parse(e.valor);
                                      recusado += parse(e.recusado);
                                      apresentado += parse(e.apresentado);
                                    }
                                    return Padding(
                                      padding: const EdgeInsets.only(top: 14),
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
                                            fontSize: 12,
                                            color: PdfColors.black,
                                          ),
                                        ),
                                        Text(
                                          value.cupom,
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: PdfColors.black,
                                          ),
                                        ),
                                        Text(
                                          value.valor,
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: PdfColors.black,
                                          ),
                                        ),
                                        Text(
                                          value.recusado,
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: PdfColors.black,
                                          ),
                                        ),
                                        Text(
                                          value.motivo,
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: PdfColors.black,
                                          ),
                                        ),
                                      ],
                                    );
                                  }
                        },
                        itemCount: despesa.values.length + 2,
                      ),
                    ),
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
