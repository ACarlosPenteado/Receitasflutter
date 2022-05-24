import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';
import 'package:receitas_sandra/home_page.dart';
import 'package:receitas_sandra/language/codegen_loader.g.dart';
import 'package:receitas_sandra/pages/drawer/data_user.dart';
import 'package:receitas_sandra/pages/login/cadastrar_senha_page.dart';
import 'package:receitas_sandra/pages/login/entrar_page.dart';
import 'package:receitas_sandra/providers/theme_notifier.dart';
import 'package:receitas_sandra/repository/receitas_repository.dart';
import 'package:receitas_sandra/repository/users_repository.dart';
import 'package:receitas_sandra/splash_screen.dart';
import 'package:receitas_sandra/uteis/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseAuth auth = FirebaseAuth.instance;

  Future<SharedPreferences> prefs = SharedPreferences.getInstance();
  prefs.then((value) {
    runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(
              create: (context) =>
                  ReceitasRepository(auth: auth.currentUser!.uid)),
          ChangeNotifierProvider(
              create: (context) =>
                  UsersRepository(auth: auth.currentUser!.uid)),
          ChangeNotifierProvider<ThemeNotifier>(
            create: (BuildContext context) {
              String? theme = value.getString(Constants.APP_THEME);
              if (theme == null ||
                  theme == "" ||
                  theme == Constants.SYSTEM_DEFAULT) {
                value.setString(Constants.APP_THEME, Constants.SYSTEM_DEFAULT);
                return ThemeNotifier(ThemeMode.system);
              }
              return ThemeNotifier(
                  theme == Constants.DARK ? ThemeMode.dark : ThemeMode.light);
            },
          )
        ],
        child: EasyLocalization(
          supportedLocales: const [
            Locale('en', 'EN'),
            Locale('pt', 'BR'),
            Locale('dt', 'DT'),
            Locale('de', 'DE'),
            Locale('es', 'ES'),
          ],
          path: 'language',
          fallbackLocale: Locale('pt', 'BR'),
          assetLoader: CodegenLoader(),
          saveLocale: true,
          startLocale: Locale('pt', 'BR'),
          child: MyApp(),
        ),
      ),
    );
  });
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    return MaterialApp(
      title: 'Minhas Receitas',
      debugShowCheckedModeBanner: false,
      theme: AppTheme().lightTheme,
      darkTheme: AppTheme().darkTheme,
      themeMode: themeNotifier.getThemeMode(),
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      initialRoute: '/splash',
      routes: <String, WidgetBuilder>{
        '/splash': (context) => const SplashScreen(),
        '/home': (context) => const HomePage(),
        '/dados': (context) => const DataUserPage(),
        '/EntrarPage': (context) => const EntrarPage(),
        '/CadastrarSenhaPage': (context) => const CadatrarSenhaPage(),
        '/DataUserPage': (context) => const DataUserPage(),
      },
      home: const SplashScreen(),
    );
  }
}
