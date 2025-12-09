import 'package:flutter/material.dart';
import 'package:scr_project/pages/home/home_controller.dart';

import '../../../service/auth_service.dart';
import '../core/variables.dart';
import 'despesa_dialog_widget.dart';
import 'pastor_dialog_widget.dart';

class HomeAppbar extends StatefulWidget {
  const HomeAppbar({super.key, required this.controller});
  final HomeController controller;

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
              AuthService.instance.signOut();
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
                  authService: authService,
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
                        setState(() {
                          pdfSelected = false;
                          widget.controller.clearFields(all: true);
                          list.clear();
                          Navigator.pop(context);
                        });
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
        ValueListenableBuilder(
          valueListenable: widget.controller.pdfEnabledNotifier,
          builder: (context, pdfEnabled, _) {
            return Tooltip(
              message: pdfEnabled ? "Desabilitar PDF" : "Habilitar PDF",
              child: IconButton(
                onPressed: () {
                  widget.controller.switchPdfEnabled();
                },
                icon: Icon(
                  pdfEnabled ? Icons.content_paste_off : Icons.content_paste,
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
