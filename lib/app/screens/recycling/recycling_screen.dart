import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:matus_app/app/screens/recycling/recycle_open_screen.dart';

class RecyclingPage extends StatefulWidget {
  @override
  _RecyclingPageState createState() => _RecyclingPageState();
}

class _RecyclingPageState extends State<RecyclingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Dicas de Reciclagem'),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: Column(
                children: [
                  SvgPicture.asset(
                    'assets/images/recycling_screen/recycling_image.svg',
                    width: MediaQuery.of(context).size.width * 0.25,
                    height: MediaQuery.of(context).size.height * 0.25,
                  ),
                  const SizedBox(height: 20.0),
                  const IconButtonRecycle(
                    image1:
                        'assets/images/announcement_screen/category_paper.svg',
                    text1: 'Papel',
                    image2:
                        'assets/images/announcement_screen/category_plastic.svg',
                    text2: 'Plástico',
                    image3:
                        'assets/images/announcement_screen/category_glass.svg',
                    text3: 'Vidro',
                  ),
                  const IconButtonRecycle(
                    image1:
                        'assets/images/announcement_screen/category_metal.svg',
                    text1: 'Metal',
                    image2:
                        'assets/images/announcement_screen/category_wood.svg',
                    text2: 'Madeira',
                    image3:
                        'assets/images/announcement_screen/category_battery.svg',
                    text3: 'Bateria',
                  ),
                  const IconButtonRecycle(
                    image1:
                        'assets/images/announcement_screen/category_components.svg',
                    text1: 'Peças',
                    image2:
                        'assets/images/announcement_screen/category_oil.svg',
                    text2: 'Óleo',
                    image3: '',
                    text3: '',
                  ),
                  const SizedBox(height: 100.0),
                ],
              ),
            ),
          ),
        ));
  }
}

class IconButtonRecycle extends StatelessWidget {
  const IconButtonRecycle({
    Key key,
    this.image1,
    this.image2,
    this.image3,
    this.text1,
    this.text2,
    this.text3,
  }) : super(key: key);

  final String image1;
  final String image2;
  final String image3;
  final String text1;
  final String text2;
  final String text3;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        IconButtonRecycleItem(image: image1, text: text1),
        IconButtonRecycleItem(image: image2, text: text2),
        IconButtonRecycleItem(image: image3, text: text3),
      ],
    );
  }
}

class IconButtonRecycleItem extends StatelessWidget {
  const IconButtonRecycleItem({
    Key key,
    this.image,
    this.text,
  }) : super(key: key);

  final String image;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          if (image.isEmpty)
            const SizedBox(
              width: 75.0,
              height: 75.0,
            )
          else
            IconButton(
              icon: SvgPicture.asset(
                image,
                width: 150.0,
                height: 150.0,
              ),
              iconSize: 60,
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (context) =>
                          RecyclingPageOpen(text: text, image: image)),
                );
              },
            ),
          Text(text)
        ],
      ),
    );
  }
}
