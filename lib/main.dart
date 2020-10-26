import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:matus_app/app/models/user_manager.dart';
import 'package:matus_app/app/themes/app_colors.dart';
import 'package:provider/provider.dart';
import 'app/screens/base/main_screen.dart';

// ignore: avoid_void_async
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => UserManager(),
      lazy: false,
      child: MaterialApp(
        title: 'Matus',
        theme: ThemeData(
          iconTheme: const IconThemeData(color: AppColor.primaryColor),
          primarySwatch: AppColor.primaryColor,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        initialRoute: MainScreen.tag,
        routes: {
          MainScreen.tag: (context) => MainScreen(),
        },
      ),
    );
  }
}
