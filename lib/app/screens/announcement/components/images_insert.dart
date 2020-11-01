import 'dart:io';

import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:matus_app/app/models/announcement.dart';
import 'package:matus_app/app/themes/app_colors.dart';
import 'package:matus_app/app/widgets/image_type_selector.dart';

class ImagesForm extends StatefulWidget {
  const ImagesForm(this.announcement);

  final Announcement announcement;

  @override
  _ImagesFormState createState() => _ImagesFormState();
}

class _ImagesFormState extends State<ImagesForm> {
  @override
  Widget build(BuildContext context) {
    int imagesLength = widget.announcement.images.length;

    return FormField<List<dynamic>>(
      initialValue: List.from(widget.announcement.images),
      validator: (images) {
        if (images.isEmpty) {
          return 'Insira ao menos uma imagem';
        }
        return null;
      },
      onSaved: (images) {
        widget.announcement.newImages = images;
      },
      builder: (state) {
        void onImageSelected(File file) {
          state.value.add(file);
          state.didChange(state.value);
          Navigator.of(context).pop();

          imagesLength = state.value.length;
        }

        return Column(
          children: <Widget>[
            AspectRatio(
              aspectRatio: 1.5,
              child: Carousel(
                images: state.value.map<Widget>((image) {
                  return Stack(
                    fit: StackFit.expand,
                    children: <Widget>[
                      if (image is String)
                        Image.network(
                          image,
                          fit: BoxFit.cover,
                        )
                      else
                        Image.file(
                          image as File,
                          fit: BoxFit.cover,
                        ),
                      Align(
                        alignment: Alignment.topRight,
                        child: Card(
                          color: AppColor.secondaryColor,
                          child: IconButton(
                            icon: const Icon(Icons.remove),
                            color: AppColor.primaryColor,
                            onPressed: () {
                              state.value.remove(image);
                              state.didChange(state.value);
                              imagesLength = state.value.length;
                            },
                          ),
                        ),
                      )
                    ],
                  );
                }).toList()
                  ..add(Material(
                    color: Colors.grey[100],
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.add_a_photo),
                          color: Theme.of(context).primaryColor,
                          iconSize: 50,
                          onPressed: () {
                            if (Platform.isAndroid) {
                              showModalBottomSheet(
                                  context: context,
                                  builder: (_) => ImageTypeSelector(
                                        onImageSelected: onImageSelected,
                                      ));
                            } else {
                              showCupertinoModalPopup(
                                  context: context,
                                  builder: (_) => ImageTypeSelector(
                                        onImageSelected: onImageSelected,
                                      ));
                            }
                          },
                        ),
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text('Incluir Fotos'),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('$imagesLength de 5 Adicionadas'),
                        ),
                      ],
                    ),
                  )),
                dotSize: 4,
                dotSpacing: 15,
                dotBgColor: Colors.transparent,
                dotColor: Theme.of(context).primaryColor,
                autoplay: false,
              ),
            ),
            if (state.hasError)
              Container(
                margin: const EdgeInsets.only(top: 16, left: 16),
                alignment: Alignment.centerLeft,
                child: Text(
                  state.errorText,
                  style: const TextStyle(
                    color: Colors.red,
                    fontSize: 12,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
