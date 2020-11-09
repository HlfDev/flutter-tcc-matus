import 'package:flutter/material.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';
import 'package:flutter_svg/svg.dart';
import 'package:matus_app/app/controllers/user_controller.dart';
import 'package:matus_app/app/themes/app_colors.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passController = TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.secondaryColor,
      key: scaffoldKey,
      appBar: AppBar(
        title: const Text('Realizar Acesso'),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                  padding: const EdgeInsets.all(16.0),
                  width: 200.0,
                  height: 200.0,
                  child: SvgPicture.asset(
                      'assets/images/login_screen/login_image.svg')),
              Card(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                child: Form(
                  key: formKey,
                  child: Consumer<UserController>(
                    builder: (_, userController, child) {
                      if (userController.loadingFace) {
                        return Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation(
                                Theme.of(context).primaryColor),
                          ),
                        );
                      }
                      if (userController.loading) {
                        return Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation(
                                Theme.of(context).primaryColor),
                          ),
                        );
                      }
                      return ListView(
                        padding: const EdgeInsets.all(16),
                        shrinkWrap: true,
                        children: <Widget>[
                          GoogleSignInButton(
                            darkMode: true,
                            text: 'Continuar com Google',
                            onPressed: () async {
                              await userController.signInWithGoogle(
                                  onFail: (e) {
                                scaffoldKey.currentState.showSnackBar(SnackBar(
                                  content: Text('Falha ao entrar: $e'),
                                  backgroundColor: Colors.red,
                                ));
                              }, onSuccess: () {
                                Navigator.of(context).pop();
                              });
                            },
                          ),
                          SizedBox(
                            height: 40.0,
                            child: FacebookSignInButton(
                                borderRadius: 5.0,
                                text: '    Continuar com Facebook',
                                onPressed: () async {
                                  await userController.signInWithFacebook(
                                      onFail: (e) {
                                    scaffoldKey.currentState
                                        .showSnackBar(SnackBar(
                                      content: Text('Falha ao entrar: $e'),
                                      backgroundColor: Colors.red,
                                    ));
                                  }, onSuccess: () {
                                    Navigator.of(context).pop();
                                  });
                                }),
                          )
                        ],
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
