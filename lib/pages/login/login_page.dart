import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:scr_project/service/auth_service.dart';

class LoginPage extends StatefulWidget {
  final FirebaseAuthException? error;
  final AuthService authService;
  const LoginPage({
    super.key,
    this.error,
    required this.authService,
  });

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController nomeController = TextEditingController();
  final TextEditingController senhaController = TextEditingController();

  final FocusNode nomeFocus = FocusNode();
  final FocusNode senhaFocus = FocusNode();
  final FirebaseAuth auth = FirebaseAuth.instance;

  bool loading = false;

  Widget alert() {
    return Container(
      padding: const EdgeInsets.all(15),
      color: Colors.amber,
      child: Row(
        children: [
          const Padding(
            padding: EdgeInsets.only(right: 15),
            child: Icon(
              Icons.info_outline,
            ),
          ),
          const Expanded(
            child: Text(
              "A senha ou o usuário estão incorretos. Verifique ou tente novamente mais tarde.",
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15),
            child: IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {
                  widget.authService.error = null;
                }),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
        centerTitle: true,
      ),
      body: loading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Row(
                children: [
                  Expanded(
                    child: Container(),
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          ValueListenableBuilder<FirebaseAuthException?>(
                            valueListenable: widget.authService.errorNotifier,
                            builder: (_, value, __) {
                              if (value != null) {
                                return Column(
                                  children: [
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    alert(),
                                  ],
                                );
                              }
                              return Container();
                            },
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Container(
                            constraints: const BoxConstraints(
                              maxWidth: 500,
                              maxHeight: 300,
                            ),
                            child: Image.asset("images/logo_app.png"),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          AutofillGroup(
                            child: Column(
                              children: [
                                TextField(
                                  controller: nomeController,
                                  focusNode: nomeFocus,
                                  decoration: const InputDecoration(
                                    labelText: "Nome",
                                    border: OutlineInputBorder(),
                                  ),
                                  onSubmitted: (value) {
                                    FocusScope.of(context)
                                        .requestFocus(senhaFocus);
                                  },
                                  autofillHints: const [AutofillHints.username],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                TextField(
                                  controller: senhaController,
                                  focusNode: senhaFocus,
                                  decoration: const InputDecoration(
                                    labelText: "Senha",
                                    border: OutlineInputBorder(),
                                  ),
                                  onSubmitted: (value) async {
                                    loading = true;
                                    User? user =
                                        await widget.authService.signIn(
                                      name: nomeController.text,
                                      senha: senhaController.text,
                                    );
                                    if (user != null) {
                                      TextInput.finishAutofillContext();
                                    } else {
                                      setState(() {
                                        loading = false;
                                      });
                                    }
                                  },
                                  autofillHints: const [AutofillHints.password],
                                  obscureText: true,
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                ElevatedButton(
                                  onPressed: () async {
                                    loading = true;
                                    User? user =
                                        await widget.authService.signIn(
                                      name: nomeController.text,
                                      senha: senhaController.text,
                                    );
                                    if (user != null) {
                                      TextInput.finishAutofillContext();
                                    } else {
                                      setState(() {
                                        loading = false;
                                      });
                                    }
                                  },
                                  child: const Text("Logar"),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(),
                  ),
                ],
              ),
            ),
    );
  }
}
