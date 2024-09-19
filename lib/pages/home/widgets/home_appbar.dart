import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../provider/auth_provider.dart';
import '../core/function.dart';
import '../core/variables.dart';
import 'despesa_dialog_widget.dart';
import 'pastor_dialog_widget.dart';

class HomeAppbar extends StatefulWidget {

  const HomeAppbar({ Key? key }) : super(key: key);

  @override
  State<HomeAppbar> createState() => _HomeAppbarState();
}

class _HomeAppbarState extends State<HomeAppbar> {
   @override
   Widget build(BuildContext context) {
       return AppBar(
        backgroundColor: Colors.indigo,
        title: const Text("Sistema de Conferência de Relatório"),
        elevation: 0,
        actions: [
          Tooltip(
            message: "Sair",
            child: IconButton(
              onPressed: () {
                AuthProvider(auth: FirebaseAuth.instance).signOut();
              },
              icon: const Icon(Icons.vpn_key),
            ),
          ),
          Tooltip(
            message: "Gerenciar Obreiro",
            child: IconButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => PastorDialog(
                    provider: provider,
                  ),
                );
              },
              icon: const Icon(Icons.person),
            ),
          ),
          Tooltip(
            message: "Gerenciar Despesa",
            child: IconButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => const DespesaDialog(),
                );
              },
              icon: const Icon(Icons.note_add),
            ),
          ),
          Tooltip(
            message: "Novo Relatório",
            child: IconButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text("Novo Relatório"),
                    content: const Text(
                        "Deseja começar um novo relatório de outro obreiro"),
                    actions: [
                      ElevatedButton(
                        onPressed: () {
                          pdfSelected = false;
                          clearFields(all: true);
                          list = [];
                          Navigator.pop(context);
                          setState(() {});
                        },
                        child: const Text("Sim"),
                      ),
                      ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text("Não"),
                      ),
                    ],
                  ),
                );
              },
              icon: const Icon(Icons.add_chart),
            ),
          ),
        ],
      );
  }
}