import 'package:flutter/material.dart';

class AnunciarPage extends StatefulWidget {
  @override
  _AnunciarPageState createState() => _AnunciarPageState();
}

class _AnunciarPageState extends State<AnunciarPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Row(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    padding: const EdgeInsets.only(top: 35.0),
                    icon: const Icon(
                      Icons.arrow_back_ios,
                      size: 24.0,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
