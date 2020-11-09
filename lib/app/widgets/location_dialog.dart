import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'dropdown_button.dart';

class LocationDialog extends StatelessWidget {
  const LocationDialog({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0)), //this right here
      child: SizedBox(
        height: 500,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                  width: 150.0,
                  height: 150.0,
                  child: SvgPicture.asset(
                      "assets/images/adverts_screen/my_location.svg")),
              DropdownButtonFormField(
                hint: const Text('Estado'),
                items: [
                  'G - Grama',
                  'KG - Quilograma',
                  'T - Tonelada',
                  'L - Litro',
                ].map(
                  (val) {
                    return DropdownMenuItem<String>(
                      value: val,
                      child: Text(val),
                    );
                  },
                ).toList(),
                onChanged: (text) {},
              ),
              const DropDownButton('Cidade'),
              const DropDownButton('Bairro'),
              SizedBox(
                width: 320.0,
                child: RaisedButton(
                  onPressed: () {},
                  color: const Color(0xFF1BC0C5),
                  child: const Text(
                    "Save",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
