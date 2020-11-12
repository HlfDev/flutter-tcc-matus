import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:matus_app/app/controllers/user_controller.dart';
import 'package:matus_app/app/screens/base/main_screen.dart';
import 'package:matus_app/app/themes/app_colors.dart';
import 'package:matus_app/app/widgets/image_type_selector.dart';

import 'package:provider/provider.dart';

class AccountSettingsTab extends StatefulWidget {
  @override
  _AccountSettingsTabState createState() => _AccountSettingsTabState();
}

class _AccountSettingsTabState extends State<AccountSettingsTab> {
  FirebaseFirestore db = FirebaseFirestore.instance;

  bool editandoCampo = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        padding: const EdgeInsets.all(16.0),
        child: Consumer<UserController>(builder: (_, userController, __) {
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
                            image: NetworkImage(userController.user.photoUrl))))
              else
                Container(),
              FlatButton(
                onPressed: () {},
                child: const Text(
                  'Alterar Foto',
                  style:
                      TextStyle(fontSize: 18.0, color: AppColor.primaryColor),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      enabled: editandoCampo,
                      initialValue: userController.user.name,
                      cursorColor: AppColor.primaryColor,
                      decoration: const InputDecoration(
                        icon: Icon(Icons.person),
                        labelText: 'Nome',
                        helperText:
                            'Clique no icone ao lado para salvar as alterações',
                        labelStyle: TextStyle(
                          color: AppColor.primaryColor,
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: AppColor.primaryColor),
                        ),
                      ),
                    ),
                  ),
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
                      onPressed: () {
                        setState(() {
                          editandoCampo = false;
                        });
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
                    Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => MainScreen()));
                  });
                },
                icon: const Icon(Icons.account_box),
                label: const Text('Sair da Conta'),
              ),
            ],
          );
        }),
      ),
    );
  }
}
