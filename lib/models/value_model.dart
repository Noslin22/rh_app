class ValueModel {
  final String apresentado;
  final String cupom;
  final String valor;
  final String recusado;
  final String motivo;
  
  ValueModel({
    required this.apresentado,
    required this.cupom,
    required this.valor,
    required this.recusado,
    required this.motivo,
  });

  @override
  String toString() {
    return 'ValueModel(apresentado: $apresentado, cupom: $cupom, valor: $valor, recusado: $recusado, motivo: $motivo)';
  }
}
