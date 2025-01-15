import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:scr_project/pages/login/login_page.dart';
import 'package:scr_project/service/auth_service.dart';

import '../home/home_page.dart';

class WrapperPage extends StatelessWidget {
  const WrapperPage({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthService authService = AuthService.instance;
    return StreamBuilder<User?>(
      stream: authService.user,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return const HomePage();
        } else {
          return LoginPage(
            authService: authService,
          );
        }
      },
    );
  }
}
