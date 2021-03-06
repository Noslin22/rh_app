class ValueModel {
  final String apresentado;
  final String cupom;
  final String valor;
  final String recusado;
  final String pastor;
  final String cpf;
  final String periodo;
  final String motivo;
  final String date;

  ValueModel({
    required this.apresentado,
    required this.cupom,
    required this.valor,
    required this.recusado,
    required this.pastor,
    required this.cpf,
    required this.periodo,
    required this.motivo,
    required this.date,
  });

  @override
  String toString() {
    return 'ValueModel(apresentado: $apresentado, cupom: $cupom, valor: $valor, recusado: $recusado, motivo: $motivo, pastor: $pastor, cpf: $cpf, periodo: $periodo, data: $date)';
  }
}
