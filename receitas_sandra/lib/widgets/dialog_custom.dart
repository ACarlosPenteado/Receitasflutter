import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:receitas_sandra/pages/drawer/busca.dart';
import 'package:receitas_sandra/uteis/globais.dart';

class DialogCustom extends StatefulWidget {
  final int qchama;
  final String txt;
  final String? label;
  final String? labelrec;
  final String? labelsub;
  final String? labelbod;
  final String txtBtnCancel;
  final String txtBtnOk;

  const DialogCustom({
    required this.qchama,
    required this.txt,
    this.label,
    this.labelrec,
    this.labelsub,
    this.labelbod,
    required this.txtBtnCancel,
    required this.txtBtnOk,
  });

  @override
  _DialogCustomState createState() => _DialogCustomState();
}

class _DialogCustomState extends State<DialogCustom>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> scaleAnimation;
  List<String> attach = [];
  bool isHtml = false;

  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _recipientController = TextEditingController();
  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _bodyController = TextEditingController();
  final GlobalKey _formKey = GlobalKey<FormState>();

  List<String> _list = [];

  bool? _isNomeReceita = false;
  bool? _isIngrediente = false;
  bool? _isPreparo = false;

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

  Future<void> envia() async {
    final Email email = Email(
      body: _bodyController.text,
      subject: _subjectController.text,
      recipients: ['acarlos.penteado@gmail.com'],
      attachmentPaths: attach,
      isHTML: isHtml,
    );
    String platformResponse;

    try {
      await FlutterEmailSender.send(email);
      platformResponse = 'sucesso';
    } catch (e) {
      platformResponse = e.toString();
    }
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(platformResponse),
      ),
    );
  }

  void _openImagePicker() async {
    final ImagePicker picker = ImagePicker();
    final pick =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 50);
    if (pick != null) {
      setState(() {
        attach.add(pick.path);
      });
    }
  }

  void _removeAttach(int index) {
    setState(() {
      attach.removeAt(index);
    });
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
            height: widget.qchama == 1 ? 200 : 600,
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
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        widget.txt,
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
                    ],
                  ),
                ),
                if (widget.qchama == 1)
                  Material(
                    borderRadius: BorderRadius.circular(12.0),
                    shadowColor: Colors.black26,
                    elevation: 12,
                    color: Colors.black26,
                    child: TextFormField(
                      style: const TextStyle(
                        color: Colors.cyanAccent,
                        fontWeight: FontWeight.bold,
                        shadows: [
                          Shadow(
                            color: Colors.black,
                            blurRadius: 5,
                            offset: Offset(1, 1),
                          ),
                        ],
                      ),
                      controller: _nomeController,
                      autofocus: true,
                      keyboardType: TextInputType.text,
                      textCapitalization: TextCapitalization.sentences,
                      cursorColor: Colors.orange[200],
                      decoration: InputDecoration(
                        label: const Text('Nome da Receita'),
                        hintText: 'Deixe em branco para todas!',
                        hintStyle: const TextStyle(
                            color: Colors.white70, fontSize: 12),
                        labelStyle: TextStyle(
                          color: Colors.blue.shade200,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          shadows: const [
                            Shadow(
                              color: Colors.black,
                              blurRadius: 5,
                              offset: Offset(1, 1),
                            ),
                          ],
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          borderSide: BorderSide(
                            color: Colors.blue.shade900,
                            width: 2.0,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          borderSide: const BorderSide(
                            color: Colors.indigoAccent,
                            width: 2.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                if (widget.qchama == 2)
                  Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Material(
                          borderRadius: BorderRadius.circular(12.0),
                          shadowColor: Colors.black26,
                          elevation: 12,
                          color: Colors.black26,
                          child: Center(
                            child: TextFormField(
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.cyanAccent,
                                fontWeight: FontWeight.bold,
                                shadows: [
                                  Shadow(
                                    color: Colors.black,
                                    blurRadius: 5,
                                    offset: Offset(1, 1),
                                  ),
                                ],
                              ),
                              controller: _recipientController,
                              autofocus: true,
                              enabled: false,
                              keyboardType: TextInputType.text,
                              cursorColor: Colors.orange[200],
                              decoration: InputDecoration(
                                prefixText: 'para: ',
                                prefixStyle: const TextStyle(
                                  color: Colors.redAccent,
                                  fontWeight: FontWeight.bold,
                                  shadows: [
                                    Shadow(
                                      color: Colors.black,
                                      blurRadius: 5,
                                      offset: Offset(1, 1),
                                    ),
                                  ],
                                ),
                                labelText: widget.labelrec,
                                labelStyle:
                                    const TextStyle(color: Colors.cyanAccent),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12.0),
                                    borderSide: BorderSide.none),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.purple.shade200,
                                      width: 2.0),
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Material(
                          borderRadius: BorderRadius.circular(12.0),
                          shadowColor: Colors.black26,
                          elevation: 12,
                          color: Colors.black26,
                          child: TextFormField(
                            style: const TextStyle(
                              color: Colors.cyanAccent,
                              fontWeight: FontWeight.bold,
                              shadows: [
                                Shadow(
                                  color: Colors.black,
                                  blurRadius: 5,
                                  offset: Offset(1, 1),
                                ),
                              ],
                            ),
                            controller: _subjectController,
                            autofocus: true,
                            keyboardType: TextInputType.text,
                            textCapitalization: TextCapitalization.sentences,
                            textInputAction: TextInputAction.next,
                            cursorColor: Colors.purpleAccent,
                            decoration: InputDecoration(
                              labelText: widget.labelsub,
                              hintStyle: const TextStyle(
                                  color: Colors.white70, fontSize: 12),
                              labelStyle: TextStyle(
                                color: Colors.blue.shade200,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                shadows: const [
                                  Shadow(
                                    color: Colors.black,
                                    blurRadius: 5,
                                    offset: Offset(1, 1),
                                  ),
                                ],
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12.0),
                                borderSide: BorderSide(
                                  color: Colors.blue.shade900,
                                  width: 2.0,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12.0),
                                borderSide: const BorderSide(
                                  color: Colors.indigoAccent,
                                  width: 2.0,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Material(
                          borderRadius: BorderRadius.circular(12.0),
                          shadowColor: Colors.black26,
                          elevation: 12,
                          color: Colors.black26,
                          child: TextFormField(
                            style: const TextStyle(
                              color: Colors.cyanAccent,
                              fontWeight: FontWeight.bold,
                              shadows: [
                                Shadow(
                                  color: Colors.black,
                                  blurRadius: 5,
                                  offset: Offset(1, 1),
                                ),
                              ],
                            ),
                            controller: _bodyController,
                            autofocus: true,
                            keyboardType: TextInputType.text,
                            textCapitalization: TextCapitalization.sentences,
                            cursorColor: Colors.orange[200],
                            maxLines: 10,
                            maxLength: 300,
                            textAlignVertical: TextAlignVertical.top,
                            decoration: InputDecoration(
                              labelText: widget.labelbod,
                              labelStyle: TextStyle(
                                color: Colors.blue.shade200,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                shadows: const [
                                  Shadow(
                                    color: Colors.black,
                                    blurRadius: 5,
                                    offset: Offset(1, 1),
                                  ),
                                ],
                              ),
                              counterStyle: TextStyle(
                                color: Colors.blue.shade200,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                shadows: const [
                                  Shadow(
                                    color: Colors.black,
                                    blurRadius: 5,
                                    offset: Offset(1, 1),
                                  ),
                                ],
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12.0),
                                borderSide: BorderSide(
                                  color: Colors.blue.shade900,
                                  width: 2.0,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12.0),
                                borderSide: const BorderSide(
                                  color: Colors.indigoAccent,
                                  width: 2.0,
                                ),
                              ),
                            ),
                          ),
                        ),
                        CheckboxListTile(
                            title: const Text('HTML'),
                            value: isHtml,
                            onChanged: (bool? value) {
                              if (value != null) {
                                setState(() {
                                  isHtml = value;
                                });
                              }
                            }),
                      ],
                    ),
                  ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0, right: 10.0),
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
                                color: Colors.white70,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                shadows: [
                                  Shadow(
                                    color: Colors.black,
                                    blurRadius: 5,
                                    offset: Offset(1, 1),
                                  ),
                                ],
                              ),
                            ),
                            onPressed: () {
                              setState(() {
                                Navigator.of(context).pop();
                              });
                            },
                          ),
                        ),
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
                                color: Colors.white70,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                shadows: [
                                  Shadow(
                                    color: Colors.black,
                                    blurRadius: 5,
                                    offset: Offset(1, 1),
                                  ),
                                ],
                              ),
                            ),
                            onPressed: () {
                              setState(() {
                                switch (widget.qchama) {
                                  case 1:
                                    _nomeController.text.isEmpty
                                        ? Global.nomeRec = 'receitas'
                                        : Global.nomeRec = _nomeController.text;
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const BuscaPage()),
                                    );
                                    break;
                                  case 2:
                                    envia();
                                    break;
                                  case 3:
                                    if (_nomeController.text.isEmpty) {
                                      Fluttertoast.showToast(
                                          gravity: ToastGravity.CENTER,
                                          msg: 'Digite o que procurar');
                                    } else {
                                      Global.nomeRec = _nomeController.text;
                                    }
                                    break;
                                  default:
                                }
                              });
                            },
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
