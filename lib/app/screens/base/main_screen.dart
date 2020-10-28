import 'package:flutter/material.dart';
import 'package:matus_app/app/models/user_manager.dart';
import 'package:matus_app/app/screens/announcement/announcement_screen.dart';

import 'package:matus_app/app/screens/login/login_screen.dart';
import 'package:matus_app/app/themes/app_colors.dart';
import 'package:provider/provider.dart';

import '../../pages/mensagens.dart';
import '../../pages/perfil.dart';
import '../recycling/recycling_screen.dart';
import 'tab_item.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

final tabs = [
  'Anúncios',
  'Reciclagem',
  'Mensagens',
  'Perfil',
];

class _MainScreenState extends State<MainScreen> {
  int selectedPosition = 0;

  static final List<Widget> _tabSelected = <Widget>[
    AnnouncementScreen(),
    RecyclingPage(),
    MensagensPage(),
    PerfilPage(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      resizeToAvoidBottomInset: false,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => LoginScreen()),
          );
        },
        backgroundColor: AppColor.secondaryColor,
        child: const Icon(
          Icons.add,
          color: AppColor.primaryColor,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: _buildBottomTab(),
      body: _tabSelected.elementAt(selectedPosition),
    );
  }

  BottomAppBar _buildBottomTab() {
    return BottomAppBar(
      color: AppColor.primaryColor,
      shape: const CircularNotchedRectangle(),
      notchMargin: 5.0,
      child: Consumer<UserManager>(builder: (_, userManager, __) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            TabItem(
              text: tabs[0],
              icon: Icons.home,
              isSelected: selectedPosition == 0,
              onTap: () {
                setState(() {
                  selectedPosition = 0;
                });
              },
            ),
            TabItem(
              text: tabs[1],
              icon: Icons.nature,
              isSelected: selectedPosition == 1,
              onTap: () {
                setState(() {
                  selectedPosition = 1;
                });
              },
            ),
            const SizedBox(
              width: 48,
            ),
            TabItem(
              text: tabs[2],
              icon: Icons.message,
              isSelected: selectedPosition == 2,
              onTap: () {
                setState(() {
                  if (userManager.isLoggedIn == true) {
                    selectedPosition = 2;
                  } else {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => LoginScreen()),
                    );
                  }
                });
              },
            ),
            TabItem(
              text: tabs[3],
              icon: Icons.person,
              isSelected: selectedPosition == 3,
              onTap: () {
                setState(() {
                  if (userManager.isLoggedIn == true) {
                    selectedPosition = 3;
                  } else {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => LoginScreen()),
                    );
                  }
                });
              },
            ),
          ],
        );
      }),
    );
  }
}
