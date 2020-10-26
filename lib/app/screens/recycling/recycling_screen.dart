import 'package:flutter/material.dart';
import 'package:matus_app/app/themes/app_colors.dart';

class RecyclingPage extends StatefulWidget {
  @override
  _RecyclingPageState createState() => _RecyclingPageState();
}

class _RecyclingPageState extends State<RecyclingPage> {
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
            title: Text('Dicas de Reciclagem'),
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
