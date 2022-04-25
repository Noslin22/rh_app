import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class PastorModel {
  final String nome;
  final String cpf;
  final String campo;
  PastorModel({
    required this.nome,
    required this.cpf,
    required this.campo,
  });

  Map<String, dynamic> toJson() {
    return {
      'nome': nome,
      'cpf': cpf,
      'campo': campo,
    };
  }

  factory PastorModel.fromDocument(QueryDocumentSnapshot e) {
    return PastorModel(nome: e["nome"] + " ", cpf: e["cpf"], campo: e["campo"]);
  }

  Map<String, dynamic> toMap() {
    return {
      'nome': nome,
      'cpf': cpf,
      'campo': campo,
    };
  }

  factory PastorModel.fromMap(Map<String, dynamic> map) {
    return PastorModel(
      nome: map['nome'] ?? '',
      cpf: map['cpf'] ?? '',
      campo: map['campo'] ?? '',
    );
  }

  factory PastorModel.fromJson(String source) => PastorModel.fromMap(json.decode(source));
}
