import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_webservice/places.dart';

import 'package:matus_app/app/controllers/announcement_controller.dart';
import 'package:matus_app/app/controllers/user_controller.dart';
import 'package:matus_app/app/screens/announcement/components/announcement_category_list.dart';
import 'package:matus_app/app/screens/announcement/components/announcement_list_tile.dart';
import 'package:matus_app/app/themes/app_colors.dart';
import 'package:matus_app/app/widgets/icons.dart';

import 'package:provider/provider.dart';

import 'components/search_dialog.dart';

class AnnouncementScreen extends StatefulWidget {
  static const kGoogleApiKey = "AIzaSyCXhsY3r1G0xuj7fhhcZon2i_EU_VDtdXU";

  @override
  _AnnouncementScreenState createState() => _AnnouncementScreenState();
}

class _AnnouncementScreenState extends State<AnnouncementScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Consumer<AnnouncementController>(
          builder: (_, announcementController, __) {
            if (announcementController.search.isEmpty) {
              return const Text('Anúncios');
            } else {
              return LayoutBuilder(
                builder: (_, constraints) {
                  return GestureDetector(
                    onTap: () async {
                      final search = await showDialog<String>(
                          context: context,
                          builder: (_) =>
                              SearchDialog(announcementController.search));
                      if (search != null) {
                        announcementController.search = search;
                      }
                    },
                    child: SizedBox(
                        width: constraints.biggest.width,
                        child: Text(
                          announcementController.search,
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
            builder: (_, announcementController, __) {
              if (announcementController.search.isEmpty) {
                return IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () async {
                    final search = await showDialog<String>(
                        context: context,
                        builder: (_) =>
                            SearchDialog(announcementController.search));
                    if (search != null) {
                      announcementController.search = search;
                    }
                  },
                );
              } else {
                return IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () async {
                    announcementController.search = '';
                  },
                );
              }
            },
          )
        ],
      ),
      body: Consumer2<AnnouncementController, UserController>(
          builder: (_, announcementController, userController, __) {
        return Column(
          children: [
            const HorizontalIconTextWithArrow(
                'Localização', Icons.my_location, MainAxisAlignment.center),
            FlatButton(
                onPressed: () async {
                  final Prediction p = await PlacesAutocomplete.show(
                      context: context,
                      startText: announcementController.location,
                      apiKey: AnnouncementScreen.kGoogleApiKey,
                      language: "pt",
                      hint: "Pesquisar",
                      types: ['(cities)'],
                      components: [Component(Component.country, "br")]);

                  if (p != null) {
                    setState(() {
                      announcementController.location = p.description;
                    });
                  }
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Center(
                        child: Text(
                          announcementController.location.isEmpty
                              ? 'Clique para selecionar a localização de busca'
                              : announcementController.location,
                          style: const TextStyle(
                              fontSize: 14.0, color: Colors.grey),
                        ),
                      ),
                    ),
                    if (announcementController.location.isEmpty)
                      Container()
                    else
                      IconButton(
                        icon: const Icon(Icons.location_off),
                        onPressed: () {
                          announcementController.location = '';
                        },
                      )
                  ],
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
                        padding: const EdgeInsets.only(top: 24.0),
                        child: SvgPicture.asset(
                          'assets/images/announcement_screen/announcement_not_found.svg',
                          width: MediaQuery.of(context).size.width * 0.3,
                          height: MediaQuery.of(context).size.height * 0.3,
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(top: 24.0),
                        child: Text(
                          'Nenhum anúncio foi encontrado :(',
                          style: TextStyle(
                              fontWeight: FontWeight.w400,
                              color: AppColor.primaryColor,
                              fontSize: 18.0),
                        ),
                      ),
                    ],
                  );
                }
                return Expanded(
                  child: RefreshIndicator(
                    onRefresh: () async {
                      await announcementController.loadAllAnnouncements();
                      await userController.loadAllUsers();
                    },
                    child: ListView.builder(
                      padding: const EdgeInsets.all(4),
                      itemCount: filteredAnnoucements.length,
                      itemBuilder: (_, index) {
                        return AnnouncementListTile(
                            filteredAnnoucements[index]);
                      },
                    ),
                  ),
                );
              },
            ),
            const SizedBox(
              height: 40.0,
            ),
          ],
        );
      }),
    );
  }
}
