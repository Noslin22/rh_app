import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'pages/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);
  // final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    // return FutureBuilder(
    //   future: _initialization,
    //   builder: (context, snapshot) {
    //     if (snapshot.hasError) {
    //       return const Material(
    //         child: Center(
    //           child: Text(
    //             "Ocorreu um erro ao tentar iniciar, tente novamente mais tarde",
    //           ),
    //         ),
    //       );
    //     }
    //     if (snapshot.connectionState == ConnectionState.done) {
    //       return MaterialApp(
    //         home: const HomePage(),
    //         debugShowCheckedModeBanner: false,
    //         theme: ThemeData(primarySwatch: Colors.indigo),
    //         title: "RH App",
    //       );
    //     }
    //     return const Material(
    //       child: Center(
    //         child: CircularProgressIndicator(
    //           color: Colors.indigo,
    //         ),
    //       ),
    //     );
    //   },
    // );
    return MaterialApp(
            home: const HomePage(),
            debugShowCheckedModeBanner: false,
            theme: ThemeData(primarySwatch: Colors.indigo),
            title: "RH App",
          );
  }
}
