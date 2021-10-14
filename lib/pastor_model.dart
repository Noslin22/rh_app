class PastorModel {
  final String nome;
  final String cpf;
  PastorModel({
    required this.nome,
    required this.cpf,
  });

  Map<String, dynamic> toJson() {
    return {
      'nome': nome,
      'cpf': cpf,
    };
  }
}
