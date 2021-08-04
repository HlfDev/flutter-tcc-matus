import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:matus_app/app/themes/app_colors.dart';

class ImageTypeSelector extends StatelessWidget {
  ImageTypeSelector({this.onImageSelected});

  final Function(File) onImageSelected;

  final ImagePicker picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    if (Platform.isAndroid) {
      return BottomSheet(
        backgroundColor: AppColor.secondaryColor,
        onClosing: () {},
        builder: (_) => Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            ElevatedButton(
              onPressed: () async {
                final PickedFile file =
                    await picker.getImage(source: ImageSource.camera);
                onImageSelected(File(file.path));
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Padding(
                    padding: EdgeInsets.only(right: 8.0),
                    child: Icon(Icons.camera_alt),
                  ),
                  Text('Câmera'),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                final PickedFile file =
                    await picker.getImage(source: ImageSource.gallery);
                onImageSelected(File(file.path));
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Padding(
                    padding: EdgeInsets.only(right: 8.0),
                    child: Icon(Icons.collections),
                  ),
                  Text('Galeria'),
                ],
              ),
            ),
          ],
        ),
      );
    } else {
      return CupertinoActionSheet(
        title: const Text('Selecionar foto para o item'),
        message: const Text('Escolha a origem da foto'),
        cancelButton: CupertinoActionSheetAction(
          onPressed: Navigator.of(context).pop,
          child: const Text('Cancelar'),
        ),
        actions: <Widget>[
          CupertinoActionSheetAction(
            isDefaultAction: true,
            onPressed: () {},
            child: const Text('Câmera'),
          ),
          CupertinoActionSheetAction(
            onPressed: () {},
            child: const Text('Galeria'),
          ),
        ],
      );
    }
  }
}
