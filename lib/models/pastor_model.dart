import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class PastorModel {
  final String nome;
  final String cpf;
  final String cpf2;
  final String campo;
  PastorModel({
    required this.nome,
    required this.cpf,
    required this.cpf2,
    required this.campo,
  });

  Map<String, dynamic> toJson() {
    return {
      'nome': nome,
      'cpf': cpf,
      'campo': campo,
      'cpf2': cpf2,
    };
  }

  factory PastorModel.fromDocument(QueryDocumentSnapshot e) {
    return PastorModel(nome: e["nome"] + " ", cpf: e["cpf"], campo: e["campo"], cpf2: e["cpf2"]);
  }

  Map<String, dynamic> toMap() {
    return {
      'nome': nome,
      'cpf': cpf,
      'campo': campo,
      'cpf2': cpf2,
    };
  }

  factory PastorModel.fromMap(Map<String, dynamic> map) {
    return PastorModel(
      nome: map['nome'] ?? '',
      cpf: map['cpf'] ?? '',
      campo: map['campo'] ?? '',
      cpf2: map['cpf2'] ?? '',
    );
  }

  factory PastorModel.fromJson(String source) =>
      PastorModel.fromMap(json.decode(source));
}
