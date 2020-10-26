import 'package:flutter/material.dart';
import 'package:matus_app/app/themes/app_colors.dart';

class TabItem extends StatelessWidget {
  final String text;
  final IconData icon;
  final bool isSelected;
  final Function() onTap;

  const TabItem({Key key, this.text, this.icon, this.isSelected, this.onTap})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(6, 3, 6, 3),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(
              icon,
              color: isSelected ? AppColor.secondaryColor : Colors.white,
            ),
            Text(
              text,
              style: TextStyle(
                  color: isSelected ? AppColor.secondaryColor : Colors.white,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  fontSize: 10),
            )
          ],
        ),
      ),
    );
  }
}
