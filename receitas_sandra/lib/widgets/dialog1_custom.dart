import 'package:flutter/material.dart';
import 'package:receitas_sandra/pages/login/cadastrar_senha_page.dart';
import 'package:receitas_sandra/pages/login/entrar_page.dart';

class Dialog1Custom extends StatefulWidget {
  final int qchama;
  final String txtTitle;
  final String? label;
  final String txtBtn1;
  final String txtBtn2;
  final String? txtBtn3;

  const Dialog1Custom({
    required this.qchama,
    required this.txtTitle,
    this.label,
    required this.txtBtn1,
    required this.txtBtn2,
    this.txtBtn3,
  });

  @override
  _Dialog1CustomState createState() => _Dialog1CustomState();
}

class _Dialog1CustomState extends State<Dialog1Custom>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> scaleAnimation;
  List<String> attach = [];
  bool isHtml = false;

  @override
  void initState() {
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

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: Colors.transparent,
        child: ScaleTransition(
          scale: scaleAnimation,
          child: Container(
            width: 320,
            height: widget.qchama == 1
                ? 200
                : widget.qchama == 2
                    ? 600
                    : 300,
            padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.black54,
                width: 2,
              ),
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
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(5),
                  child: Text(
                    widget.txtTitle,
                    style: const TextStyle(
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
                ),
                const SizedBox(height: 5),
                if (widget.qchama == 1)
                  Container(
                    width: 220,
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.black26,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.check),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const CadatrarSenhaPage()),
                            );
                          },
                          child: Text(
                            widget.txtBtn1,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Colors.deepPurple.shade900,
                              shadows: const [
                                Shadow(
                                  color: Colors.cyanAccent,
                                  blurRadius: 5.0,
                                  offset: Offset(1, 1),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                const SizedBox(height: 5),
                Container(
                  width: 220,
                  height: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.black26,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.check),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            Navigator.of(context).pop();
                          });
                        },
                        child: Text(
                          widget.txtBtn2,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.deepPurple.shade900,
                            shadows: const [
                              Shadow(
                                color: Colors.cyanAccent,
                                blurRadius: 5.0,
                                offset: Offset(1, 1),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 5),
                Container(
                  width: 220,
                  height: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.black26,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.check),
                      TextButton(
                        onPressed: () {
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const EntrarPage()),
                              (Route<dynamic> route) => false);
                        },
                        child: Text(
                          widget.txtBtn3.toString(),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.deepPurple.shade900,
                            shadows: const [
                              Shadow(
                                color: Colors.cyanAccent,
                                blurRadius: 5.0,
                                offset: Offset(1, 1),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
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
