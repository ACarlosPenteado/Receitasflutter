import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';

class EmailPage extends StatefulWidget {
  const EmailPage({Key? key}) : super(key: key);

  @override
  _EmailPageState createState() => _EmailPageState();
}

class _EmailPageState extends State<EmailPage> {
  List<String> attach = [];
  bool isHtml = false;

  final _recipientController =
      TextEditingController(text: 'exemplo@exemplo.com');
  final _subjectController = TextEditingController(text: 'sujeito');
  final _bodyController = TextEditingController(text: 'Corpo do email');

  Future<void> envia() async {
    final Email email = Email(
      body: _bodyController.text,
      subject: _subjectController.text,
      recipients: [_recipientController.text],
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

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
