import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:matus_app/app/models/announcement_manager.dart';

import 'package:matus_app/app/screens/announcement/components/announcement_list_tile.dart';
import 'package:matus_app/app/themes/app_colors.dart';
import 'package:provider/provider.dart';

class SavedAnnouncementsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<AnnouncementManager>(
      builder: (_, userManager, __) {
        final userAnnouncements = userManager.myAnnouncements;
        if (userAnnouncements.isEmpty) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: SvgPicture.asset(
                  'assets/images/announcement_screen/announcement_not_found.svg',
                  width: 400.0,
                  height: 400.0,
                ),
              ),
              const Text(
                'Nenhum Anúncio foi encontrado :(',
                style: TextStyle(
                    fontWeight: FontWeight.w400,
                    color: AppColor.primaryColor,
                    fontSize: 18.0),
              ),
            ],
          );
        }
        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.all(4),
          itemCount: userAnnouncements.length,
          itemBuilder: (_, index) {
            return AnnouncementListTile(userAnnouncements[index]);
          },
        );
      },
    );
  }
}