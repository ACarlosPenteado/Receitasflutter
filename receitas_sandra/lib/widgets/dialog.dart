import 'package:flutter/material.dart';

class DialogCustom extends StatefulWidget {
  final String txt;
  final String label;
  final String txtBtnCancel;
  final String txtBtnOk;
  final Widget page;

  // ignore: use_key_in_widget_constructors
  const DialogCustom({
    required this.txt,
    required this.label,
    required this.txtBtnCancel,
    required this.txtBtnOk,
    required this.page,
  });

  @override
  _DialogCustomState createState() => _DialogCustomState();
}

class _DialogCustomState extends State<DialogCustom>
    with SingleTickerProviderStateMixin {

  
  late AnimationController controller;
  late Animation<double> scaleAnimation;

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
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: Colors.transparent,
        child: ScaleTransition(
          scale: scaleAnimation,
          child: Container(
              margin: const EdgeInsets.all(20.0),
              padding: const EdgeInsets.all(15.0),
              height: 280.0,
              decoration: ShapeDecoration(
                  color: Colors.lightBlue,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0))),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 10.0, left: 20.0, right: 20.0),
                          child: Text(
                            widget.txt,
                            style: const TextStyle(
                                color: Colors.deepPurple,
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 40,
                    width: 300,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.white,
                        ),
                      ],
                    ),
                    child: TextField(
                      autofocus: true,
                      controller: nomeController,
                      keyboardType: TextInputType.text,
                      cursorColor: Colors.purpleAccent,
                      decoration: InputDecoration(
                        labelText: widget.label,
                        labelStyle:
                            TextStyle(color: Colors.deepPurple.shade900),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide.none),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.purple.shade200, width: 2.0),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                      child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Container(
                            height: 35.0,
                            width: 110.0,
                            decoration: const BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.indigo,
                                  blurRadius: 3.0,
                                  offset: Offset(3.0, 3.0),
                                ),
                              ],
                            ),
                            child: ElevatedButton(
                              child: Text(
                                widget.txtBtnCancel,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                    color: Colors.purple,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15.0),
                              ),
                              onPressed: () {
                                setState(() {
                                  Navigator.of(context).pop();
                                });
                              },
                            )),
                      ),
                      Padding(
                          padding: const EdgeInsets.only(
                              left: 20.0, right: 10.0, top: 10.0, bottom: 10.0),
                          child: Container(
                              height: 35.0,
                              width: 110.0,
                              decoration: const BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.indigo,
                                    blurRadius: 3.0,
                                    offset: Offset(3.0, 3.0),
                                  ),
                                ],
                              ),
                              child: ElevatedButton(
                                child: Text(
                                  widget.txtBtnOk,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                      color: Colors.purple,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15.0),
                                ),
                                onPressed: () {
                                  setState(() {
                                    Route route = MaterialPageRoute(
                                        builder: (context) =>
                                            widget.page);
                                    Navigator.pushReplacement(context, route);
                                  });
                                },
                              ))),
                    ],
                  ))
                ],
              )),
        ),
      ),
    );
  }
}
