import 'package:flutter/material.dart';
import 'package:matus_app/app/themes/app_colors.dart';

class HorizontalIconTextWithArrow extends StatelessWidget {
  final String _text;
  final IconData _icon;
  final MainAxisAlignment _alignment;

  const HorizontalIconTextWithArrow(this._text, this._icon, this._alignment);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, left: 10.0),
      child: Row(
        mainAxisAlignment: _alignment,
        children: [
          Icon(
            _icon,
            color: AppColor.primaryColor,
          ),
          Padding(
              padding: const EdgeInsets.only(left: 4.0), child: Text(_text)),
          const Icon(
            Icons.expand_more,
            color: AppColor.primaryColor,
            size: 15.0,
          ),
        ],
      ),
    );
  }
}
