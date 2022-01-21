import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';
import 'package:receitas_sandra/home_page.dart';
import 'package:receitas_sandra/language/locale_keys.g.dart';
import 'package:receitas_sandra/providers/theme_notifier.dart';
import 'package:receitas_sandra/uteis/app_color.dart';
import 'package:receitas_sandra/uteis/app_constants.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ConfigPage extends StatefulWidget {
  static const routeName = '/ConfigPage';

  const ConfigPage({Key? key}) : super(key: key);

  @override
  _ConfigPageState createState() => _ConfigPageState();
}

class _ConfigPageState extends State<ConfigPage>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> scaleAnimation;

  var isSwitched;
  String? _grIdiomaValue;
  String? _grTemaValue;
  late bool isDarkTheme;
  SharedPreferences? preft;
  SharedPreferences? prefb;
  late ThemeNotifier themeNotifier;

  @override
  void initState() {
    _grIdiomaValue = 'Português';
    _grTemaValue = preft?.getString(Constants.APP_THEME);
    isSwitched = prefb?.getBool('bio');
    super.initState();
    controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1450));
    scaleAnimation =
        CurvedAnimation(parent: controller, curve: Curves.elasticInOut);
    controller.addListener(() {
      setState(() {});
    });
    controller.forward();
  }

  escolheIdioma() {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return dialog(1);
        });
  }

  void _grChangeId(String? value) {
    setState(() {
      _grIdiomaValue = value;
      switch (value) {
        case 'Deutsch':
          context.locale = Locale('de', 'DE');
          break;
        case 'English':
          context.locale = Locale('en', 'EN');
          break;
        case 'Español':
          context.locale = Locale('es', 'ES');
          break;
        case 'Português':
          context.locale = Locale('pt', 'BR');
          break;
        default:
      }
      Navigator.of(context).pop();
    });
  }

  escolheTema() {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return dialog(2);
        });
  }

  Future<void> _grChangeTe(String? value) async {
    setState(() {
      _grTemaValue = value;
      switch (value) {
        case 'Sistema Padrão':
          themeNotifier.setThemeMode(ThemeMode.dark);
          break;
        case 'Claro':
          themeNotifier.setThemeMode(ThemeMode.light);
          break;
        case 'Escuro':
          themeNotifier.setThemeMode(ThemeMode.dark);
          break;
        default:
      }
      preft!.setString(Constants.APP_THEME, value!);
      Navigator.of(context).pop();
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    themeNotifier = Provider.of<ThemeNotifier>(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 12,
        centerTitle: true,
        title: const Text(
          'Configurações',
          style: TextStyle(
              fontSize: 25,
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.bold,
              color: Colors.lightBlueAccent,
              shadows: [
                Shadow(
                  color: Colors.black,
                  blurRadius: 5.0,
                  offset: Offset(1, 1),
                ),
              ]),
        ),
        leading: IconButton(
          iconSize: 30,
          icon: const Icon(
            Icons.arrow_back,
          ),
          onPressed: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => const HomePage(),
              ),
            );
          },
        ),
      ),
      body: SettingsList(
        contentPadding: const EdgeInsets.all(20),
        sections: [
          SettingsSection(
            title: Text(LocaleKeys.secao.tr().toString() + ' 1'),
            tiles: [
              SettingsTile(
                title: Text(LocaleKeys.linguagem.tr().toString()),
                value: Text(LocaleKeys.sublinguagem.tr().toString()),
                leading: const Icon(Icons.language),
                onPressed: (BuildContext context) {
                  escolheIdioma();
                },
              ),
              SettingsTile(
                title: Text(LocaleKeys.sistema.tr().toString()),
                leading: const Icon(Icons.phone_android),
                onPressed: (BuildContext context) {
                  escolheTema();
                },
              ),
              SettingsTile.switchTile(
                initialValue: isSwitched,
                title: Text(LocaleKeys.usarbio.tr().toString()),
                leading: const Icon(Icons.fingerprint),
                onToggle: (value) {
                  setState(() {
                    isSwitched = value;
                    prefb?.setBool('bio', value);
                  });
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget dialog(int tp) {
    return Center(
      child: Material(
        color: Colors.transparent,
        child: ScaleTransition(
          scale: scaleAnimation,
          child: Container(
            width: 320,
            height: 300,
            padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              gradient: const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFF259cda), Color(0xFF6bbce6)]),
              boxShadow: const [
                BoxShadow(
                  color: Colors.cyan,
                  blurRadius: 12,
                  offset: Offset(3, 5),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                if (tp == 1)
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text(
                          'Selecione o idioma',
                          style: TextStyle(
                              fontSize: 20.0,
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.bold,
                              color: Colors.white70,
                              shadows: [
                                Shadow(
                                  color: Colors.black,
                                  blurRadius: 5.0,
                                  offset: Offset(1, 1),
                                ),
                              ]),
                        ),
                      ],
                    ),
                  ),
                if (tp == 1)
                  Container(
                    width: 200,
                    height: 230,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: Expanded(
                      child: ListView(
                        children: [
                          ListTile(
                            title: const Text('Deutsch'),
                            leading: Radio(
                              value: 'Deutsch',
                              groupValue: _grIdiomaValue,
                              onChanged: _grChangeId,
                            ),
                          ),
                          ListTile(
                            title: const Text('English'),
                            leading: Radio(
                              value: 'English',
                              groupValue: _grIdiomaValue,
                              onChanged: _grChangeId,
                            ),
                          ),
                          ListTile(
                            title: const Text('Español'),
                            leading: Radio(
                              value: 'Español',
                              groupValue: _grIdiomaValue,
                              onChanged: _grChangeId,
                            ),
                          ),
                          ListTile(
                            title: const Text('Português'),
                            leading: Radio(
                              value: 'Português',
                              groupValue: _grIdiomaValue,
                              onChanged: _grChangeId,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                if (tp == 2)
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text(
                          'Selecione o tema',
                          style: TextStyle(
                              fontSize: 20.0,
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.bold,
                              color: Colors.white70,
                              shadows: [
                                Shadow(
                                  color: Colors.black,
                                  blurRadius: 5.0,
                                  offset: Offset(1, 1),
                                ),
                              ]),
                        ),
                      ],
                    ),
                  ),
                if (tp == 2)
                  Container(
                    width: 200,
                    height: 230,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: Expanded(
                      child: ListView(
                        children: [
                          ListTile(
                            title: const Text('Sistema Padrão'),
                            leading: Radio(
                              value: 'Sistema Padrão',
                              activeColor: isDarkTheme
                                  ? AppColors.darkPink
                                  : AppColors.textBlack,
                              groupValue: _grTemaValue,
                              onChanged: _grChangeTe,
                            ),
                          ),
                          ListTile(
                            title: const Text('Claro'),
                            leading: Radio(
                              value: 'Claro',
                              activeColor: isDarkTheme
                                  ? AppColors.darkPink
                                  : AppColors.textBlack,
                              groupValue: _grTemaValue,
                              onChanged: _grChangeTe,
                            ),
                          ),
                          ListTile(
                            title: const Text('Escuro'),
                            leading: Radio(
                              value: 'Escuro',
                              activeColor: isDarkTheme
                                  ? AppColors.darkPink
                                  : AppColors.textBlack,
                              groupValue: _grTemaValue,
                              onChanged: _grChangeTe,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
