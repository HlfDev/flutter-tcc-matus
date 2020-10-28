import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:matus_app/app/models/announcement_manager.dart';
import 'package:matus_app/app/themes/app_colors.dart';
import 'package:provider/provider.dart';

class CategoryItens extends StatefulWidget {
  const CategoryItens({
    Key key,
    @required String text,
    @required String assetLocation,
  })  : _text = text,
        _assetLocation = assetLocation,
        super(key: key);

  final String _text;
  final String _assetLocation;

  @override
  _CategoryItensState createState() => _CategoryItensState();
}

class _CategoryItensState extends State<CategoryItens> {
  List<bool> isSelected = [false];

  @override
  Widget build(BuildContext context) {
    return Consumer<AnnouncementManager>(builder: (_, announcementManager, __) {
      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ToggleButtons(
              fillColor: AppColor.secondaryColor,
              onPressed: (int index) {
                setState(() {
                  isSelected[0] = !isSelected[0];
                  isSelected[0]
                      ? announcementManager.category = 'z'
                      : announcementManager.category = '';
                });
              },
              isSelected: isSelected,
              children: <Widget>[
                SvgPicture.asset(
                  widget._assetLocation,
                  width: 30.0,
                  height: 30.0,
                ),
              ],
            ),
          ),
          Text(
            widget._text,
            textAlign: TextAlign.center,
          ),
        ],
      );
    });
  }
}
