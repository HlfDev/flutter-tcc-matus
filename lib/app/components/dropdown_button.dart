import 'package:flutter/material.dart';

class DropDownButton extends StatefulWidget {
  final String initialText;

  const DropDownButton(this.initialText, {Key key}) : super(key: key);
  @override
  _DropDownButtonState createState() => _DropDownButtonState();
}

/// This is the private State class that goes with MyStatefulWidget.
class _DropDownButtonState extends State<DropDownButton> {
  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: widget.initialText,
      icon: const Icon(Icons.arrow_downward),
      elevation: 16,
      style: const TextStyle(color: Colors.deepPurple),
      underline: Container(
        height: 2,
        color: Colors.deepPurpleAccent,
      ),
      onChanged: (String newValue) {
        setState(() {
          //widget.initialText = newValue;
        });
      },
      items: <String>['Estado', 'Cidade', 'Bairro']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}
