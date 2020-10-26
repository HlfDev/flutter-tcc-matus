import 'package:flutter/material.dart';
import 'package:matus_app/app/themes/app_colors.dart';

class MensagensPage extends StatefulWidget {
  @override
  _MensagensPageState createState() => _MensagensPageState();
}

class _MensagensPageState extends State<MensagensPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: CustomScrollView(
      slivers: [
        const SliverAppBar(
          floating: true,
          snap: true,
          backgroundColor: AppColor.primaryColor,
          flexibleSpace: FlexibleSpaceBar(
            title: Text('Mensagens'),
            centerTitle: true,
          ),
        ),
        SliverToBoxAdapter(
          child: Container(),
        ),
      ],
    ));
  }
}
