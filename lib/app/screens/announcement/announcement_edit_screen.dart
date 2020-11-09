import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:matus_app/app/models/announcement.dart';
import 'package:matus_app/app/controllers/announcement_controller.dart';
import 'package:matus_app/app/themes/app_colors.dart';
import 'package:provider/provider.dart';

import 'components/images_form.dart';

class AnnouncementEditScreen extends StatelessWidget {
  AnnouncementEditScreen(Announcement a)
      : editing = a != null,
        announcement = a != null ? a.clone() : Announcement();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final Announcement announcement;
  final bool editing;
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: announcement,
      child: Scaffold(
          appBar: AppBar(
            title: Text(editing ? 'Editar Anúncio' : 'Criar Anúncio'),
            centerTitle: true,
          ),
          backgroundColor: Colors.white,
          body: Form(
            key: formKey,
            child: ListView(
              children: <Widget>[
                ImagesForm(announcement),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      TextFormField(
                        keyboardType: TextInputType.text,
                        initialValue: announcement.title,
                        validator: (name) {
                          if (name.isEmpty) return 'Preencha o titulo';
                          if (name.length < 6) return 'Título muito curto';
                          return null;
                        },
                        onSaved: (name) => announcement.title = name,
                        cursorColor: AppColor.primaryColor,
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
                        initialValue: announcement.description,
                        validator: (desc) {
                          if (desc.isEmpty) {
                            return 'Preencha a Descrição';
                          }
                          if (desc.length < 10) return 'Descrição muito curta';
                          return null;
                        },
                        onSaved: (desc) => announcement.description = desc,
                        cursorColor: AppColor.primaryColor,
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
                              initialValue: announcement.price != null
                                  ? announcement.price.toString()
                                  : '',
                              validator: (price) {
                                if (price.isEmpty) {
                                  return 'Preencha o Preço';
                                }
                                return null;
                              },
                              onSaved: (price) => announcement.price = price,
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
                              initialValue: announcement.weigth != null
                                  ? announcement.weigth.toString()
                                  : '',
                              onSaved: (weigth) => announcement.weigth = weigth,
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
                              hint: Text(
                                  announcement.unity ?? 'Medida (Opcional)'),
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
                                announcement.unity = text as String;
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
                                if (announcement.category == null) {
                                  return 'Selecione a Categoria';
                                }
                                return null;
                              },
                              hint: Text(announcement.category ?? 'Categoria'),
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
                                announcement.category = text as String;
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 16.0,
                      ),
                      TextFormField(
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          CepInputFormatter(),
                        ],
                        initialValue: announcement.announcementAddress.cep,
                        validator: (cep) {
                          if (cep.isEmpty) return 'Preencha o CEP';
                          if (cep.length != 10) return 'CEP invalido';
                          if (announcement.announcementAddress.city != null) {
                            return 'CEP invalido';
                          }
                          return null;
                        },
                        onFieldSubmitted: (cep) async {},
                        onSaved: (cep) =>
                            announcement.announcementAddress.cep = cep,
                        cursorColor: AppColor.primaryColor,
                        decoration: const InputDecoration(
                          icon: Icon(Icons.location_history),
                          labelText: 'CEP',
                          labelStyle: TextStyle(
                            color: AppColor.primaryColor,
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide:
                                BorderSide(color: AppColor.primaryColor),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 16.0,
                      ),
                      Consumer<Announcement>(builder: (_, announcement, __) {
                        return SizedBox(
                          height: 44,
                          child: RaisedButton(
                            onPressed: !announcement.loading
                                ? () async {
                                    if (formKey.currentState.validate()) {
                                      formKey.currentState.save();
                                      await announcement.saveData();

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
                                    editing ? 'Salvar Alterações' : 'Anúnciar',
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
