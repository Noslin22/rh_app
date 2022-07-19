import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rh_app/pages/login/login_page.dart';
import 'package:rh_app/provider/auth_provider.dart';

import '../home/home_page.dart';

class WrapperPage extends StatelessWidget {
  WrapperPage({Key? key}) : super(key: key);
  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    final AuthProvider provider = AuthProvider(
      auth: auth,
    );
    return StreamBuilder<User?>(
      stream: provider.user,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return const HomePage();
        } else {
          return LoginPage(provider: provider,);
        }
      },
    );
  }
}
