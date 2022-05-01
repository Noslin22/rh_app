import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'pages/wrapper_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: WrapperPage(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.indigo),
      title: "SCR Seven",
      localizationsDelegates: const [
        ...GlobalMaterialLocalizations.delegates,
        GlobalWidgetsLocalizations.delegate
      ],
      supportedLocales: const [Locale('pt', 'BR')],
    );
  }
}
