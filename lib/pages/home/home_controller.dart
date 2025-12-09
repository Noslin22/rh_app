import 'package:flutter/widgets.dart';
import 'package:scr_project/consts.dart';
import 'package:scr_project/pages/home/core/variables.dart';

class HomeController {
  final cpfNotifier = ValueNotifier<List<String>>(['', '']);
  List<String> get cpfs => cpfNotifier.value;
  set cpfs(List<String> model) => cpfNotifier.value = model;

  final selectedCpfNotifier = ValueNotifier<int>(0);
  int get selectedCpf => selectedCpfNotifier.value;
  set selectedCpf(int index) => selectedCpfNotifier.value = index;

  final pdfEnabledNotifier = ValueNotifier<bool>(true);
  bool get pdfEnabled => pdfEnabledNotifier.value;
  switchPdfEnabled() => pdfEnabledNotifier.value = !pdfEnabledNotifier.value;

  String get currentCpf => cpfs[selectedCpf];

  void clearFields({bool all = false}) {
    if (all) {
      pastorController.clear();
      cpfs = ['', ''];
      selectedCpf = 0;
      periodoController.clear();
    }
    despesaController.clear();
    apresentadoController.text = "R\$0,00";
    cupomController.clear();
    dateController.clear();
    valorController.text = "R\$0,00";
    valorRecusadoController.text = "R\$0,00";
    motivoController.clear();
  }
}
