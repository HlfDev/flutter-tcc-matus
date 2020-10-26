import 'package:flutter/material.dart';
import 'package:matus_app/app/themes/app_colors.dart';

class PaginaAberta extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                Column(
                  children: [
                    Container(
                      height: 200.0,
                      color: Colors.blue,
                    ),
                    Container(
                        margin: const EdgeInsets.all(5.0),
                        width: 250.0,
                        height: 30.0,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius:
                              const BorderRadius.all(Radius.circular(20)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 1,
                              blurRadius: 5,
                              offset: const Offset(
                                  0, 3), // changes position of shadow
                            ),
                          ],
                        ),
                        child: const Center(
                          child: Text(
                            'Canudos de Plástisco',
                            style: TextStyle(
                              color: AppColor.primaryColor,
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )),
                    const _IconeTextoSeta('Descrição: ', Icons.description,
                        MainAxisAlignment.start),
                    Container(
                      padding: const EdgeInsets.all(8.0),
                      width: 250,
                      height: 75,
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: AppColor.primaryColor, width: 2.0),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(5)),
                      ),
                    ),
                    const _IconeTextoSeta(
                        'Quantidade: 30', Icons.info, MainAxisAlignment.start),
                    const _IconeTextoSeta('Unidade de Medida: Sacolas',
                        Icons.info, MainAxisAlignment.start),
                    const _IconeTextoSeta('Peso: não informado',
                        Icons.account_balance_wallet, MainAxisAlignment.start),
                    const _IconeTextoSeta(
                        'Jardim Santa Lucia, Campinas - São Paulo',
                        Icons.location_on,
                        MainAxisAlignment.start),
                    const _IconeTextoSeta('Data do anúncio: 28/08/2020 10:47',
                        Icons.date_range, MainAxisAlignment.start),
                    const Divider(),
                    Text(
                      'Anunciante',
                      style: TextStyle(
                          color: Colors.grey[500],
                          fontSize: 12.0,
                          fontWeight: FontWeight.bold),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.account_circle,
                          color: AppColor.primaryColor,
                        ),
                        const Text(
                          'João da Silva Mello',
                          style: TextStyle(
                            color: AppColor.primaryColor,
                            fontSize: 12.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Container(
                            width: 7.0,
                            height: 7.0,
                            decoration: const BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(100.0)),
                              color: Colors.green,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(2.0),
                          alignment: Alignment.center,
                          child: SizedBox(
                            width: 250.0,
                            child: RaisedButton(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              onPressed: () {},
                              color: AppColor.primaryColor,
                              child: const Text(
                                'ENVIAR MENSAGEM',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
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
                    IconButton(
                      padding: const EdgeInsets.only(top: 35.0),
                      icon: const Icon(
                        Icons.favorite_border,
                        size: 24.0,
                      ),
                      onPressed: () {},
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
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
      padding: const EdgeInsets.only(top: 8.0, left: 26.0, bottom: 2.0),
      child: Row(
        mainAxisAlignment: _alignment,
        children: [
          Icon(
            _icon,
            color: AppColor.primaryColor,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 4.0),
            child: Text(
              _text,
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColor.primaryColor,
                  fontSize: 10.0),
            ),
          ),
        ],
      ),
    );
  }
}
