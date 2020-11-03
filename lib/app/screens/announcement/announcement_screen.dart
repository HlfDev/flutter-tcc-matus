import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:matus_app/app/controllers/announcement_controller.dart';
import 'package:matus_app/app/controllers/user_controller.dart';
import 'package:matus_app/app/screens/announcement/components/announcement_category.dart';
import 'package:matus_app/app/screens/announcement/components/announcement_list_tile.dart';
import 'package:matus_app/app/themes/app_colors.dart';
import 'package:matus_app/app/widgets/icons.dart';
import 'package:matus_app/app/widgets/location_dialog.dart';
import 'package:provider/provider.dart';

import 'components/search_dialog.dart';

class AnnouncementScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Consumer<AnnouncementController>(
          builder: (_, announcementManager, __) {
            if (announcementManager.search.isEmpty) {
              return const Text('Anúncios');
            } else {
              return LayoutBuilder(
                builder: (_, constraints) {
                  return GestureDetector(
                    onTap: () async {
                      final search = await showDialog<String>(
                          context: context,
                          builder: (_) =>
                              SearchDialog(announcementManager.search));
                      if (search != null) {
                        announcementManager.search = search;
                      }
                    },
                    child: SizedBox(
                        width: constraints.biggest.width,
                        child: Text(
                          announcementManager.search,
                          textAlign: TextAlign.center,
                        )),
                  );
                },
              );
            }
          },
        ),
        actions: <Widget>[
          Consumer<AnnouncementController>(
            builder: (_, announcementManager, __) {
              if (announcementManager.search.isEmpty) {
                return IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () async {
                    final search = await showDialog<String>(
                        context: context,
                        builder: (_) =>
                            SearchDialog(announcementManager.search));
                    if (search != null) {
                      announcementManager.search = search;
                    }
                  },
                );
              } else {
                return IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () async {
                    announcementManager.search = '';
                  },
                );
              }
            },
          )
        ],
      ),
      body: Consumer2<AnnouncementController, UserController>(
          builder: (_, announcementController, userController, __) {
        return RefreshIndicator(
          onRefresh: () async {
            await announcementController.loadAnnouncement();
            await userController.loadAllUsers();
          },
          child: Column(
            children: [
              const HorizontalIconTextWithArrow(
                  'Localização', Icons.my_location, MainAxisAlignment.center),
              FlatButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return const LocationDialog();
                        });
                  },
                  child: Text(
                    'Clique para alterar a localização de busca',
                    style: TextStyle(fontSize: 12.0, color: Colors.grey[400]),
                  )),
              const HorizontalIconTextWithArrow('Filtrar por Categoria',
                  Icons.category, MainAxisAlignment.start),
              SizedBox(
                height: 80.0,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: const [CategoryList()],
                ),
              ),
              const HorizontalIconTextWithArrow(
                  'Anúncios', Icons.storefront, MainAxisAlignment.start),
              const SizedBox(
                height: 8.0,
              ),
              Consumer<AnnouncementController>(
                builder: (_, announcementManager, __) {
                  final filteredAnnoucements =
                      announcementManager.filteredAnnouncements;
                  if (announcementManager.filteredAnnouncements.isEmpty) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: SvgPicture.asset(
                            'assets/images/announcement_screen/announcement_not_found.svg',
                            width: 300.0,
                            height: 300.0,
                          ),
                        ),
                        const Text(
                          'Nenhum Anúncio foi encontrado :(',
                          style: TextStyle(
                              fontWeight: FontWeight.w400,
                              color: AppColor.primaryColor,
                              fontSize: 18.0),
                        ),
                        RaisedButton(
                          onPressed: () async {
                            await announcementController.loadAnnouncement();
                            await userController.loadAllUsers();
                          },
                          child: const Text('Tentar Novamente'),
                        )
                      ],
                    );
                  }
                  return Expanded(
                    child: ListView.builder(
                      //shrinkWrap: true,
                      //physics: const NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.all(4),
                      itemCount: filteredAnnoucements.length,
                      itemBuilder: (_, index) {
                        return AnnouncementListTile(
                            filteredAnnoucements[index]);
                      },
                    ),
                  );
                },
              ),
              const SizedBox(
                height: 40.0,
              ),
            ],
          ),
        );
      }),
    );
  }
}
