import 'package:brasil_fields/brasil_fields.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:matus_app/app/controllers/user_controller.dart';
import 'package:matus_app/app/models/announcement.dart';
import 'package:matus_app/app/controllers/announcement_controller.dart';
import 'package:matus_app/app/models/announcement_address.dart';
import 'package:matus_app/app/services/cep_aberto_api.dart';
import 'package:matus_app/app/themes/app_colors.dart';
import 'package:provider/provider.dart';

import 'components/images_form.dart';

class AnnouncementEditScreen extends StatefulWidget {
  AnnouncementEditScreen(Announcement a)
      : editing = a != null,
        announcement = a != null ? a.clone() : Announcement();

  final Announcement announcement;
  final bool editing;

  @override
  _AnnouncementEditScreenState createState() => _AnnouncementEditScreenState();
}

class _AnnouncementEditScreenState extends State<AnnouncementEditScreen>
    with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  AnnouncementAddress announcementAddress;

  final controllerCep = TextEditingController();
  final cepAbertoService = CepAbertoService();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: widget.announcement,
      child: Scaffold(
          appBar: AppBar(
            title: Text(widget.editing ? 'Editar Anúncio' : 'Criar Anúncio'),
            centerTitle: true,
          ),
          backgroundColor: Colors.white,
          body: Form(
            key: formKey,
            child: ListView(
              children: <Widget>[
                ImagesForm(widget.announcement),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      TextFormField(
                        keyboardType: TextInputType.text,
                        initialValue: widget.announcement.title,
                        validator: (name) {
                          if (name.isEmpty) return 'Preencha o titulo';
                          if (name.length < 6) return 'Título muito curto';
                          return null;
                        },
                        onSaved: (name) => widget.announcement.title = name,
                        cursorColor: AppColor.primaryColor,
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(40),
                        ],
                        maxLength: 40,
                        decoration: const InputDecoration(
                          icon: Icon(Icons.title),
                          labelText: 'Titulo',
                          labelStyle: TextStyle(
                            color: AppColor.primaryColor,
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide:
                                BorderSide(color: AppColor.primaryColor),
                          ),
                        ),
                      ),
                      TextFormField(
                        keyboardType: TextInputType.text,
                        initialValue: widget.announcement.description,
                        validator: (desc) {
                          if (desc.isEmpty) {
                            return 'Preencha a Descrição';
                          }
                          if (desc.length < 10) return 'Descrição muito curta';
                          return null;
                        },
                        onSaved: (desc) =>
                            widget.announcement.description = desc,
                        cursorColor: AppColor.primaryColor,
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(80),
                        ],
                        maxLength: 80,
                        decoration: const InputDecoration(
                          icon: Icon(Icons.description),
                          labelText: 'Descrição',
                          labelStyle: TextStyle(
                            color: AppColor.primaryColor,
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide:
                                BorderSide(color: AppColor.primaryColor),
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                RealInputFormatter(centavos: true),
                              ],
                              initialValue: widget.announcement.price != null
                                  ? widget.announcement.price.toString()
                                  : '',
                              validator: (price) {
                                if (price.isEmpty) {
                                  return 'Preencha o Preço';
                                }
                                return null;
                              },
                              onSaved: (price) =>
                                  widget.announcement.price = price,
                              cursorColor: AppColor.primaryColor,
                              decoration: const InputDecoration(
                                icon: Icon(Icons.monetization_on),
                                labelText: 'Preço',
                                labelStyle: TextStyle(
                                  color: AppColor.primaryColor,
                                ),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(color: AppColor.primaryColor),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: TextFormField(
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                PesoInputFormatter(),
                              ],
                              keyboardType: TextInputType.number,
                              initialValue: widget.announcement.weigth != null
                                  ? widget.announcement.weigth.toString()
                                  : '',
                              onSaved: (weigth) =>
                                  widget.announcement.weigth = weigth,
                              cursorColor: AppColor.primaryColor,
                              decoration: const InputDecoration(
                                icon: Icon(Icons.donut_small),
                                labelText: 'Peso (Opcional)',
                                labelStyle: TextStyle(
                                  color: AppColor.primaryColor,
                                ),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(color: AppColor.primaryColor),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 16.0,
                      ),
                      Row(
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(right: 16.0),
                            child: Icon(
                              Icons.linear_scale,
                              color: Colors.grey,
                            ),
                          ),
                          Expanded(
                            child: DropdownButtonFormField(
                              hint: Text(widget.announcement.unity ??
                                  'Medida (Opcional)'),
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
                              onChanged: (text) {
                                widget.announcement.unity = text as String;
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 16.0,
                      ),
                      Row(
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(right: 16.0),
                            child: Icon(
                              Icons.category,
                              color: Colors.grey,
                            ),
                          ),
                          Expanded(
                            child: DropdownButtonFormField(
                              validator: (category) {
                                if (widget.announcement.category == null) {
                                  return 'Selecione a Categoria';
                                }
                                return null;
                              },
                              hint: Text(
                                  widget.announcement.category ?? 'Categoria'),
                              items: [
                                'Papel',
                                'Plástico',
                                'Vidro',
                                'Metal',
                                'Madeira',
                                'Bateria',
                                'Peças',
                                'Óleo',
                              ].map(
                                (val) {
                                  return DropdownMenuItem<String>(
                                    value: val,
                                    child: Text(val),
                                  );
                                },
                              ).toList(),
                              onChanged: (text) {
                                widget.announcement.category = text as String;
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 16.0,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                CepInputFormatter(),
                              ],
                              initialValue:
                                  widget.announcement.announcementAddress.cep ??
                                      '',
                              validator: (cep) {
                                if (cep.isEmpty) return 'Preencha o CEP';
                                if (cep.length != 10) return 'CEP invalido';
                                if (widget.announcement.announcementAddress
                                        .city ==
                                    null) {
                                  return 'CEP invalido';
                                }
                                return null;
                              },
                              // ignore: void_checks
                              onChanged: (cep) {
                                if (cep.length == 10) {
                                  return widget.announcement.announcementAddress
                                      .cep = cep;
                                }
                              },
                              onSaved: (cep) => widget
                                  .announcement.announcementAddress.cep = cep,
                              cursorColor: AppColor.primaryColor,
                              decoration: const InputDecoration(
                                icon: Icon(Icons.location_history),
                                labelText: 'CEP',
                                helperText:
                                    'Clique na Lupa para Buscar o CEP digitado',
                                labelStyle: TextStyle(
                                  color: AppColor.primaryColor,
                                ),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(color: AppColor.primaryColor),
                                ),
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.search),
                            onPressed: () async {
                              if (widget.announcement.announcementAddress.cep
                                  .isNotEmpty) {
                                final cepAbertoAddress = await cepAbertoService
                                    .getAddressFromCep(widget
                                        .announcement.announcementAddress.cep);

                                if (cepAbertoAddress != null) {
                                  announcementAddress = AnnouncementAddress(
                                    cep: cepAbertoAddress.cep,
                                    state: cepAbertoAddress.estado.sigla,
                                    city: cepAbertoAddress.cidade.nome,
                                    neighbornhood: cepAbertoAddress.bairro,
                                  );

                                  setState(() {
                                    widget.announcement.announcementAddress
                                        .state = announcementAddress.state;
                                    widget.announcement.announcementAddress
                                        .city = announcementAddress.city;
                                    widget.announcement.announcementAddress
                                            .neighbornhood =
                                        announcementAddress.neighbornhood;
                                  });
                                }
                              }
                            },
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 8.0,
                      ),
                      if (widget.announcement.announcementAddress.city != null)
                        Padding(
                          padding:
                              const EdgeInsets.only(left: 30.0, right: 30.0),
                          child: SizedBox(
                            width: double.infinity,
                            child: Card(
                                color: AppColor.secondaryColor,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    '${widget.announcement.announcementAddress.neighbornhood}, ${widget.announcement.announcementAddress.city} - ${widget.announcement.announcementAddress.state}',
                                    textAlign: TextAlign.center,
                                  ),
                                )),
                          ),
                        )
                      else
                        Container(),
                      const SizedBox(
                        height: 16.0,
                      ),
                      Consumer2<Announcement, UserController>(
                          builder: (_, announcement, userController, __) {
                        return SizedBox(
                          height: 44,
                          child: RaisedButton(
                            onPressed: !announcement.loading
                                ? () async {
                                    if (formKey.currentState.validate()) {
                                      formKey.currentState.save();

                                      widget.announcement.announcementAddress
                                              .addressExtend =
                                          '${announcement.announcementAddress.city}, ${announcement.announcementAddress.state}, Brasil';

                                      await announcement.saveData();

                                      widget.announcement.user =
                                          userController.user.id;
                                      widget.announcement.announcementDate =
                                          Timestamp.now();

                                      context
                                          .read<AnnouncementController>()
                                          .update(announcement);
                                      Navigator.of(context).pop();
                                    }
                                  }
                                : null,
                            textColor: Colors.white,
                            color: Theme.of(context).primaryColor,
                            disabledColor:
                                Theme.of(context).primaryColor.withAlpha(100),
                            child: announcement.loading
                                ? const CircularProgressIndicator(
                                    valueColor:
                                        AlwaysStoppedAnimation(Colors.white),
                                  )
                                : Text(
                                    widget.editing
                                        ? 'Salvar Alterações'
                                        : 'Anunciar',
                                    style: const TextStyle(fontSize: 18.0),
                                  ),
                          ),
                        );
                      })
                    ],
                  ),
                )
              ],
            ),
          )),
    );
  }
}
