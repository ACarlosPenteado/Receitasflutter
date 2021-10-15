import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:receitas_sandra/home_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    User? result = FirebaseAuth.instance.currentUser;
    Timer(const Duration(seconds: 3), () {
      if (result != null) {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => HomePage(uid: result.uid),
            ),
            (Route<dynamic> route) => false);
      } else {
        Navigator.of(context).pushReplacementNamed('/EntrarPage');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            decoration: const BoxDecoration(
              color: Colors.lightBlueAccent,
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: const <Widget>[
              Expanded(
                flex: 3,
                child: SizedBox(height: 10),
              ),
              Expanded(
                flex: 2,
                child: Icon(Icons.ac_unit),
              ),
              Expanded(
                flex: 2,
                child: Text('Carregando...'),
              ),
              Expanded(
                flex: 1,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(Colors.blue),
                  strokeWidth: 5.0,
                ),
              ),
              Expanded(
                flex: 3,
                child: SizedBox(height: 10),
              ),
            ],
          )
        ],
      ),
    );
  }
}
