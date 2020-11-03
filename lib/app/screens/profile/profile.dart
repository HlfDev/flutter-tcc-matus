import 'package:flutter/material.dart';
import 'package:matus_app/app/screens/profile/tabs/account_settings.dart';
import 'package:matus_app/app/screens/profile/tabs/my_announcements.dart';
import 'package:matus_app/app/screens/profile/tabs/saved_announcements.dart';
import 'package:matus_app/app/themes/app_colors.dart';

class PerfilPage extends StatefulWidget {
  @override
  _PerfilPageState createState() => _PerfilPageState();
}

class _PerfilPageState extends State<PerfilPage> {
  @override
  Widget build(BuildContext context) {
    return TabBarDemo();
  }
}

class TabBarDemo extends StatefulWidget {
  @override
  _TabBarDemoState createState() => _TabBarDemoState();
}

class _TabBarDemoState extends State<TabBarDemo> {
  final tabs = ['Meus Anúncios', 'Anúncios Salvos', 'Configurações da Conta'];

  int _selectedPosition = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DefaultTabController(
        length: 3,
        child: NestedScrollView(
          headerSliverBuilder: (context, value) {
            return [
              SliverAppBar(
                backgroundColor: AppColor.primaryColor,
                floating: true,
                pinned: true,
                snap: true,
                flexibleSpace: FlexibleSpaceBar(
                  centerTitle: true,
                  titlePadding: const EdgeInsets.only(bottom: 60.0),
                  title: Text(
                    tabs[_selectedPosition],
                    style: const TextStyle(fontSize: 16.0),
                  ),
                ),
                bottom: TabBar(
                  indicatorColor: AppColor.secondaryColor,
                  tabs: const [
                    Tab(icon: Icon(Icons.store)),
                    Tab(icon: Icon(Icons.loyalty)),
                    Tab(icon: Icon(Icons.account_box)),
                  ],
                  onTap: (index) {
                    setState(() {
                      _selectedPosition = index;
                    });
                  },
                ),
              ),
            ];
          },
          body: TabBarView(
            children: [
              MyAnnouncementsTab(),
              SavedAnnouncementsTab(),
              AccountSettingsTab(),
            ],
          ),
        ),
      ),
    );
  }
}
