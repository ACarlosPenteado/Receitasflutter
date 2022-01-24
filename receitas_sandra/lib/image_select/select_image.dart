import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:firebase_storage/firebase_storage.dart' as storage;
import 'package:receitas_sandra/uteis/funtions.dart';
import 'package:receitas_sandra/uteis/globais.dart';

class SelectImage extends StatefulWidget {
  final int tip;
  const SelectImage({Key? key, required this.tip, required this.onFileChanged})
      : super(key: key);

  final Function(String imageUrl) onFileChanged;

  @override
  _SelectImageState createState() => _SelectImageState();
}

class _SelectImageState extends State<SelectImage> {
  final ImagePicker _picker = ImagePicker();

  late String imageUrl;
  String id = getUser;

  @override
  void initState() {
    if (widget.tip == 0) {
      imageUrl = Global.foto;
    } else {
      if (Global.qual == 'E') {
        imageUrl = Global.imagem;
      } else if (Global.qual == 'I') {
        imageUrl = '';
      }
    }
    super.initState();
  }

  Future _selectPhoto() async {
    await showModalBottomSheet(
      context: context,
      builder: (context) => BottomSheet(
        builder: (context) => Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera),
              title: const Text('Camera'),
              onTap: () {
                Navigator.of(context).pop();
                _pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.filter),
              title: const Text('Galeria'),
              onTap: () {
                Navigator.of(context).pop();
                _pickImage(ImageSource.gallery);
              },
            ),
          ],
        ),
        onClosing: () {},
      ),
    );
  }

  Future _pickImage(ImageSource source) async {
    final pickedFile =
        await _picker.pickImage(source: source, imageQuality: 50);
    if (pickedFile == null) {
      return;
    }
    var file = await ImageCropper.cropImage(
      sourcePath: pickedFile.path,
      aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
    );
    if (file == null) {
      return;
    }
    file = await compressImage(file.path, 50);

    if (widget.tip == 0) {
      await uploadFileUser(file.path);
    } else {
      await uploadFileRec(file.path);
    }
  }

  Future<File> compressImage(String path, int quality) async {
    final newPath =
        p.join((await getTemporaryDirectory()).path, '$id${p.extension(path)}');

    final result = await FlutterImageCompress.compressAndGetFile(
      path,
      newPath,
      quality: quality,
    );
    return result!;
  }

  Future uploadFileUser(String path) async {
    final ref = storage.FirebaseStorage.instance
        .ref()
        .child('users')
        .child(p.basename(path));

    final result = await ref.putFile(File(path));
    final fileUrl = await result.ref.getDownloadURL();

    setState(() {
      imageUrl = fileUrl;
    });

    widget.onFileChanged(fileUrl);
  }

  Future uploadFileRec(String path) async {
    final ref = storage.FirebaseStorage.instance
        .ref()
        .child('Imagens_Receitas')
        .child(p.basename(path));

    final result = await ref.putFile(File(path));
    final fileUrl = await result.ref.getDownloadURL();

    setState(() {
      imageUrl = fileUrl;
    });

    widget.onFileChanged(fileUrl);
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: () => _selectPhoto(),
      child: Column(
        children: [
          InkWell(
            onTap: () => _selectPhoto(),
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Column(
                children: [
                  if (imageUrl.isNotEmpty)
                    Material(
                      borderRadius: BorderRadius.circular(60.0),
                      shadowColor: Colors.black26,
                      elevation: 12,
                      color: Colors.black26,
                      child: Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(60),
                          border: Border.all(
                            color: Colors.blue.shade900,
                            width: 2.0,
                          ),
                        ),
                        child: const Text(
                          'Mudar Imagem',
                          style: TextStyle(
                              color: Colors.cyanAccent,
                              fontWeight: FontWeight.bold,
                              shadows: [
                                Shadow(
                                  color: Colors.black,
                                  blurRadius: 5.0,
                                  offset: Offset(1, 1),
                                ),
                              ]),
                        ),
                      ),
                    )
                  else
                    Material(
                      borderRadius: BorderRadius.circular(60.0),
                      shadowColor: Colors.black26,
                      elevation: 12,
                      color: Colors.black26,
                      child: Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(60),
                          border: Border.all(
                            color: Colors.blue.shade900,
                            width: 2.0,
                          ),
                        ),
                        child: const Text(
                          'Selecionar Imagem',
                          style: TextStyle(
                              color: Colors.cyanAccent,
                              fontWeight: FontWeight.bold,
                              shadows: [
                                Shadow(
                                  color: Colors.black,
                                  blurRadius: 5.0,
                                  offset: Offset(1, 1),
                                ),
                              ]),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
