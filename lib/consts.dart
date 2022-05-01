import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:field_suggestion/field_suggestion.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'models/pastor_model.dart';

final Map<int, String> meses = {
  1: "Janeiro",
  2: "Fevereiro",
  3: "Março",
  4: "Abril",
  5: "Maio",
  6: "Junho",
  7: "Julho",
  8: "Agosto",
  9: "Setembro",
  10: "Outubro",
  11: "Novembro",
  12: "Dezembro",
};

final FirebaseFirestore db = FirebaseFirestore.instance;

final BoxController pastorBox = BoxController();
final BoxController despesaBox = BoxController();
final BoxController cpfBox = BoxController();
final GlobalKey<FormState> formKey = GlobalKey<FormState>();

String cpf = "";

final TextEditingController periodoController = TextEditingController();
final TextEditingController dateController = TextEditingController();
final TextEditingController apresentadoController = MoneyMaskedTextController(
  decimalSeparator: ",",
  thousandSeparator: ".",
  precision: 2,
  leftSymbol: "R\$",
);
final TextEditingController cupomController = TextEditingController();
final TextEditingController valorController = MoneyMaskedTextController(
  decimalSeparator: ",",
  thousandSeparator: ".",
  precision: 2,
  leftSymbol: "R\$",
);
final TextEditingController valorRecusadoController = MoneyMaskedTextController(
  decimalSeparator: ",",
  thousandSeparator: ".",
  precision: 2,
  leftSymbol: "R\$",
);
final TextEditingController motivoController = TextEditingController();

List<PastorModel> obreiros = [];
List<String> despesasList = [];

List<FocusNode> nodes = List.generate(7, (_) => FocusNode());

double parse(String value) {
  value = value.replaceRange(0, 2, "");
  value = value.replaceAll(".", "").replaceAll(",", ".");
  return double.parse(value);
}
