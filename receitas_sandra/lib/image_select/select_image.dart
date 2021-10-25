import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:firebase_storage/firebase_storage.dart' as storage;
import 'package:receitas_sandra/uteis/funtions.dart';

class SelectImage extends StatefulWidget {
  //const SelectImage({Key? key, required this.onFileChanged}) : super(key: key);

  final Function(String imageUrl)? onFileChanged;

  const SelectImage({
    this.onFileChanged,
  });

  @override
  _SelectImageState createState() => _SelectImageState();
}

class _SelectImageState extends State<SelectImage> {
  final ImagePicker _picker = ImagePicker();

  String imageUrl = '';
  String id = getUser;

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
            ));
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
    file = await compressImage(file.path, 35);

    await uploadFile(file.path);
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

  Future uploadFile(String path) async {
    final ref = storage.FirebaseStorage.instance
        .ref()
        .child('users')
        .child(p.basename(path));

    final result = await ref.putFile(File(path));
    final fileUrl = await result.ref.getDownloadURL();

    setState(() {
      imageUrl = fileUrl;
    });

    widget.onFileChanged!(fileUrl);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (imageUrl.isEmpty)
          Icon(Icons.person, size: 60, color: Theme.of(context).primaryColor),
        if (imageUrl.isNotEmpty)
          InkWell(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onTap: () => _selectPhoto(),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image(
                image: NetworkImage(imageUrl),
                width: 80,
                height: 80,
              ),
            ),
          ),
        InkWell(
          onTap: () => _selectPhoto(),
          child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                imageUrl.isNotEmpty ? 'Mudar foto' : 'Selecione foto',
              )),
        ),
      ],
    );
  }
}
