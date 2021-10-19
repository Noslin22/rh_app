import 'package:cloud_firestore/cloud_firestore.dart';

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

  factory PastorModel.fromDocument(QueryDocumentSnapshot e) {
    return PastorModel(nome: e["nome"] + " ", cpf: e["cpf"]);
  }
}
