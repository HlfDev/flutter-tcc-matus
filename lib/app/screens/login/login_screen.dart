import 'package:flutter/material.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';
import 'package:flutter_svg/svg.dart';
import 'package:matus_app/app/models/user_manager.dart';
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
                  child: Consumer<UserManager>(
                    builder: (_, userManager, child) {
                      return ListView(
                        padding: const EdgeInsets.all(16),
                        shrinkWrap: true,
                        children: <Widget>[
                          GoogleSignInButton(
                            darkMode: true,
                            text: 'Continuar com Google',
                            onPressed: () async {
                              await userManager.signInWithGoogle();
                              Navigator.pop(context);
                            },
                          ),
                          SizedBox(
                            height: 40.0,
                            child: FacebookSignInButton(
                              borderRadius: 5.0,
                              text: '    Continuar com Facebook',
                              onPressed: () {},
                            ),
                          )
                        ],
                      );
                    },
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: FlatButton(
                        onPressed: () {},
                        padding: EdgeInsets.zero,
                        child: const Text('Esqueci minha senha'),
                      ),
                    ),
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
