import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:scr_project/models/despesa_list_model.dart';

import '../../../consts.dart';
import '../../../service/auth_service.dart';

AuthService authService = AuthService.instance;
String? nome;
List<String> cpfs = ["", ""];

int selectedCpf = 0;

final TextEditingController pastorController = TextEditingController();
final TextEditingController despesaController = TextEditingController();
final Stream<QuerySnapshot> pastores = db.collection("pastores").snapshots();
final Stream<QuerySnapshot> despesas =
    db.collection("despesas").orderBy("nome").snapshots();

Uint8List? data;
bool pdfSelected = false;

DespesaListModel list = DespesaListModel();

List<String> fields = [
  "Apresentado",
  "Nº Doc - Data",
  "Valor Aceito",
  "Valor Recusado",
  "Motivo",
];
