
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../consts.dart';
import '../../../models/despesa_model.dart';
import '../../../provider/auth_provider.dart';

late TextEditingController cpfController;
  AuthProvider provider = AuthProvider(auth: FirebaseAuth.instance);
  String? nome;
  List<String> cpfs = ["", ""];

  final TextEditingController pastorController = TextEditingController();
  final TextEditingController despesaController = TextEditingController();
  final Stream<QuerySnapshot> pastores = db.collection("pastores").snapshots();
  final Stream<QuerySnapshot> despesas =
      db.collection("despesas").orderBy("nome").snapshots();

  Uint8List? data;
  bool pdfSelected = false;

  List<DespesaModel> list = [];

  List<String> fields = [
    "Apresentado",
    "N° Documento - Data",
    "Valor Aceito",
    "Valor Recusado",
    "Motivo",
  ];