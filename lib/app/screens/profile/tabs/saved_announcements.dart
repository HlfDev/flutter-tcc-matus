import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:matus_app/app/controllers/announcement_controller.dart';
import 'package:matus_app/app/controllers/user_controller.dart';
import 'package:matus_app/app/screens/announcement/components/announcement_list_tile.dart';
import 'package:matus_app/app/themes/app_colors.dart';
import 'package:provider/provider.dart';

class SavedAnnouncementsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer2<AnnouncementController, UserController>(
      builder: (_, announcementController, userController, __) {
        final myAnnouncements =
            announcementController.findSavedAnnouncementsCurrentUser(
                userController.user.savedAnnouncements);
        if (myAnnouncements.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  'assets/images/profile_screen/announcement_favorited_not_found.svg',
                  width: MediaQuery.of(context).size.width * 0.3,
                  height: MediaQuery.of(context).size.height * 0.3,
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 24.0),
                  child: Text(
                    'Você não tem nenhum anúncio salvo',
                    style: TextStyle(
                        fontWeight: FontWeight.w400,
                        color: AppColor.primaryColor,
                        fontSize: 18.0),
                  ),
                ),
              ],
            ),
          );
        } else {
          return ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.all(4),
            itemCount: myAnnouncements.length,
            itemBuilder: (_, index) {
              return AnnouncementListTile(myAnnouncements[index]);
            },
          );
        }
      },
    );
  }
}
