import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
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
  final Route? route;

  // ignore: use_key_in_widget_constructors
  const DialogCustom({
    required this.qchama,
    required this.txt,
    this.label,
    this.labelrec,
    this.labelsub,
    this.labelbod,
    required this.txtBtnCancel,
    required this.txtBtnOk,
    this.route,
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
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: Colors.transparent,
        child: ScaleTransition(
          scale: scaleAnimation,
          child: Container(
            margin: const EdgeInsets.all(20.0),
            padding: const EdgeInsets.all(15.0),
            height: widget.qchama == 1 ? 280.0 : 480.0,
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
                if (widget.qchama == 1)
                  Container(
                    height: 50,
                    width: 300,
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.white,
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: _nomeController,
                      autofocus: true,
                      keyboardType: TextInputType.text,
                      cursorColor: Colors.purpleAccent,
                      decoration: InputDecoration(
                        label: const Text('Nome da Receita'),
                        hintText: 'Deixe em branco para todas!',
                        hintStyle: const TextStyle(fontSize: 12),
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
                if (widget.qchama == 2)
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
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
                          child: TextFormField(
                            controller: _recipientController,
                            autofocus: true,
                            enabled: false,
                            keyboardType: TextInputType.text,
                            cursorColor: Colors.purpleAccent,
                            decoration: InputDecoration(
                              labelText: widget.labelrec,
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
                        const SizedBox(height: 10),
                        Container(
                          height: 40,
                          width: 300,
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.white,
                              ),
                            ],
                          ),
                          child: TextFormField(
                            controller: _subjectController,
                            autofocus: true,
                            keyboardType: TextInputType.text,
                            textCapitalization: TextCapitalization.sentences,
                            textInputAction: TextInputAction.next,
                            cursorColor: Colors.purpleAccent,
                            decoration: InputDecoration(
                              labelText: widget.labelsub,
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
                        const SizedBox(height: 10),
                        Container(
                          height: 150,
                          width: 300,
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.white,
                              ),
                            ],
                          ),
                          child: TextFormField(
                            controller: _bodyController,
                            autofocus: true,
                            keyboardType: TextInputType.text,
                            textCapitalization: TextCapitalization.sentences,
                            cursorColor: Colors.purpleAccent,
                            maxLines: 3,
                            maxLength: 300,
                            textAlignVertical: TextAlignVertical.top,
                            decoration: InputDecoration(
                              labelText: widget.labelbod,
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
                                  color: Colors.purple,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15.0),
                            ),
                            onPressed: () {
                              setState(() {
                                switch (widget.qchama) {
                                  case 1:
                                    _nomeController.text.isEmpty
                                        ? Global.nomeRec = 'receitas'
                                        : Global.nomeRec = _nomeController.text;
                                    break;
                                  case 2:
                                    envia();
                                    break;
                                  case 3:
                                    if (_nomeController.text.isEmpty) {
                                        Fluttertoast.showToast(
                                            gravity: ToastGravity.CENTER,
                                            msg: 'Digite o que procurar'); }
                                    else {
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
