import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:matus_app/app/components/location_dialog.dart';
import 'package:matus_app/app/themes/app_colors.dart';

class AnunciosPage extends StatefulWidget {
  @override
  _AnunciosPageState createState() => _AnunciosPageState();
}

class _AnunciosPageState extends State<AnunciosPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: CustomScrollView(
      slivers: [
        SliverAppBar(
          floating: true,
          snap: true,
          backgroundColor: AppColor.primaryColor,
          flexibleSpace: const FlexibleSpaceBar(
            title: Text('Anúncios'),
            centerTitle: true,
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.notifications),
              tooltip: 'Open shopping cart',
              onPressed: () {},
            ),
          ],
        ),
        SliverToBoxAdapter(
          child: Container(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        _IconeTextoSeta('Localização', Icons.my_location,
                            MainAxisAlignment.center),
                      ],
                    )
                  ],
                ),
                FlatButton(
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return const LocationDialog();
                          });
                    },
                    child: Text(
                      'Clique para definir a localização do anúncio',
                      style: TextStyle(fontSize: 12.0, color: Colors.grey[400]),
                    )),
                const _IconeTextoSeta('Filtrar por Categoria', Icons.category,
                    MainAxisAlignment.start),
                Container(
                    margin: const EdgeInsets.symmetric(vertical: 10.0),
                    height: 90.0,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: const <Widget>[
                        _CategoriaItens('Papel\nPapelão', Icons.dashboard),
                        _CategoriaItens('Plástico', Icons.dashboard),
                        _CategoriaItens('Vidro', Icons.dashboard),
                        _CategoriaItens('Metal', Icons.dashboard),
                        _CategoriaItens('Madeira', Icons.dashboard),
                        _CategoriaItens('Bateria', Icons.dashboard),
                        _CategoriaItens(
                            'Componente\nEletrônico', Icons.dashboard),
                        _CategoriaItens('Óleo', Icons.dashboard),
                      ],
                    )),
                const _IconeTextoSeta(
                    'Anúncios', Icons.store, MainAxisAlignment.start),
                Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      width: 200.0,
                      height: 30.0,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(80),
                          bottomRight: Radius.circular(10),
                        ),
                        color: AppColor.primaryColor,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Text(
                            'PLÁSTICO',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                    margin: const EdgeInsets.symmetric(vertical: 10.0),
                    height: 250.0,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: <Widget>[
                        _Anuncios(),
                        _Anuncios(),
                        _Anuncios(),
                        _Anuncios(),
                      ],
                    )),
                Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      width: 200.0,
                      height: 30.0,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(80),
                          bottomRight: Radius.circular(10),
                        ),
                        color: AppColor.primaryColor,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Text(
                            'PLÁSTICO',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                    margin: const EdgeInsets.symmetric(vertical: 10.0),
                    height: 250.0,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: <Widget>[
                        _Anuncios(),
                        _Anuncios(),
                        _Anuncios(),
                        _Anuncios(),
                      ],
                    )),
              ],
            ),
          ),
        ),
      ],
    ));
  }
}

class _IconeTextoSeta extends StatelessWidget {
  final String _text;
  final IconData _icon;
  final MainAxisAlignment _alignment;

  const _IconeTextoSeta(this._text, this._icon, this._alignment);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
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

class _CategoriaItens extends StatelessWidget {
  final String _text;
  final IconData _icon;

  const _CategoriaItens(this._text, this._icon);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: Container(
            width: 50.0,
            height: 50.0,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: const BorderRadius.all(Radius.circular(5)),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 1,
                  blurRadius: 1,
                  offset: const Offset(0, 3), // changes position of shadow
                ),
              ],
            ),
            child: IconButton(
              onPressed: () {},
              icon: Icon(
                _icon,
                color: AppColor.primaryColor,
              ),
            ),
          ),
        ),
        Text(
          _text,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class _Anuncios extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            width: 150.0,
            height: 205.0,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 1,
                  blurRadius: 3,
                  offset: const Offset(0, 3), // changes position of shadow
                ),
              ],
            ),
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(
                      horizontal: 8.0, vertical: 8.0),
                  width: 145.0,
                  height: 100.0,
                  decoration: const BoxDecoration(
                    color: AppColor.primaryColor,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                ),
                const Text(
                  'Canudos de Plas...',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      '10 \$',
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 25.0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(2.0),
                        alignment: Alignment.center,
                        width: 100.0,
                        child: RaisedButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          onPressed: () {},
                          color: AppColor.primaryColor,
                          child: const Text(
                            'VISUALIZAR',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                        padding:
                            const EdgeInsets.only(bottom: 5.0, right: 10.0),
                        onPressed: () {},
                        icon: const Icon(
                          Icons.favorite_border,
                          size: 24.0,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
