import 'package:flutter/material.dart';

class Button_Login extends StatelessWidget {
  final int mode;
  final Color color;
  final ImageProvider image;
  final String text;
  final VoidCallback onPressed;

  const Button_Login(
      {required this.mode,
      required this.color,
      required this.image,
      required this.text,
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        mode == 0
            ? Padding(
                padding:
                    const EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0),
                child: InkWell(
                  onTap: () {
                    onPressed();
                  },
                  child: Container(
                    height: 55,
                    decoration: BoxDecoration(
                      color: Colors.white54,
                      border: Border.all(
                        width: 3,
                        color: color,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      children: [
                        const SizedBox(width: 5),
                        Image(
                          image: image,
                          width: 25,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                            child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              text,
                              style: TextStyle(
                                color: color,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                shadows: const <Shadow>[
                                  Shadow(
                                    offset: Offset(3.0, 3.0),
                                    blurRadius: 3.0,
                                    color: Colors.black,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              width: 25,
                            ),
                          ],
                        ))
                      ],
                    ),
                  ),
                ),
              )
            : Padding(
                padding:
                    const EdgeInsets.only(top: 10.0, left: 20.0, right: 20.0),
                child: InkWell(
                  onTap: () {
                    onPressed();
                  },
                  child: Container(
                    height: 55,
                    decoration: BoxDecoration(
                      color: Colors.white54,
                      border: Border.all(
                        width: 3,
                        color: color,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      children: [
                        const SizedBox(width: 5),
                        Image(
                          image: image,
                          width: 25,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                            child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              text,
                              style: TextStyle(
                                color: color,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                shadows: const <Shadow>[
                                  Shadow(
                                    offset: Offset(3.0, 3.0),
                                    blurRadius: 3.0,
                                    color: Colors.black,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ))
                      ],
                    ),
                  ),
                ),
              ),
      ],
    );
  }
}
