import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import '../consts.dart';

class AuthProvider {
  final FirebaseAuth auth;
  AuthProvider({required this.auth});

  final ValueNotifier<FirebaseAuthException?> errorNotifier =
      ValueNotifier<FirebaseAuthException?>(null);
  FirebaseAuthException? get error => errorNotifier.value;
  set error(FirebaseAuthException? error) => errorNotifier.value = error;

  Stream<User?> get user => auth.authStateChanges();
  String? campo;

  Future<User?> signIn({required String nome, required String senha}) async {
    final editNome = removerAcentos(nome).toLowerCase().replaceAll(" ", "_");
    try {
      await db.collection("users").where("nome", isEqualTo: nome).get().then(
            (value) =>
                campo = value.docs.single["campo"].toString().toLowerCase(),
          );
    } catch (e) {
      error = FirebaseAuthException(code: "invalid-email");
    }
    try {
      Future<UserCredential> result = auth.signInWithEmailAndPassword(
        email: "$editNome@$campo.com",
        password: senha,
      );
      User? user;
      await result.then((value) {
        user = value.user;
      });
      return user;
    } catch (e) {
      error = e as FirebaseAuthException;
    }
  }

  String removerAcentos(String texto) {
    String comAcentos = "ÄÅÁÂÀÃäáâàãÉÊËÈéêëèÍÎÏÌíîïìÖÓÔÒÕöóôòõÜÚÛüúûùÇç";
    String semAcentos = "AAAAAAaaaaaEEEEeeeeIIIIiiiiOOOOOoooooUUUuuuuCc";

    for (int i = 0; i < comAcentos.length; i++) {
      texto =
          texto.replaceAll(comAcentos[i].toString(), semAcentos[i].toString());
    }
    return texto;
  }

  Future signOut() async {
    return await auth.signOut();
  }
}
