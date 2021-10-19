import 'package:rh_app/models/value_model.dart';

class DespesaModel {
  final String name;
  final List<ValueModel> values;
  DespesaModel({
    required this.name,
    required this.values,
  });

  @override
  String toString() => 'DespesaModel(name: $name, values: ${values.map((e) => e.toString()).toString()})';
}
