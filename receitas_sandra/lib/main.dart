import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:receitas_sandra/home_page.dart';
import 'package:receitas_sandra/login/entrar_page.dart';
import 'package:receitas_sandra/repository/favoritas_repository.dart';
import 'package:receitas_sandra/repository/receitas_repository.dart';
import 'package:receitas_sandra/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding();
  await Firebase.initializeApp();
  FirebaseAuth auth = FirebaseAuth.instance;
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (context) => ReceitasRepository(auth: auth)),
        ChangeNotifierProvider(create: (context) => FavoritasRepository()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);
  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Receitas da Sandra',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
      initialRoute: '/splash',
      routes: <String, WidgetBuilder>{
        '/splash': (context) => const SplashScreen(),
        '/home': (context) => const HomePage(),
        '/EntrarPage': (context) => const EntrarPage(),
      },
    );
  }
}
