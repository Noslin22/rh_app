import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:scr_project/consts.dart';
import 'package:scr_project/models/pastor_model.dart';
import 'package:scr_project/pages/home/core/function.dart';
import 'package:scr_project/pages/home/core/variables.dart';
import 'package:scr_project/pages/home/home_controller.dart';
import 'package:scr_project/widgets/list_field_widget.dart';

class ObreiroField extends StatelessWidget {
  const ObreiroField({super.key, required this.controller});
  final HomeController controller;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 6,
      child: StreamBuilder<QuerySnapshot>(
        stream: pastores,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<PastorModel> pastores = snapshot.data!.docs
                .map((e) => PastorModel.fromDocument(e))
                .where((element) {
              return element.campo == authService.campo;
            }).toList();
            obreiros = pastores;
            return ListField<PastorModel>(
              icon: Icons.person,
              label: "Obreiro",
              focusNode: nodes[0],
              controller: pastorController,
              suggestions: pastores,
              searchBy: "nome",
              selected: (pastor) {
                controller.cpfs = ["${pastor.cpf} ", "${pastor.cpf2} "];
                pastorController.text = pastor.nome.trim();
                selectMonth(context);
              },
            );
          } else {
            return const LinearProgressIndicator();
          }
        },
      ),
    );
  }
}
