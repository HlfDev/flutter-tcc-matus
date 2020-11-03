import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:matus_app/app/controllers/announcement_controller.dart';
import 'package:matus_app/app/themes/app_colors.dart';
import 'package:provider/provider.dart';

class CategoryList extends StatefulWidget {
  const CategoryList();

  @override
  _CategoryItensState createState() => _CategoryItensState();
}

class _CategoryItensState extends State<CategoryList> {
  String findCategory(int index) {
    switch (index) {
      case 0:
        return 'Papel';
        break;
      case 1:
        return 'Plástico';
        break;
      case 2:
        return 'Vidro';
        break;
      case 3:
        return 'Metal';
        break;
      case 4:
        return 'Madeira';
        break;
      case 5:
        return 'Peças';
        break;
      case 6:
        return 'Óleo';
        break;
      default:
        return '';
    }
  }

  List<bool> isSelected = [
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false
  ];
  @override
  Widget build(BuildContext context) {
    return Consumer<AnnouncementController>(
        builder: (_, announcementManager, __) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: ToggleButtons(
          fillColor: AppColor.secondaryColor,
          onPressed: (int index) {
            setState(() {
              for (int buttonIndex = 0;
                  buttonIndex < isSelected.length;
                  buttonIndex++) {
                if (buttonIndex == index) {
                  isSelected[buttonIndex] = !isSelected[buttonIndex];
                  isSelected[buttonIndex]
                      ? announcementManager.category = findCategory(buttonIndex)
                      : announcementManager.category = '';
                } else {
                  isSelected[buttonIndex] = false;
                }
              }
            });
          },
          isSelected: isSelected,
          children: const <Widget>[
            CategoryItem(
              text: 'Papel',
              assetLocation:
                  'assets/images/announcement_screen/category_paper.svg',
            ),
            CategoryItem(
                text: 'Plástico',
                assetLocation:
                    'assets/images/announcement_screen/category_plastic.svg'),
            CategoryItem(
                text: 'Vidro',
                assetLocation:
                    'assets/images/announcement_screen/category_glass.svg'),
            CategoryItem(
                text: 'Metal',
                assetLocation:
                    'assets/images/announcement_screen/category_metal.svg'),
            CategoryItem(
              text: 'Madeira',
              assetLocation:
                  'assets/images/announcement_screen/category_wood.svg',
            ),
            CategoryItem(
              text: 'Bateria',
              assetLocation:
                  'assets/images/announcement_screen/category_battery.svg',
            ),
            CategoryItem(
                text: 'Peças',
                assetLocation:
                    'assets/images/announcement_screen/category_components.svg'),
            CategoryItem(
                text: 'Óleo',
                assetLocation:
                    'assets/images/announcement_screen/category_oil.svg'),
          ],
        ),
      );
    });
  }
}

class CategoryItem extends StatelessWidget {
  const CategoryItem({
    Key key,
    this.assetLocation,
    this.text,
  }) : super(key: key);

  final String assetLocation;
  final String text;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 60,
      height: 60,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: SvgPicture.asset(
              assetLocation,
              width: 20.0,
              height: 20.0,
            ),
          ),
          Align(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                text,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 12.0),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
