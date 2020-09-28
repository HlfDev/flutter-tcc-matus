import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  static String tag = '/home';
  @override
  Widget build(BuildContext context) {
    var _snapshots = FirebaseFirestore.instance
        .collection('todo')
        //.where('excluido', isEqualTo: false)
        .orderBy('data', descending: false)
        .snapshots();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Matus'),
        centerTitle: true,
      ),
      body: StreamBuilder(
        stream: _snapshots,
        builder: (
          BuildContext context,
          AsyncSnapshot<QuerySnapshot> snapshot,
        ) {
          // Quando ocorre algum erro ao buscar os dados
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }
          // Quando está buscando os dados
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          // Quando está buscando os dados
          if (snapshot.data.documents.length == 0) {
            return Center(
              child: Text('Nenhuma Tarefa Ainda'),
            );
          }

          return ListView.builder(
            itemCount: snapshot.data.documents.length,
            itemBuilder: (BuildContext context, int i) {
              var doc = snapshot.data.documents[i];
              var item = doc.data();
              return Container(
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(10.0),
                ),
                margin: EdgeInsets.all(5.0),
                child: ListTile(
                  leading: IconButton(
                      icon: Icon(
                        item['feito']
                            ? Icons.check_circle
                            : Icons.check_circle_outline,
                        color: item['feito'] ? Colors.orange : Colors.grey,
                        size: 32.0,
                      ),
                      onPressed: () async => await doc.reference.updateData({
                            'feito': !item['feito'],
                          })),
                  trailing: CircleAvatar(
                    foregroundColor: Colors.orange,
                    backgroundColor: Colors.white,
                    child: IconButton(
                        icon: Icon(Icons.delete_forever),
                        onPressed: () async {
                          await doc.reference.delete();
                        }),
                  ),
                  title: Text(item['titulo']),
                  subtitle: Text(item['descricao']),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          modalCreate(context);
        },
        tooltip: 'Adicionar novo',
        child: Icon(Icons.add),
      ),
    );
  }

  void modalCreate(BuildContext context) {
    GlobalKey<FormState> form = GlobalKey<FormState>();

    var _titulo = TextEditingController();
    var _descricao = TextEditingController();

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Criar Nova Tarefa'),
            content: Form(
                key: form,
                child: Container(
                  height: MediaQuery.of(context).size.height / 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Titulo*:'),
                      TextFormField(
                        controller: _titulo,
                        decoration: InputDecoration(
                          hintText: 'Ex.: Comprar Ração',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Este campo não pode ser vazio';
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      Text('Descrição:'),
                      TextFormField(
                        controller: _descricao,
                        decoration: InputDecoration(
                          hintText: 'Ex.: Ir até a venda do seu José',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
            actions: <Widget>[
              FlatButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(
                  'Cancelar',
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ),
              FlatButton(
                onPressed: () async {
                  if (form.currentState.validate()) {
                    await FirebaseFirestore.instance.collection('todo').add({
                      'titulo': _titulo.text,
                      'descricao': _descricao.text,
                      'data': Timestamp.now(),
                      'feito': false,
                    });

                    Navigator.of(context).pop();
                  }
                },
                child: Text(
                  'Criar',
                ),
              ),
            ],
          );
        });
  }
}
