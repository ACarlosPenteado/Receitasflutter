import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:receitas_sandra/home_page.dart';
import 'package:receitas_sandra/pages/drawer/data_user.dart';
import 'package:receitas_sandra/pages/login/entrar_page.dart';
import 'package:receitas_sandra/repository/receitas_repository.dart';
import 'package:receitas_sandra/repository/users_repository.dart';
import 'package:receitas_sandra/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  await Firebase.initializeApp();
  FirebaseAuth auth = FirebaseAuth.instance;
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (context) =>
                ReceitasRepository(auth: auth.currentUser!.uid)),
        ChangeNotifierProvider(
            create: (context) => UsersRepository(auth: auth.currentUser!.uid)),
      ],
      child: EasyLocalization(
        path: 'resources/language',
        saveLocale: true,
        supportedLocales: const [
          Locale('en', 'EN'),
          Locale('pt', 'BR'),
        ],
      child: const MyApp(),),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Receitas da Sandra',
      debugShowCheckedModeBanner: false,
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      initialRoute: '/splash',      
      routes: <String, WidgetBuilder>{
        '/splash': (context) => const SplashScreen(),
        '/home': (context) => const HomePage(),
        '/dados': (context) => const DataUserPage(),
        '/EntrarPage': (context) => const EntrarPage(),
        '/DataUserPage': (context) => const DataUserPage(),
      },
      home: const SplashScreen(),
    );
  }
}
