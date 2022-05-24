import 'package:dedi_personalizados/repository/produtos_repository.dart';
import 'package:dedi_personalizados/utils/funtions.dart';
import 'package:dedi_personalizados/utils/globais.dart';
import 'package:dedi_personalizados/views/home_page.dart';
import 'package:dedi_personalizados/views/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseAuth auth = FirebaseAuth.instance;

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(
          create: (context) => ProdutosRepository(auth: auth.currentUser!.uid)),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {    
    return MaterialApp(
      title: Global.title,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color.fromARGB(255, 233, 30, 216),
      ),
      home: const SplashScreen(),
    );
  }
}
