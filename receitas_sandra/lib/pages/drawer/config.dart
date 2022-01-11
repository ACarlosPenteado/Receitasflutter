import 'package:easy_localization/src/public_ext.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:intl/locale.dart';
import 'package:receitas_sandra/home_page.dart';
import 'package:receitas_sandra/widgets/dialog_custom.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:flutter/material.dart';

class ConfigPage extends StatefulWidget {
  static const routeName = '/ConfigPage';

  const ConfigPage({Key? key}) : super(key: key);

  @override
  _ConfigPageState createState() => _ConfigPageState();
}

class _ConfigPageState extends State<ConfigPage> {
  bool isSwitched = false;

  @override
  Widget build(BuildContext context) {
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
            title: Text('secao1'.tr().toString()),
            tiles: [
              SettingsTile(
                title: Text('linguagem'.tr().toString()),
                value: Text('sublinguagem'.tr().toString()),
                leading: const Icon(Icons.language),
                onPressed: (BuildContext context) {
                  showDialog(
                      barrierDismissible: false,
                      context: context,
                      builder: (BuildContext context) {
                        return const DialogCustom(
                          qchama: 3,
                          txt: 'Escolha o idioma',
                          txtBtnCancel: 'Cancelar',
                          txtBtnOk: 'OK',
                        );
                      });
                },
              ),
              SettingsTile.switchTile(
                initialValue: isSwitched,
                title: const Text('Usar Tema do Sistema'),
                leading: const Icon(Icons.phone_android),
                onToggle: (value) {
                  setState(() {
                    isSwitched = value;
                  });
                },
              ),
            ],
          ),
          SettingsSection(
            title: const Text('Seção 2'),
            tiles: [
              SettingsTile(
                title: const Text('Segurança'),
                value: const Text('Biometria'),
                leading: const Icon(Icons.lock),
                onPressed: (BuildContext context) {},
              ),
              SettingsTile.switchTile(
                initialValue: true,
                title: const Text('Usar Biometria'),
                leading: const Icon(Icons.fingerprint),
                onToggle: (value) {},
              ),
            ],
          ),
        ],
      ),
    );
  }
}
