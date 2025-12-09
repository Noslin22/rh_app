import 'package:flutter/material.dart';
import 'package:url_launcher/link.dart';

void showInitialDialog(BuildContext context) {
  WidgetsBinding.instance.addPostFrameCallback(
    (_) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            title: const Text("Dê seu feedback"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Com o intuito de aprimorar o SCR pedimos que você contribua mandando melhorias.",
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 24, bottom: 6),
                  child: Text('Nossos Contatos:'),
                ),
                Link(
                  uri: Uri.parse(
                    'mailto:joaonilsoneto2@gmail.com?subject=Atualização%20SCR',
                  ),
                  target: LinkTarget.blank,
                  builder: (context, openLink) {
                    return Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text('Email:'),
                        TextButton(
                          onPressed: openLink,
                          child: const Text(
                            'joaonilsoneto2@gmail.com',
                            style: TextStyle(
                              color: Colors.blue,
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
                Link(
                  uri: Uri.parse(
                    'https://wa.me/75999302754?text=Gostaria%20de%20sugerir%20algumas%20melhorias%20para%20o%20SCR',
                  ),
                  target: LinkTarget.blank,
                  builder: (context, openLink) {
                    return Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text('Whatsapp:'),
                        TextButton(
                          onPressed: openLink,
                          child: const Text(
                            '(75) 99930-2754',
                            style: TextStyle(
                              color: Colors.blue,
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
                ...DateTime.now().isBefore(DateTime(2026, 02, 01))
                    ? [
                        const SizedBox(
                          height: 16,
                        ),
                        const Text(
                          'Atualizações:',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const Text(
                          '   Correção do campo de data no mês de Dezembro;',
                        ),
                        const Text(
                          '   O visualizador de PDF agora pode ser desabilitado;',
                        ),
                        const Text('   Correção de Bugs.'),
                        const SizedBox(
                          height: 20,
                        ),
                        const Text(
                          '   Versão 1.3.3',
                          style: TextStyle(fontSize: 10),
                        ),
                      ]
                    : []
              ],
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(bottom: 16, right: 16),
                child: TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'OK',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.blue,
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      );
    },
  );
}
