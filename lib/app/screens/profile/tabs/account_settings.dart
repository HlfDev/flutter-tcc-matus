import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:matus_app/app/models/user_manager.dart';
import 'package:matus_app/app/themes/app_colors.dart';
import 'package:provider/provider.dart';

class AccountSettingsTab extends StatefulWidget {
  @override
  _AccountSettingsTabState createState() => _AccountSettingsTabState();
}

class _AccountSettingsTabState extends State<AccountSettingsTab> {
  FirebaseFirestore db = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Consumer<UserManager>(builder: (_, userManager, __) {
        return Column(
          children: [
            Container(
                width: 150.0,
                height: 150.0,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        fit: BoxFit.fill,
                        image: NetworkImage(userManager.user.photoUrl)))),
            FlatButton(
              onPressed: () {
                // showModalBottomSheet(
                //     context: context,
                //     builder: (context) => ImageTypeSelector(
                //           image: (file) async {
                //             if (file != null) {
                //               final StorageUploadTask task = FirebaseStorage
                //                   .instance
                //                   .ref()
                //                   .child(
                //                       'users/${userManager.user.id}${DateTime.now().millisecondsSinceEpoch}')
                //                   .putFile(file);

                //               final StorageTaskSnapshot taskSnapshot =
                //                   await task.onComplete;
                //               final String url = await taskSnapshot.ref
                //                   .getDownloadURL() as String;

                //               if (url != null) {
                //                 final result = await db
                //                     .collection("users")
                //                     .doc(userManager.user.id)
                //                     .get();

                //                 result.reference.update({"photoUrl": url});
                //                 userManager.loadCurrentUser();
                //               }
                //             }
                //           },
                //         ));
              },
              child: const Text(
                'Alterar Foto',
                style: TextStyle(fontSize: 18.0, color: AppColor.primaryColor),
              ),
            ),
            RaisedButton.icon(
              color: AppColor.secondaryColor,
              onPressed: () {
                setState(() {
                  userManager.signOut();
                });
              },
              icon: const Icon(Icons.account_box),
              label: const Text('Sair da Conta'),
            ),
            RaisedButton.icon(
              color: Colors.red,
              onPressed: () {},
              icon: const Icon(Icons.remove_circle),
              label: const Text('Excluir Conta'),
            )
          ],
        );
      }),
    );
  }
}
