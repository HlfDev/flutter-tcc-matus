import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageTypeSelector extends StatelessWidget {
  final Function(File) image;

  const ImageTypeSelector({this.image});

  Future getImage(ImageSource typeImage) async {
    File _image;
    final picker = ImagePicker();

    final pickedFile = await picker.getImage(source: typeImage);

    if (pickedFile != null) {
      _image = File(pickedFile.path);
    }

    if (_image != null) {
      return image(_image);
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return BottomSheet(
      builder: (context) => Column(
        children: [
          FlatButton(
            onPressed: () {
              getImage(ImageSource.camera);
              Navigator.pop(context);
            },
            child: const Text('Câmera'),
          ),
          FlatButton(
            onPressed: () {
              getImage(ImageSource.gallery);
              Navigator.pop(context);
            },
            child: const Text('Galeria'),
          ),
        ],
      ),
      onClosing: () {},
    );
  }
}
