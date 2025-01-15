import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:scr_project/models/despesa_model.dart';
import 'package:scr_project/models/value_model.dart';

class DespesaListModel extends ChangeNotifier {
  final List<DespesaModel> _despesas = [];
  UnmodifiableListView<DespesaModel> get allDespesas =>
      UnmodifiableListView(_despesas);

  void addDespesa(DespesaModel despesa) {
    _despesas.add(despesa);
    notifyListeners();
  }

  void deleteDespesa(DespesaModel despesa) {
    _despesas.remove(despesa);
    notifyListeners();
  }

  void addValue(String despesaName, ValueModel value) {
    _despesas
        .where((element) => element.name == despesaName)
        .first
        .values
        .add(value);
    notifyListeners();
  }

  void clear() {
    _despesas.clear();
    notifyListeners();
  }
}
