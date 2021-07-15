import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:matus_app/app/controllers/user_controller.dart';
import 'package:matus_app/app/screens/base/main_screen.dart';
import 'package:matus_app/app/themes/app_colors.dart';

import 'package:provider/provider.dart';

class AccountSettingsTab extends StatefulWidget {
  @override
  _AccountSettingsTabState createState() => _AccountSettingsTabState();
}

class _AccountSettingsTabState extends State<AccountSettingsTab> {
  FirebaseFirestore db = FirebaseFirestore.instance;
  final myController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool editandoCampo = false;
  final ImagePicker picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: Consumer<UserController>(builder: (_, userController, __) {
            userController.isLoggedIn
                ? myController.text = userController.user.name
                // ignore: unnecessary_statements
                : '';
            return Column(
              children: [
                const SizedBox(height: 50.0),
                if (userController.isLoggedIn)
                  Container(
                      width: 150.0,
                      height: 150.0,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              fit: BoxFit.fill,
                              image:
                                  NetworkImage(userController.user.photoUrl))))
                else
                  Container(),
                FlatButton(
                  onPressed: () async {
                    final PickedFile file =
                        await picker.getImage(source: ImageSource.gallery);
                    if (file == null) return;
                    final UploadTask task = FirebaseStorage.instance
                        .ref()
                        .child(
                            'users/${userController.user.id}${DateTime.now().millisecondsSinceEpoch}')
                        .putFile(File(file.path));

                    final TaskSnapshot taskSnapshot =
                        await task.whenComplete(() => null);
                    final String url = await taskSnapshot.ref.getDownloadURL();

                    if (url != null) {
                      final result = await db
                          .collection("users")
                          .doc(userController.user.id)
                          .get();

                      result.reference.update({"photoUrl": url});
                      setState(() {
                        userController.user.photoUrl = url;
                      });
                    }
                  },
                  child: const Text(
                    'Alterar Foto',
                    style:
                        TextStyle(fontSize: 18.0, color: AppColor.primaryColor),
                  ),
                ),
                Row(
                  children: [
                    if (userController.isLoggedIn)
                      Expanded(
                        child: Form(
                          key: formKey,
                          child: TextFormField(
                            enabled: editandoCampo,
                            cursorColor: AppColor.primaryColor,
                            controller: myController,
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(20),
                            ],
                            maxLength: 20,
                            validator: (text) {
                              if (text.isEmpty) {
                                return 'Preencha o nome';
                              }

                              if (text.length < 5) {
                                return 'Nome muito curto!';
                              }

                              return null;
                            },
                            decoration: const InputDecoration(
                              icon: Icon(Icons.person),
                              labelText: 'Nome',
                              helperText:
                                  'Clique no icone ao lado para salvar alterações',
                              labelStyle: TextStyle(
                                color: AppColor.primaryColor,
                              ),
                              enabledBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: AppColor.primaryColor),
                              ),
                            ),
                          ),
                        ),
                      )
                    else
                      Container(),
                    if (!editandoCampo)
                      IconButton(
                        onPressed: () {
                          setState(() {
                            editandoCampo = true;
                          });
                        },
                        icon: const Icon(Icons.edit),
                      )
                    else
                      IconButton(
                        onPressed: () async {
                          if (formKey.currentState.validate()) {
                            final result = await db
                                .collection("users")
                                .doc(userController.user.id)
                                .get();

                            result.reference
                                .update({"name": myController.text});

                            setState(() {
                              editandoCampo = false;
                              userController.user.name = myController.text;
                            });
                          }
                        },
                        icon: const Icon(Icons.save),
                      )
                  ],
                ),
                const SizedBox(height: 24.0),
                RaisedButton.icon(
                  color: AppColor.secondaryColor,
                  onPressed: () {
                    setState(() {
                      userController.signOut();
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => MainScreen()));
                    });
                  },
                  icon: const Icon(Icons.account_box),
                  label: const Text('Sair da Conta'),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}
