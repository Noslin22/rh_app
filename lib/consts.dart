import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:field_suggestion/field_suggestion.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';

final FirebaseFirestore db = FirebaseFirestore.instance;

final BoxController pastorBox = BoxController();
final BoxController despesaBox = BoxController();
final GlobalKey<FormState> formKey = GlobalKey<FormState>();

String cpf = "";

final TextEditingController pastorController = TextEditingController();
final TextEditingController despesaController = TextEditingController();
final TextEditingController periodoController = TextEditingController();
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

List<FocusNode> nodes = List.generate(8, (_) => FocusNode());
